import 'package:flutter/material.dart';

/// Font sizes for the TextTheme.
/// These are set here as they are used when creating light/dark mode for TextThemes.
double get display4Size => 114.0;
double get display3Size => 56.0;
double get display2Size => 45.0;
double get display1Size => 34.0;
double get headlineSize => 24.0;
double get titleSize => 20.0;
double get subtitleSize => 18.0;
double get subheadSize => 16.0;
double get body2Size => 14.0;
double get body1Size => 14.0;
double get captionSize => 12.0;
double get buttonFontSize => 24.0;

enum TextSizes { display4, display3, display2, display1, headline, title, subtitle, subhead, body2, body1, caption, button }

double getTextSizes(TextSizes textSize) {
  switch (textSize) {
    case TextSizes.display4:
      return display4Size;
    case TextSizes.display3:
      return display3Size;
    case TextSizes.display2:
      return display2Size;
    case TextSizes.display1:
      return display1Size;
    case TextSizes.headline:
      return headlineSize;
    case TextSizes.title:
      return titleSize;
    case TextSizes.subtitle:
      return subtitleSize;
    case TextSizes.subhead:
      return subheadSize;
    case TextSizes.body2:
      return body2Size;
    case TextSizes.body1:
      return body1Size;
    case TextSizes.caption:
      return captionSize;
    case TextSizes.button:
      return buttonFontSize;
  }
  throw Exception('Unknown size ${textSize.toString()}');
}

/// Wrapper class for colors pairs for bright/light and dark modes
class Swatch {
  /// Create getter to prevent changes after instance creation
  Color get bright => _bright;
  Color get dark => _dark;
  Color _bright;
  Color _dark;

  Swatch({@required Color bright, @required Color dark, double alpha = 1.0, double darkAlpha}) {
    assert(bright != null);
    assert(dark != null);
    assert(alpha != null && (alpha >= 0.0 || alpha <= 1.0));
    int red = bright.red;
    int green = bright.green;
    int blue = bright.blue;
    _bright = Color.fromARGB((255.0 * alpha).toInt(), red, green, blue);
    red = dark.red;
    green = dark.green;
    blue = dark.blue;
    _dark = Color.fromARGB((255.0 * (darkAlpha ?? alpha)).toInt(), red, green, blue);
  }

  factory Swatch.mono({@required Color color, double alpha = 1.0}) {
    return Swatch(bright: color, dark: color, alpha: alpha);
  }

  Color colorFor({Brightness brightness}) {
    return (brightness == Brightness.light) ? bright : dark;
  }

  Color color(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return colorFor(brightness: brightness);
  }
}

class ModeThemeData {
  /// The following collection of color pairs (swatches) are used when constructing ThemeData to the color
  /// properties of widgets, text, backgrounds, etc.
  /// Any changes to these swatches requires a re-build of the widget tree: ModeTheme.of(context).setBrightness(brightness);
  /// -----------------------------------------------------------------------------------------------------------------------------
  /// Color pair that has the highest contracts in colors (eg: Brightness.Light would have a contrast of Colors.black)
  static Swatch contrastColors = Swatch(bright: Colors.black87, dark: Colors.white54);

  /// Color pair when widget (eg a button) is disabled
  static Swatch disabledColors = Swatch(bright: Colors.grey, dark: Colors.blueGrey);

  /// Color pair to add brightness to icons to make sure they are visible in light/dark modes
  static Swatch iconBrightness = Swatch(bright: Colors.grey, dark: Colors.black45);

  /// Color pair for icon color
  static Swatch iconColors = Swatch(bright: Colors.black87, dark: Colors.white70);

  /// Color pair for primaryColor in a theme
  static Swatch primarySwatch = Swatch(bright: Colors.green, dark: Colors.grey);

  /// Color pair to have an app-specific coloring for widgets
  static Swatch productSwatch = Swatch(bright: Colors.orangeAccent, dark: Colors.amber);

  /// Color pair for the background of scaffold (the screen palette)
  static Swatch scaffoldColors = Swatch(bright: Colors.white, dark: Colors.black);

  static CircularProgressIndicator _circularProgressIndicator;

