import 'package:flutter/material.dart';

class TopButton extends StatefulWidget
{
  _TopButtonState? _state;
  final GestureTapCallback? onTap;

  TopButton({this.onTap}) {}
  @override
  State<StatefulWidget> createState()
  {
    _state = _TopButtonState(this);
    return _state!;
  }
}

class _TopButtonState extends State<TopButton>
{
  TopButton widget;
  bool _down = false;

  _TopButtonState(this.widget);

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector
    (
      // ------------------------------------------------ //
      onTapDown: (tap)
      {
        setState
        (
          ()
          {
            _down = true;
          }
        );
      },
      // ------------------------------------------------ //
      onTapCancel: ()
      {
        setState
        (
          ()
          {
            _down = false;
          }
        );
      },
      // ------------------------------------------------ //
      onTapUp: (tap)
      {
        setState
        (
          ()
          {
            _down = false;
          }
        );
      },
      // ------------------------------------------------ //
      onTap: ()
      {
        widget.onTap?.call();
      },
      // ------------------------------------------------ //
      child: Container
      (
        height: 150,
        width: 200,
        decoration: BoxDecoration
        (
          //borderRadius: BorderRadius.circular(10),
          color: Color(0xEE000000),
          border: Border.all
          (
            color: Colors.transparent,
            width: 8,
          ),
        ),
        // /---------------------------------------

        // ----------------------------------------
        child: Container
        (
          decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            border: Border.all(color: Colors.white, width: 4)
          ),
          foregroundDecoration: BoxDecoration(color: Color(_down ? 0x6000CCFF : 0x00000000)),
          child: FittedBox
          (
            fit: BoxFit.contain,
            child: Center
            (
              child: Column
              (
                children: <Widget>
                [
                  Text
                  (
                    'Text',
                    style: TextStyle(color: Colors.white, fontSize: 80),
                  ),
                  Image
                  (
                    image: AssetImage('resources/biglock_btn_close.png'),
                    //color: Colors.white,
                    filterQuality: FilterQuality.high,
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}