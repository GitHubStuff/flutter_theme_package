import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';

/// Provides an elegantly composed widget to display network error information/icon(s)
///
/// NOTES:
///   1) if 'code' is not null, the value will be displayed inside a mode-color animated gif
///   2) if 'code' is not null, it will ignore any 'assets' or 'widgetStack'
///   3) if 'widgetStack' is not null, then 'assets' and 'color' must be null
///   4) if 'widgetStack' doesn't not have any mode-ready coloring applied
///   5) if 'widgetStack' is not null, it must have at least one widget
///   6) if 'assets' is not null, then 'widgetStack' must be null, and 'assets' must have at least one asset name
///   7) if 'assets' is not null, the colors of all assets are set to 'colors' or to ModeThemeData.productSwatch if 'colors' is null
///
class NetworkErrorImage extends StatefulWidget {
  /// List of image assets that are stacked and displayed (if set 'widgetStack' must be null)
  ///   NOTE: Light/Dark mode colors can be supplied or defaulted to insure it is mode-ready
  final List<String> assets;

  /// Best used for HTTP code reporting, if not null it will override the use of 'assets' and 'widgetState'
  final int code;

  /// ModeTheme.productSwatch is used for 'assets' color, and 'code' display, unless overridden here
  final Swatch colors;

  /// Widgets that will be stacked to create a composite widget. If used 'assets', and 'colors' must be null
  /// and each widget supplies its color.
  final List<Widget> widgetStack;

  NetworkErrorImage({Key key, this.assets, this.code, this.colors, this.widgetStack}) : super(key: key);

  @override
  _NetworkErrorImage createState() => _NetworkErrorImage();
}

class _NetworkErrorImage extends State<NetworkErrorImage> {
  Color _color;
  @override
  Widget build(BuildContext context) {
    // Get the single color for light or dark mode
    _color = (widget.colors ?? ModeThemeData.productSwatch).color(context);
    // Handles the case where there are no assets or widgets or where code is used
    if ((widget.assets == null && widget.widgetStack == null) || widget.code != null) {
      final spinner = Images.spinningBall(context, widget.colors);
      final network = (widget.code == null)
          ? Images.networkError(context, widget.colors)
          : Center(
              child: AutoSizeText(
                '${widget.code}',
                maxLines: 1,
                style: Theme.of(context).textTheme.caption,
              ),
            );
      return Stack(
        children: <Widget>[
          spinner,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: network,
          )
        ],
      );
    }
    // Handle the case where there is a stack of widgets, with checks to make sure other params aren't incorrectly set
    if (widget.widgetStack != null) {
      assert(widget.assets == null);
      assert(widget.colors == null);
      assert(widget.widgetStack.length > 0);
      return Stack(children: widget.widgetStack);
    }

    // Final case, where assets a supplied, create a stack of images with correct color supplied for dark/light modes.
    assert(widget.assets.length > 0);
    List<Image> images = List();
    for (String asset in widget.assets) {
      images.add(Image(image: AssetImage(asset) ?? AssetImage(asset, package: 'flutter_theme_package'), color: _color));
    }
    return Stack(children: images);
  }
}
