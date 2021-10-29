import 'package:flutter/widgets.dart';

class PropertyBinder extends InheritedWidget
{
  final properties = <String, Object>{};

  PropertyBinder({Key? key, required BuildContext context, required WidgetBuilder builder})
  : super(key: key, child: Builder(builder: builder));

  void setProperty(String name, Object value)
  {
    properties[name] = value;
  }

  void removeProperty(String name)
  {
    properties.remove(name);
  }

  Object? getPropertyObject(String name, [Object? defValue])
  {
    if (properties.containsKey(name))
    {
      return properties[name] ?? defValue;
    }
    else
    {
      return defValue;
    }
  }

  T getProperty<T>(String name, T defValue)
  {
    if (properties.containsKey(name))
    {
      final objRes = properties[name];

      if (objRes == null)
      {
        return defValue;
      }
      else
      {
        return (defValue is T) ? objRes as T : defValue;
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

  static void call(BuildContext context, PropertyBinderCaller caller)
  {
    final PropertyBinder? result = context.dependOnInheritedWidgetOfExactType<PropertyBinder>();
    if (result != null)
    {
      caller(result);
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)
  {
    return false;
  }
}

typedef void PropertyBinderCaller(PropertyBinder binder);