  static CircularProgressIndicator getCircularProgressIndicator(BuildContext context, {Swatch colors}) {
    final color = (colors ?? productSwatch).color(context);
    return _circularProgressIndicator ??
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        );
  }

  static void setCircularProgressIndicator(CircularProgressIndicator indicator) => _circularProgressIndicator = indicator;

  /// ButtonTheme is set to popular/most-common use settings. As with Swatch changes the widget tree requires a re-build
  static setButtonTheme({Swatch swatch, double height = 42.0, ShapeBorder shape}) {
    assert(swatch != null && swatch.bright != null && swatch.dark != null);
    assert(height > 0.0);
    shape ??= RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
    _buttonStyleBright = ButtonThemeData(
      buttonColor: swatch.bright,
      disabledColor: disabledColors.bright,
      height: height,
      shape: shape,
    );
    _buttonStyleDark = ButtonThemeData(
      buttonColor: swatch.dark,
      disabledColor: disabledColors.dark,
      height: height,
      shape: shape,
    );
  }

  /// Internal state for button themes
  static ButtonThemeData _buttonStyleBright = ButtonThemeData(
    buttonColor: productSwatch.bright,
    disabledColor: disabledColors.bright,
    height: 42.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  static ButtonThemeData _buttonStyleDark = ButtonThemeData(
    buttonColor: productSwatch.dark,
    disabledColor: disabledColors.dark,
    height: 42.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  static IconThemeData _iconThemeDataBright() => IconThemeData(color: iconBrightness.bright);
  static IconThemeData _iconThemeDataDark() => IconThemeData(color: iconBrightness.dark);

  static InputDecorationTheme _inputDecorationThemeBright() => InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: contrastColors.dark),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: contrastColors.dark),
      ),
      hintStyle: TextStyle(color: contrastColors.dark),
      labelStyle: TextStyle(color: contrastColors.dark));

  static InputDecorationTheme _inputDecorationThemeDark() => InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: contrastColors.bright),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: contrastColors.bright),
      ),
      hintStyle: TextStyle(color: contrastColors.bright),
      labelStyle: TextStyle(color: contrastColors.bright));

  /// The typography used throughout an app (iOS is just better looking)
  static final Typography _kTypography = new Typography(platform: TargetPlatform.iOS);

  /// Fonts used throughout the theme.
  static const String fontFamily = 'Roboto';

  static final TextTheme _kTextThemeWhite = _kTypography.white.copyWith(
    display4: _kTypography.white.display4.copyWith(fontFamily: fontFamily, fontSize: display4Size),
    display3: _kTypography.white.display3.copyWith(fontFamily: fontFamily, fontSize: display3Size),
    display2: _kTypography.white.display2.copyWith(fontFamily: fontFamily, fontSize: display2Size),
    display1: _kTypography.white.display1.copyWith(fontFamily: fontFamily, fontSize: display1Size),
    headline: _kTypography.white.headline.copyWith(fontFamily: fontFamily, fontSize: headlineSize),
    title: _kTypography.white.title.copyWith(fontFamily: fontFamily, fontSize: titleSize),
    subtitle: _kTypography.white.subhead.copyWith(fontFamily: fontFamily, fontSize: subtitleSize),
    subhead: _kTypography.white.subhead.copyWith(fontFamily: fontFamily, fontSize: subheadSize),
    body2: _kTypography.white.body2.copyWith(fontFamily: fontFamily, fontSize: body2Size, fontWeight: FontWeight.bold),
    body1: _kTypography.white.body1.copyWith(fontFamily: fontFamily, fontSize: body1Size),
    caption: _kTypography.white.caption.copyWith(fontFamily: fontFamily, fontSize: captionSize),
    button: _kTypography.white.button.copyWith(
      fontFamily: fontFamily,
      fontSize: buttonFontSize,
      color: productSwatch.bright,
    ),
  );

  static final TextTheme _kTextThemeBlack = _kTypography.black.copyWith(
      display4: _kTypography.black.display4.copyWith(fontFamily: fontFamily, fontSize: display4Size),
      display3: _kTypography.black.display3.copyWith(fontFamily: fontFamily, fontSize: display3Size),
      display2: _kTypography.black.display2.copyWith(fontFamily: fontFamily, fontSize: display2Size),
      display1: _kTypography.black.display1.copyWith(fontFamily: fontFamily, fontSize: display1Size),
      headline: _kTypography.black.headline.copyWith(fontFamily: fontFamily, fontSize: headlineSize),
      title: _kTypography.black.title.copyWith(fontFamily: fontFamily, fontSize: titleSize),
      subtitle: _kTypography.black.title.copyWith(fontFamily: fontFamily, fontSize: subtitleSize),
      subhead: _kTypography.black.subhead.copyWith(fontFamily: fontFamily, fontSize: subheadSize),
      body2: _kTypography.black.body2.copyWith(fontFamily: fontFamily, fontSize: body2Size, fontWeight: FontWeight.bold),
      body1: _kTypography.black.body1.copyWith(fontFamily: fontFamily, fontSize: body1Size),
      caption: _kTypography.black.caption.copyWith(fontFamily: fontFamily, fontSize: captionSize),
      button: _kTypography.black.button.copyWith(
        fontFamily: fontFamily,
        fontSize: buttonFontSize,
        color: productSwatch.dark,
      ));

  /// Constructor to create BRIGHT-mode theme data with all the variations detailed by the swatches and text builds
  static ThemeData bright() {
    return _setter(brightness: Brightness.light);
  }

  /// Constructor to create DARK-mode theme data with all the variations detailed by the swatches and text builds
  static ThemeData dark() {
    return _setter(brightness: Brightness.dark);
  }

  /// Common background constructor creates Theme data for light and dark modes
  static ThemeData _setter({Brightness brightness}) {
    final isBright = (brightness == Brightness.light);
    return ThemeData().copyWith(
      accentColor: isBright ? productSwatch.bright : productSwatch.dark,
      accentIconTheme: IconThemeData(color: isBright ? iconColors.bright : iconColors.dark),
      brightness: isBright ? Brightness.light : Brightness.dark,
      buttonTheme: isBright ? _buttonStyleBright : _buttonStyleDark,
      buttonColor: isBright ? productSwatch.bright : productSwatch.dark,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: isBright ? productSwatch.bright : productSwatch.dark),
      iconTheme: IconThemeData(color: isBright ? iconColors.bright : iconColors.dark),
      inputDecorationTheme: !isBright ? _inputDecorationThemeBright() : _inputDecorationThemeDark(),
      primaryColor: isBright ? primarySwatch.bright : primarySwatch.dark,
      primaryIconTheme: isBright ? _iconThemeDataBright() : _iconThemeDataDark(),
      scaffoldBackgroundColor: isBright ? scaffoldColors.bright : scaffoldColors.dark,
      textTheme: isBright ? _kTextThemeBlack : _kTextThemeWhite,
    );
  }
}
