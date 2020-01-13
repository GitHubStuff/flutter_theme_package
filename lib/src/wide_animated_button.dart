import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';

/// Successor to WideButtonWidget, displays a button with subtle tap animation, and optional click sound.
/// Callbacks for Double-Tap, Key-Press-Down/Up, Long-Press, Tap.
/// NOTE: If the double, long, or tap are used the KeyPress only returns down.
/// NOTE: The callback also has the DateTime
/// NOTE: Key-Press is the only one with Key-Up, others only return Key-Down

typedef void PressCallback(WideAnimatedButtonPress action, DateTime dateTime);

enum WideAnimatedButtonPress {
  down,
  up,
}

class WideAnimatedButton extends StatefulWidget {
  /// Add z-axis for 3-D Depth
  final List<BoxShadow> boxShadows;

  /// Widget in the center of the button. Defaults to Text()
  final Widget centerWidget;

  /// If a gradient IS NOT specified, there must be a color
  final Swatch colors;

  /// Display a gradient for the button background, if null use 'color'
  final LinearGradient gradient;

  /// Height of the button
  final double height;

  final PressCallback onDoubleTap;

  /// Callback function to receive button up/down events
  final PressCallback onKeyPress;
  final PressCallback onLongPress;

  final PressCallback onTap;

  /// Play the SystemSoundType.click on press
  final bool playSystemClickSound;

  /// The radius of the button corner ( 25% of height is good )
  /// Default = 10 for a slightly rounded button
  final double radius;

  /// Width of the button
  final double width;

  WideAnimatedButton(
      {Key key,
      this.boxShadows,
      this.centerWidget = const AutoSizeText(
        'PRESS',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      this.colors,
      this.gradient,
      this.height = double.maxFinite,
      this.onDoubleTap,
      this.onKeyPress,
      this.onLongPress,
      this.onTap,
      this.playSystemClickSound = true,
      this.radius = 10.0,
      this.width = double.maxFinite})
      : assert(centerWidget != null),
        assert(gradient != null || colors != null),
        assert(height > 0.0),
        assert(onKeyPress != null),
        assert(radius >= 0.0),
        assert(width > 0.0);

  @override
  _WideAnimatedButtonState createState() => _WideAnimatedButtonState();
}

class _WideAnimatedButtonState extends State<WideAnimatedButton> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;
  LinearGradient _gradient;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    _handler(widget.onKeyPress, false);
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    _handler(widget.onKeyPress, false, WideAnimatedButtonPress.up);
  }

  void _handler(PressCallback function, [bool tick, WideAnimatedButtonPress action = WideAnimatedButtonPress.down]) {
    tick ??= widget.playSystemClickSound;
    assert(action != null);
    if (function != null) {
      if (action == WideAnimatedButtonPress.down && (tick ?? false)) SystemSound.play(SystemSoundType.click);
      function(action, DateTime.now().toUtc());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gradient == null) {
      /// If no gradient was passed, create one with identical begin and end colors
      /// to create a solid button color.
      _gradient = widget.gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.colors.color(context), widget.colors.color(context)],
          );
    }
    _scale = 1 - _controller.value;

    return GestureDetector(
      child: Transform.scale(
        scale: _scale,
        child: _animatedButtonUI,
      ),
      onDoubleTap: () => _handler(widget.onDoubleTap),
      onLongPress: () => _handler(widget.onLongPress),
      onTap: () => _handler(widget.onTap),
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
    );
  }

  Widget get _animatedButtonUI => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: widget.boxShadows,
          gradient: _gradient,
        ),
        child: Center(
          child: widget.centerWidget,
        ),
      );
}

/// Example of box shadow that adds a 0.8-opacity black shadow
/*
BoxShadow(
              color: Color(0x80000000),
              blurRadius: 30.0,
              offset: Offset(0.0, 30.0),
            ),
 */
