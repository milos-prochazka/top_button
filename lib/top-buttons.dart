import 'package:flutter/material.dart';
import 'dart:math' as Math;

typedef Widget TopButtonBuilder(BuildContext context, TopButtonItem item);

class TopButtons extends StatefulWidget
{
  final List<TopButtonItem> buttons;
  final TopButtonsControl control = TopButtonsControl();

  TopButtons(this.buttons);

  @override
  State<TopButtons> createState() => _TopButtonsState(this, control);
}

class TopButtonsControl
{
  late _TopButtonsState state;
}

class _TopButtonsState extends State<TopButtons> with SingleTickerProviderStateMixin
{
  late AnimationController menuAnimation;
  _TopButtonsMeasure? measure;
  TopButtons widget;
  final itemsInfo = <TopButtonItem>[];

  _TopButtonsState(this.widget, TopButtonsControl control)
  {
    control.state = this;
  }

  @override
  Widget build(BuildContext context)
  {
    menuAnimation.forward();
    final childList = <Widget>[];
    itemsInfo.clear();

    for (var item in widget.buttons)
    {
      var newWidget = item.builder(context, item);
      itemsInfo.add(item);
      childList.add(newWidget);
    }

    return OrientationBuilder
    (
      builder: (context, orientation)
      {
        measure = null;
        return Flow
        (
          delegate: _FlowDelegate(menuAnimation: menuAnimation, state: this),
          children: childList,
        );
      }
    );
  }

  @override
  void initState()
  {
    super.initState();
    menuAnimation = AnimationController
    (
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }
}

class TopButtonItem
{
  String? id;
  TopButtonBuilder builder;
  late double relativewidth;
  TopButtonType type;
  double viewLeft = 0;
  double viewTop = 0;
  double viewWidth = 0;
  double viewHeight = 0;
  double hideLeft = 0;
  double hideTop = 0;
  double hideWidth = 0;
  double hideHeight = 0;

  TopButtonItem({this.id, required this.type, required this.builder, double? relativeWidth})
  {
    this.relativewidth = relativeWidth ?? 1;
  }
}

enum TopButtonType { top, bottom, left, right, center }

class _FlowDelegate extends FlowDelegate
{
  final Animation<double> menuAnimation;
  final _TopButtonsState state;

  _FlowDelegate({required this.menuAnimation, required this.state}) : super(repaint: menuAnimation);

  @override
  bool shouldRepaint(_FlowDelegate oldDelegate)
  {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  _TopButtonsMeasure calcMeasure(FlowPaintingContext context)
  {
    var result = _TopButtonsMeasure();

    final topList = <TopButtonItem>[];
    final bottomList = <TopButtonItem>[];
    final width = context.size.width;
    final height = context.size.height;
    final landscape = width > height;

    result.landscape = landscape;

    for (var item in state.widget.buttons)
    {
      switch (item.type)
      {
        case TopButtonType.top:
          topList.add(item);
          break;

        case TopButtonType.bottom:
          bottomList.add(item);
          break;

        default:
          break;
      }
    }

    double sumWidth = topList.fold(0.0, (a, b) => a + b.relativewidth);

    if (result.landscape)
    {
      result.topButtonWidth = width / sumWidth;
      result.topLineHeight = result.topButtonWidth / 2;
    }
    else
    {
      result.topButtonWidth = Math.min(width / sumWidth, height / 5);
      result.topLineHeight = result.topButtonWidth;
    }

    double left = 0;
    for (var item in topList)
    {
      item.viewLeft = left;
      item.viewTop = 0;
      item.viewWidth = result.topButtonWidth * item.relativewidth;
      item.viewHeight = result.topLineHeight;
      left += item.viewWidth;
    }

    left = 0;
    for (var item in bottomList)
    {
      item.viewLeft = left;
      item.viewWidth = result.bottomButtonWidth * item.relativewidth;
      item.viewHeight = result.bottomLineHeight;
      item.viewTop = height - item.viewHeight;
      left += item.viewWidth;
    }

    this.state.measure = result;

    return result;
  }

  @override
  void paintChildren(FlowPaintingContext context)
  {
    double dx = menuAnimation.value;
    final measure = state.measure ?? calcMeasure(context);

    for (int i = 0; i < context.childCount; ++i)
    {
      var info = state.itemsInfo[i];

      print("paintChildren $dx ${context.size.height}");
      var s = context.getChildSize(i)!;
      var w = context.size;

      var matrix = Matrix4.diagonal3Values(info.viewWidth / s.width, info.viewHeight / s.height, 1);
      matrix.setTranslationRaw(info.viewLeft * dx, (dx - 1) * info.viewHeight, 0);
      //matrix.translate(-s.width * 0.5, -s.height * 0.5, 0.0);
      //matrix.rotateZ(0.1);
      //matrix.translate(s.width * 0.5, s.height * 0.5, 0.0);
      //matrix.translate(10.0,1.0,0.0);

      //matrix.translate(10,10.0,0.0);
      context.paintChild
      (
        i,
        transform: matrix,
      );
    }
  }
}

class _TopButtonsMeasure
{
  bool landscape = false;
  double topLineHeight = 100;
  double topButtonWidth = 100;
  double bottomLineHeight = 100;
  double bottomButtonWidth = 100;
}