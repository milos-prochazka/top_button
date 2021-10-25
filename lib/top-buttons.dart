import 'package:flutter/material.dart';
import 'package:top_button/topbutton.dart';

class TopButtons extends StatefulWidget
{
  final List<TopButtonItem> children;

  TopButtons(this.children);

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> with SingleTickerProviderStateMixin
{
  late AnimationController menuAnimation;
  _TopButtonsMeasure? measure;

  @override
  Widget build(BuildContext context)
  {
    menuAnimation.forward();

    return new Flow
    (
      delegate: _FlowDelegate(menuAnimation: menuAnimation, state: this),
      children:
      [
        /*Text
        (
          'Uvidime jak to dopadne',
          style: TextStyle(backgroundColor: Colors.indigo),
        )*/
        TopButton()
      ],
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
  Widget? child;
  late double relativewidth;

  TopButtonItem({this.id, required this.child, double? relativeWidth})
  {
    this.relativewidth = relativeWidth ?? 1;
  }
}

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
      print("paintChildren $dx ${context.size.height}");
      var s = context.getChildSize(i)!;
      var w = context.size;
      var matrix = Matrix4.diagonal3Values(measure.buttonWidth / s.width, measure.topLineHeight / s.height, 1);
      matrix.setTranslationRaw(0, (dx - 1) * s.height, 0);
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
  double topLineHeight = 350;
  double buttonWidth = 350;
}