import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mode_color/flutter_mode_color.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';
import 'package:flutter_tracers/trace.dart' as Log;

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

/// Button height if none is supplied
const _defaultHeight = 64.0;

class WideAnimatedButton extends StatefulWidget {
  /// Add z-axis for 3-D Depth
  final List<BoxShadow> boxShadows;

  /// String applied to center of button {default 'Press' if null}
  final String caption;

  /// Widget in the center of the button. Defaults to Text()
  final Widget centerWidget;

  /// If a gradient IS NOT specified, there must be a color
  final ModeColor colors;

  /// Display a gradient for the button background, if null use 'color'
  final LinearGradient gradient;

  /// Height of the button
  final double height;

  final PressCallback onDoubleTap;

  /// Callback function to receive button up/down events
  final PressCallback onKeyPress;
  final PressCallback onLongPress;
  final PressCallback onTap;

  /// Padding
  final EdgeInsets padding;

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
      this.caption = 'Press',
      this.centerWidget,
      this.colors,
      this.gradient,
      this.height = _defaultHeight,
      this.onDoubleTap,
      this.onKeyPress,
      this.onLongPress,
      this.onTap,
      this.padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      this.playSystemClickSound = true,
      this.radius = 10.0,
      this.width = double.maxFinite})
      : assert(centerWidget != null || caption != null),
        assert(height > 0.0),
        assert(radius >= 0.0),
        assert(width > 0.0);

  @override
  _WideAnimatedButtonState createState() => _WideAnimatedButtonState();
}

class _WideAnimatedButtonState extends State<WideAnimatedButton> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    Log.t('InitState WideAnimatedButton caption = ${widget.caption}');

    /// AnimationController to do the scaling effect when the button is pressed
    animationController = AnimationController(
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
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Log.t('WideAnimatiedButton build()');
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: GestureDetector(
        child: Transform.scale(
          scale: 1.0 - animationController.value,
          child: animatedButtonUI(),
        ),
        onDoubleTap: () {
          Log.t('wide_animtated_button: onDoubleTap callback ${widget.onDoubleTap.toString()}');
          handler(widget.onDoubleTap);
        },
        onLongPress: () {
          Log.t('wide_animtated_button: onLongPress callback ${widget.onLongPress.toString()}');
          handler(widget.onLongPress);
        },
        onTap: () {
          Log.t('wide_animtated_button: onTap callback ${widget.onTap.toString()}');
          handler(widget.onTap);
        },
        onTapDown: onTapDown,
        onTapUp: onTapUp,
      ),
    );
  }

  /// Create the container for the button before the center widget is applied
  /// this keeps from having a deeply nested widget tree
  Widget animatedButtonUI() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: widget.boxShadows,
        gradient: getGradient(),
      ),
      child: Center(
        child: centerWidget(),
      ),
    );
  }

  /// Create the widget in the center of the button, either by returning the supplied
  /// widget (widget.centerWidget), or composing a AutoSizeText using the provided caption string
  Widget centerWidget() => (widget.centerWidget != null)
      ? widget.centerWidget
      : AutoSizeText(
          widget.caption,
          style: TextStyle(
            fontSize: (widget.height ?? _defaultHeight) * 0.45,
            fontWeight: FontWeight.bold,
          ),
        );

  /// Return the value pass for gradient, if null then create a solid color gradient by passing
  /// the Product modeColor as both the start and end colors
  LinearGradient getGradient() {
    final colors = widget.colors ?? ModeThemeData.productModeColor;
    return widget.gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.color(context), colors.color(context)],
        );
  }

  /// Common handler for all the taps, double tap, long press etc handled by the widget
  void handler(PressCallback function, [bool tick, WideAnimatedButtonPress action = WideAnimatedButtonPress.down]) {
    tick ??= widget.playSystemClickSound;
    assert(action != null);
    if (function != null) {
      /// If the caller requested a keyclick sound, make sure it is only on the down press
      if (action == WideAnimatedButtonPress.down && (tick ?? false)) SystemSound.play(SystemSoundType.click);
      function(action, DateTime.now().toUtc());
    }
  }

  /// Handler method for tap down makes the animate controller 'compress' the button image
  void onTapDown(TapDownDetails details) {
    animationController.forward();
    handler(widget.onKeyPress, false);
  }

  /// Handler method on the tap up to resize the button image back to its layout size
  void onTapUp(TapUpDetails details) {
    animationController.reverse();
    handler(widget.onKeyPress, false, WideAnimatedButtonPress.up);
  }
}

/// Example of box shadow that adds a 0.8-opacity black shadow
/*
BoxShadow(
              color: Color(0x80000000),
              blurRadius: 30.0,
              offset: Offset(0.0, 30.0),
            ),
 */
