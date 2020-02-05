import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';

/// Widget that will fetch an image from the url and display in Oval shaped container, also has places holders for loading, and
/// can display an image if there is a network error. The displayed image is tap/long-press capable, and fade-in from loading to
/// image can be set.
///
class OvalImageTouchWidget extends StatefulWidget {
  /// Time between placeholder display and transition to downloaded image (default: 250ms)
  final Duration duration;

  /// Callback with (context, url, error) information if there is a network error (should/can return a network error widget)
  final LoadingErrorWidgetBuilder error;

  /// Callback to handle longPress
  final GestureLongPressCallback onLongPress;

  /// Callback to handle tap
  final GestureTapCallback onTap;

  /// Widget displayed while network loading occurs
  final Widget placeholder;

  /// Container size of the widget when complete/progress/error (default: 60.0x60.0, cannot be null)
  final Size size;

  /// URL of the target image (needs to return image file {.png, .gif, .jpg,...})
  final String url;

  OvalImageTouchWidget({
    Key key,
    this.duration = const Duration(milliseconds: 250),
    this.error,
    this.onLongPress,
    this.onTap,
    this.placeholder,
    this.size = const Size(60.0, 60.0),
    @required this.url,
  })  : assert(size != null && size.width != null, size.height != null),
        super(key: key);

  /// Factory to allow application image assets to compose the placeholder image.
  factory OvalImageTouchWidget.asset(
    /// BuildContext is needed to allow for ModeThemeData to be used for dark/light mode coloring of asset
    BuildContext context, {
    Key key,

    /// Name of the asset image (default/null => AssetImage('images/spinningball200.gif', package: 'theme_package'))
    String asset,

    /// Light/Dark mode colors that will be applied to the 'asset'
    Swatch color,

    /// Time to transition from placeholder image to downloaded image (default: 250ms)
    Duration duration,

    /// Callback on any network errors (should/can return a network error widget)
    LoadingErrorWidgetBuilder error,

    /// Callback for longPress
    GestureLongPressCallback onLongPress,

    /// Callback for tap
    GestureTapCallback onTap,

    /// Size of the container that holds the complete/progress/error image (default: 60x60, cannot be null)
    Size size = const Size(60.0, 60.0),

    /// URL of the target image (needs to return image file {.png, .gif, .jpg,...})
    String url,
  }) {
    assert(context != null);
    final assetImage = (asset == null) ? AssetImages.spinningBall : AssetImage(asset);
    final image =
        Image(image: assetImage, color: (color == null) ? ModeThemeData.productSwatch.color(context) : color.color(context));
    return OvalImageTouchWidget(
      key: key,
      duration: duration = const Duration(milliseconds: 250),
      error: error,
      onLongPress: onLongPress,
      onTap: onTap,
      placeholder: image,
      size: size,
      url: url,
    );
  }

  @override
  _OvalImageTouchWidget createState() => _OvalImageTouchWidget();
}

class _OvalImageTouchWidget extends State<OvalImageTouchWidget> {
  @override
  Widget build(BuildContext context) {
    final placeholderWidget = widget.placeholder ?? ModeThemeData.getCircularProgressIndicator(context);
    final gesture = GestureDetector(
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.url ?? '',
          placeholder: (context, url) => placeholderWidget,
          errorWidget: (context, url, error) {
            return (widget.error != null)
                ? widget.error(context, url, error)
                : Icon(
                    Icons.error,
                    color: ModeThemeData.productSwatch.color(context),
                    size: min(widget.size.height, widget.size.width),
                  );
          },
        ),
      ),
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
    );

    final container = Container(
      child: gesture,
      height: widget.size.height,
      width: widget.size.width,
    );

    return container;
  }
}
