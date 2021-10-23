import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget
{
  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> with SingleTickerProviderStateMixin
{
  late AnimationController menuAnimation;

  @override
  Widget build(BuildContext context)
  {
    menuAnimation.forward();

    return new Flow
    (
      delegate: _FlowDelegate(menuAnimation: menuAnimation),
      children:
      [
        Text
        (
          'Uvidime jak to dopadne',
          style: TextStyle(backgroundColor: Colors.indigo),
        )
      ],
    );
  }

  @override
  void initState()
  {
    super.initState();
    menuAnimation = AnimationController
    (
      duration: const Duration(milliseconds: 250),
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

  _FlowDelegate({required this.menuAnimation}) : super(repaint: menuAnimation);

  @override
  bool shouldRepaint(_FlowDelegate oldDelegate)
  {
    return true; //menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context)
  {
    double dx = menuAnimation.value;
    for (int i = 0; i < context.childCount; ++i)
    {
      print("paintChildren $dx");
      var s = context.getChildSize(i)!;
      var matrix = Matrix4.diagonal3Values(1, 1, 1);
      matrix.setTranslationRaw(1, (dx - 1) * s.height, 1);
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