import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget
{
  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons>
{
  @override
  Widget build(BuildContext context)
  {
    return new Flow
    (
      delegate: _FlowDelegate(),
      children: [Text('Uvidime jak to dopadne')],
    );
  }
}

/*class TopButtons extends Flow
{
  static var myDelegate;

  TopButtons() : super(delegate: _FlowDelegate());


}*/

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
  @override
  void paintChildren(FlowPaintingContext context)
  {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i)
    {
      var s = context.getChildSize(i)!;
      var matrix = Matrix4.diagonal3Values(1, 1, 1);
      matrix.translate(-s.width * 0.5, -s.height * 0.5, 0.0);
      matrix.rotateZ(0.1);
      matrix.translate(s.width * 0.5, s.height * 0.5, 0.0);
      //matrix.translate(10.0,1.0,0.0);

      //matrix.translate(10,10.0,0.0);
      context.paintChild
      (
        i,
        transform: matrix,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate)
  {
    // TODO: implement shouldRepaint
    return false;
  }
}