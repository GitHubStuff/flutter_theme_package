import 'package:flutter/material.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';

class AssetNames {
  static String get networkError => 'images/networkerror256.png';
  static String get person => 'images/person600.png';
  static String get spinningBall => 'images/spinningball200.gif';
  static String get unknownPerson => 'images/unknownPerson200.png';
}

class AssetImages {
  static AssetImage get networkError => AssetImage(AssetNames.networkError, package: 'flutter_theme_package');
  static AssetImage get person => AssetImage(AssetNames.person, package: 'flutter_theme_package');
  static AssetImage get spinningBall => AssetImage(AssetNames.spinningBall, package: 'flutter_theme_package');
  static AssetImage get unknownPerson => AssetImage(AssetNames.unknownPerson, package: 'flutter_theme_package');
}

class Images {
  static Image _make(BuildContext context, AssetImage image, Swatch colors) {
    final color = (colors != null) ? colors.color(context) : ModeThemeData.productSwatch.color(context);
    return Image(image: image, color: color);
  }

  static Image networkError(BuildContext context, [Swatch colors]) => _make(context, AssetImages.networkError, colors);
  static Image person(BuildContext context, [Swatch colors]) => _make(context, AssetImages.person, colors);
  static Image spinningBall(BuildContext context, [Swatch colors]) => _make(context, AssetImages.spinningBall, colors);
  static Image unknownPerson(BuildContext context, [Swatch colors]) => _make(context, AssetImages.unknownPerson, colors);
}
