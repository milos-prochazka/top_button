import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:top_button/top-buttons.dart';
import 'package:top_button/topbutton.dart';

import 'PropertyBinder.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    final p = BindableProperty('aaa', 'lojza');
    final cmp = p.compare('lojza');

    return MaterialApp
    (
      title: 'Flutter Demo',
      navigatorObservers: [defaultLifecycleObserver],
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with LifecycleAware, LifecycleMixin
{
  int _counter = 0;

  @override
  void onLifecycleEvent(LifecycleEvent event)
  {
    print(event);
  }

  void _incrementCounter()
  {
    setState
    (
      ()
      {
        _counter++;
      }
    );
  }

  @override
  Widget build(BuildContext context1)
  {
    return PropertyBinder
    (
      context: context1,
      builder: (context)
      {
        return Scaffold
        (
          appBar: AppBar
          (
            title: Text(widget.title),
          ),
          body: SafeArea
          (
            child: TopButtons
            (
              [
                TopButtonItem
                (
                  type: TopButtonType.top,
                  builder: (c, i)
                  {
                    return TopButton();
                  }
                ),
                TopButton.createItem(id: 'a', type: TopButtonType.top, relativeWidth: 1.5, text: 'Tlac 2'),
                TopButton.createItem(id: 'b', type: TopButtonType.bottom, relativeWidth: 1, text: 'Tlac B1'),
                TopButton.createItem(id: 'c', type: TopButtonType.bottom, relativeWidth: 1, text: 'Tlac B2'),
                TopButton.createItem(id: 'd', type: TopButtonType.bottom, relativeWidth: 1, text: 'Tlac B3'),
              ],
              backgroundColor: Color.fromARGB(0xcc, 0x20, 0x40, 0x40),
              foregroundColor: Colors.white70,
              event: (param)
              {
                var i = param.cmdType;
                PropertyBinder.doOn
                (
                  context, (binder)
                  {
                    var c = binder.getProperty('cnt', 0.0);
                    binder.setProperty('cnt', c + 1.0);
                  }
                );
              },
            )
          ),

          floatingActionButton: FloatingActionButton
          (
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }
    );
  }

  void onTap()
  {
    var x = 1;
  }
}