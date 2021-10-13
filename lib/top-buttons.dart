import 'package:flutter/material.dart';



class TopButtons extends Flow
{
  static var myDelegate;

  TopButtons() : super(delegate: _FlowDelegate());
  
}

class _FlowDelegate implements FlowDelegate
{
  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // TODO: implement getConstraintsForChild
    throw UnimplementedError();
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // TODO: implement getSize
    throw UnimplementedError();
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: implement paintChildren
  }

  @override
  bool shouldRelayout(covariant FlowDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    throw UnimplementedError();
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
  
}