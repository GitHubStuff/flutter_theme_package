import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_package/src/mode_theme_data.dart';

/// Button widget that can span the container/screen width.
/// Common button style for Silversphere products.
///
class WideButtonWidget extends StatelessWidget {
  /// Widget wrapped by the button (typically AutoSizeText)
  final Widget child;

  /// Light/Dark mode colors of the button background (default: ModeThemeData.primarySwatch)
  final Swatch colors;

  /// Height of button (default 48.0)
  final double height;

  /// Light/Dark mode colors of a button in highlight state
  final Swatch highlightColor;

  /// Default H:32.0 V:8.0
  final EdgeInsetsGeometry insets;

  /// Callback for longPress
  final GestureLongPressCallback onLongPress;

  /// Callback for onTap
  final GestureTapCallback onTap;

  /// Default double.maxFinite (will stretch the container till padded by 'insets')
  final double width;

  const WideButtonWidget({
    Key key,
    this.child,
    this.colors,
    this.height = 56.0,
    this.highlightColor,
    this.insets = const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
    this.onLongPress,
    @required this.onTap,
    this.width = double.maxFinite,
  })  : assert(height != null, height >= 0.0),
        assert(width != null && width >= 0.0),
        super(key: key);

  /// For common buttons that contain a single line of prompt text.
  /// The text is auto-sized to fit within the button.
  factory WideButtonWidget.prompt(
    String text, {
    Swatch color,
    double height = 48.0,
    Swatch highlightColor,
    EdgeInsetsGeometry insets = const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
    GestureLongPressCallback onLongPress,
    @required GestureTapCallback onTap,
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 24.0, fontFamily: ModeThemeData.fontFamily),
    double width = double.maxFinite,
  }) {
    final textWidget = AutoSizeText(text, maxLines: 1, style: textStyle);
    return WideButtonWidget(
      child: textWidget,
      colors: color,
      height: height,
      highlightColor: highlightColor,
      insets: insets,
      onLongPress: onLongPress,
      onTap: onTap,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colored = colors ?? ModeThemeData.productSwatch;
    final highlighted = highlightColor ?? ModeThemeData.contrastColors;
    return Padding(
      padding: insets,
      child: SizedBox(
        width: width,
        height: height,
        child: RaisedButton(
          child: child,
          color: colored.color(context),
          highlightColor: highlighted.color(context),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () => onTap != null ? onTap() : () {},
          onLongPress: () => onLongPress != null ? onLongPress() : () {},
        ),
      ),
    );
  }
}
