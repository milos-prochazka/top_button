import 'package:flutter/widgets.dart';

class PropertyBinder extends InheritedWidget
{
  final events = <PropertyOnChange>[];
  final properties = <String, BindableProperty>{};

  PropertyBinder({Key? key, required BuildContext context, required WidgetBuilder builder})
  : super(key: key, child: Builder(builder: builder));

  /// Nastaveni property - Kontroluje zda se meni hodnota property. Pokud ano nastavi novou hodnmotu a vyvola
  /// handlery udalosti.
  ///
  /// - [key] Nazev property
  /// - [value] Hodnota property
  void setProperty(String key, dynamic value)
  {
    if (!properties.containsKey(key))
    {
      properties[key] = BindableProperty(key, value);
    }
    else
    {
      properties[key]?.setValue(this, value);
    }
  }

  /// Nucene nastaveni property - nekontroluje se zmena. Vzdy se vyvolaji handlery udalosti.
  ///
  /// - [key] Nazev property
  /// - [value] Hodnota property
  void forceProperty(String key, dynamic value)
  {
    if (!properties.containsKey(key))
    {
      properties[key] = BindableProperty(key, value);
    }
    else
    {
      properties[key]?.setValue(this, value);
    }
  }

  void _setOnChange(String? key, PropertyOnChange onChange)
  {
    if (key == null)
    {
      if (!this.events.contains(onChange))
      {
        this.events.add(onChange);
      }
    }
    else
    {
      BindableProperty prop;
      if (!properties.containsKey(key))
      {
        prop = BindableProperty(key, null);
        properties[key] = prop;
      }
      else
      {
        prop = properties[key]!;
      }

      if (!prop.events.contains(onChange))
      {
        prop.events.add(onChange);
      }
    }
  }

  void removeProperty(String key)
  {
    properties.remove(key);
  }

  dynamic getPropertyDynamic(String key, [dynamic defValue])
  {
    if (properties.containsKey(key))
    {
      return properties[key]?.value ?? defValue;
    }
    else
    {
      return defValue;
    }
  }

  BindableProperty getOrCreateBindableProperty(String key, [dynamic defValue])
  {
    if (properties.containsKey(key))
    {
      return properties[key]!;
    }
    else
    {
      var result = BindableProperty(key, defValue);
      properties[key] = result;
      return result;
    }
  }

  T getProperty<T>(String name, T defValue)
  {
    if (properties.containsKey(name))
    {
      final prop = properties[name];

      if (prop == null)
      {
        return defValue;
      }
      else
      {
        return (prop.value is T) ? prop.value as T : defValue;
      }
    }
    else
    {
      return defValue;
    }
  }

  static PropertyBinder of(BuildContext context)
  {
    final PropertyBinder? result = context.dependOnInheritedWidgetOfExactType<PropertyBinder>();
    assert(result != null, 'No PropertyBinder found in context');
    return result!;
  }

  static T ofT<T extends PropertyBinder>(BuildContext context)
  {
    final result = context.dependOnInheritedWidgetOfExactType<T>();
    assert(result != null, 'No PropertyBinder found in context');
    return result!;
  }

  static void doOn(BuildContext context, PropertyBinderDoOn caller)
  {
    final PropertyBinder? result = context.dependOnInheritedWidgetOfExactType<PropertyBinder>();
    if (result != null)
    {
      caller(result);
    }
  }

  static void doOnT<T extends PropertyBinder>(BuildContext context, PropertyBinderDoOn caller)
  {
    try
    {
      final T? result = context.dependOnInheritedWidgetOfExactType<T>();
      if (result != null)
      {
        caller(result);
      }
    }
    catch ($) {}
  }

  static void doOnProperty(BuildContext context, String key, PropertyBinderDoOnProperty caller)
  {
    final PropertyBinder? binder = context.dependOnInheritedWidgetOfExactType<PropertyBinder>();
    if (binder != null)
    {
      caller(binder, binder.getOrCreateBindableProperty(key, null));
    }
  }

  static void doOnPropertyT<T>(BuildContext context, String key, T defValue, PropertyBinderDoOnProperty caller)
  {
    final PropertyBinder? binder = context.dependOnInheritedWidgetOfExactType<PropertyBinder>();
    if (binder != null)
    {
      caller(binder, binder.getOrCreateBindableProperty(key, defValue));
    }
  }

  @override
  bool updateShouldNotify(covariant PropertyBinder oldWidget)
  {
    return true;
  }
}

typedef PropertyBinderDoOn = void Function(PropertyBinder binder);
typedef PropertyBinderDoOnProperty = void Function(PropertyBinder binder, BindableProperty property);

class BindableProperty
{
  final events = <PropertyOnChange>[];
  final String key;
  late dynamic value;

  BindableProperty(this.key, this.value);

  bool compare(dynamic other)
  {
    bool result = false;

    try
    {
      final c1 = value as Comparable;

      result = c1.compareTo(other) == 0;
    }
    catch (_) {}

    return result;
  }

  T valueT<T>([T? defValue])
  {
    if (value is T)
    {
      return value as T;
    }
    else
    {
      return defValue!;
    }
  }

  void forceValue(PropertyBinder binder, dynamic newValue)
  {
    this.value = newValue;

    events.forEach
    (
      (element)
      {
        element(binder, this);
      }
    );

    binder.events.forEach
    (
      (element)
      {
        element(binder, this);
      }
    );
  }

  void setValue(PropertyBinder binder, dynamic newValue)
  {
    if (!compare(newValue))
    {
      forceValue(binder, newValue);
    }
  }
}

typedef void PropertyOnChange(PropertyBinder binder, BindableProperty property);

/// Stav property binderu slouzi k pripojeni a odpojeni udalosti k jednotlivym property.
/// Stav je nutne uchovavat na urovni StatefulWidgetu a uvolnit vsechny navazane property ve behem [bind]
/// ```dart
/// class _MyHomePageState extends State<MyHomePage>
/// {
///   PropertyBinderState? binderState;
///
///   @override
///   Widget build(BuildContext buildContext)
///   {
///      . . .
///      bind(context);
///      . . .
///      // Zmena hodnoty property cnt
///      PropertyBinder.doOnProperty
///      (
///        context, 'cnt', (binder, property)
///        {
///            var cnt = property.valueT(0.0);
///            property.setValue(binder, cnt + 1);
///        }
///      );
///      . . .
///   }
///
///   // Pripojeni property cnt a vypsani jeji hodnoty po kazde zmene
///   void bind(BuildContext context)
///   {
///      binderState = PropertyBinderState.createOrChange(PropertyBinder.of(context), binderState);
///      binderState!.setOnChange
///      (
///        'cnt', (binder, property)
///        {
///          print('cnt = ${property.value as double}');
///        }
///    );
///
/// }
/// ```
///
class PropertyBinderState
{
  final eventList = <_PropertyBinderStackItem>[];
  final PropertyBinder binder;

  PropertyBinderState._(this.binder);

  static PropertyBinderState createOrChange(PropertyBinder binder, [PropertyBinderState? binderStack])
  {
    if (binderStack != null)
    {
      binderStack.dispose();
    }

    final newStack = PropertyBinderState._(binder);

    return newStack;
  }

  void setOnChange(String? name, PropertyOnChange onChange)
  {
    if (!eventList.contains(onChange))
    {
      binder._setOnChange(name, onChange);
    }
  }

  void dispose()
  {
    eventList.forEach
    (
      (element)
      {
        if (element.name == null) {}
      }
    );
  }
}

class _PropertyBinderStackItem
{
  String? name;
  late PropertyOnChange change;

  _PropertyBinderStackItem(this.name, this.change);
}