import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';

///
/// Creates a parent scaffold that wraps the child scaffold
/// allowing for a progress indicator widget and progress message
/// to show while the 'hide' property is false.
///
/// NOTE:
///   hide == true returns the original scaffold
///   hide == false returns the original scaffold wrapped in another scaffold
///           that displays an overlay.
///
class HudScaffold extends StatelessWidget {
  /// Light/Dark mode colors of the layer on top of the scaffold (default: Black/Brown at 0.8 opacity)
  final Swatch backgroundColors;

  /// If true the layer is dismissible with a tap (default: False)
  final bool dismissible;

  /// if true returns the original scaffold (that is removes the layer), if false applies the layer
  final bool hide;

  /// Offset on the screen the progressIndicator and progressMessage should appear (default: Center)
  final Offset offset;

  /// Usually a spinning widget to provide active feedback while the HUD is displayed.
  final Widget progressIndicator;

  /// Optional message widget (typically AutoAdjustedText) that display below the progressIndicator
  final Widget progressMessage;

  /// The parent widget that will appear below the HUD
  final Scaffold scaffold;

  const HudScaffold({
    Key key,
    this.backgroundColors,
    this.dismissible = false,
    @required this.hide,
    this.offset,
    this.progressIndicator,
    this.progressMessage,
    @required this.scaffold,
  })  : assert(scaffold != null),
        assert(hide != null),
        assert(dismissible != null),
        super(key: key);

  /// Factory to display circular spinner and optional message on the HUD.
  factory HudScaffold.progressText(
    /// BuildContext needed because of calls to Theme and ModeThemeData require context
    ///
    BuildContext context, {
    Key key,

    /// Light/Dark mode colors for the layer between the scaffold and the HUD (default: Black/Brown)
    Swatch backgroundColors,

    /// True HUD is dismissible by touch
    bool dismissible = false,

    /// True the layer and HUD are dismissed/hidden, false the layer and HUD are shown
    @required bool hide,

    /// Colors that is applied spinner created spinner and AdjustedText built with 'progressText'
    /// (default: ModeThemeData.productSwatch)
    Swatch indicatorColors,

    /// Offset for the spinner and progressText (default: center)
    Offset offset,

    /// String that will be wrapped in AdjustedSize widget with either 'indicatorColors' or ModeThemeData.productSwatch colors.
    @required String progressText,

    /// Parent scaffold that is layered over with the HUD
    @required Scaffold scaffold,

    /// Size of the spinner
    Size size = const Size(56.0, 56.0),
  }) {
    assert(context != null);
    assert(size != null && size.height != null && size.width != null);
    final indicatorColor = (indicatorColors ?? ModeThemeData.productSwatch).color(context);
    final _progressMessage = AutoSizeText(
      progressText ?? '',
      style: Theme.of(context).textTheme.title.copyWith(color: indicatorColor),
    );
    final _progressIndicator = SizedBox(
      child: ModeThemeData.getCircularProgressIndicator(context, colors: indicatorColors),
      height: size.height,
      width: size.width,
    );
    return HudScaffold(
      key: key,
      backgroundColors: backgroundColors,
      dismissible: dismissible,
      hide: hide,
      offset: offset,
      progressIndicator: _progressIndicator,
      progressMessage: _progressMessage,
      scaffold: scaffold,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If not displaying the overlay just return the scaffold
    if (hide) return scaffold;
    Widget layOutProgressIndicator;
    if (offset == null)
      layOutProgressIndicator = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            progressIndicator ?? Container(),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: progressMessage ?? Container(),
            ),
          ],
        ),
      );
    else {
      layOutProgressIndicator = Positioned(
        child: progressIndicator ?? Container(),
        left: offset.dx,
        top: offset.dy,
      );
    }

    final _backgroundColor = (backgroundColors ?? Swatch(bright: Colors.black, dark: Colors.brown, alpha: 0.80)).color(context);
    return Scaffold(
      body: Stack(
        children: [
          scaffold,
          ModalBarrier(dismissible: dismissible, color: _backgroundColor),
          layOutProgressIndicator,
        ],
      ),
    );
  }
}
