///
/// IconData iconHide - icon of invisible state (default is eyeball with slash)
/// IconData iconShow - icon of visible state (default is eyeball)
/// bool isHideable - enables/disables ability to toggle the field
/// bool startShown - initial visibility property
///
import 'package:flutter/material.dart';
import 'package:flutter_mode_color/flutter_mode_color.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';

/// Widget that expands on the TextFormField with the addition of
/// an icon to show/hide the content of the field (eg: Password field).

class MaskableFormField extends StatefulWidget {
  /// see [TextFormField]
  final TextEditingController controller;

  /// see [TextFormField]
  final FocusNode focusNode;

  /// Light/Dark colors for iconHide and iconShow (default = ModeThemeData.iconColors)
  final ModeColor iconColors;

  /// Icon data when the state is to show text (is source of tap, default is Icons.visibility_off)
  final IconData iconHide;

  /// Icon data when the state is to obscure the text (is source of tap, default is Icons.visibility)
  final IconData iconShow;

  /// If true the field can be toggled to show/hide text and change iconHide/iconShow (default: true)
  final bool isHideable;

  /// Text that appears in the field when first created (default is empty)
  final String initialValue;

  /// Text of the label field
  final String labelText;

  /// If true the text is NOT covered/obscured (default: false, null => false)
  final bool startShown;

  /// Applied to the TextFormField (null && default => Theme.of(context).textTheme.headline)
  final TextStyle style;

  /// see [TextFormField]
  final TextInputAction textInputAction;

  /// see [TextFormField]
  final TextInputType textInputType;

  /// see [TextFormField]
  final ValueChanged<String> onSubmitted;

  /// see [TextFormField]
  final FormFieldValidator<String> validator;

  const MaskableFormField({
    Key key,
    @required this.controller,
    this.focusNode,
    this.iconColors,
    this.iconHide = Icons.visibility_off,
    this.iconShow = Icons.visibility,
    this.initialValue,
    this.isHideable = true,
    @required this.labelText,
    this.onSubmitted,
    this.startShown = false,
    this.style,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.validator,
  })  : assert(controller != null),
        assert(iconHide != null),
        assert(iconShow != null),
        assert(isHideable != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MaskableFormFieldState();
}

class _MaskableFormFieldState extends State<MaskableFormField> {
  bool _showMaskable;

  @override
  void initState() {
    _showMaskable = (widget.startShown ?? false) || !widget.isHideable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Apply style and color of user provided and theme defaults (critical to be able manage light/dark mode state)
    final _textStyle = widget.style ?? Theme.of(context).textTheme.headline;
    final _iconColor = widget.iconColors ?? ModeThemeData.iconColors;
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: !widget.isHideable
            ? null
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _showMaskable = !_showMaskable;
                  });
                },
                child: Icon(
                  _showMaskable ? widget.iconShow : widget.iconHide,
                  color: _iconColor.color(context),
                ),
              ),
      ),
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      keyboardType: widget.textInputType,
      obscureText: !_showMaskable,
      onFieldSubmitted: widget.onSubmitted,
      style: _textStyle,
      validator: (String value) => widget.validator(value),
    );
  }
}
