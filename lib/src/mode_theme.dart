/// A ModeTheme widget that wraps the MaterialApp widget and allows for on-the-fly changing of light/dark modes,
/// as well as preserves light/dark mode state across app launches (using SharedPreferences with key 'isDarkMode').
/// Brightness can be see with:
///    ModeTheme.of(BuildContext).setBrightness(Brightness)
///    ModeTheme.of(BuildContext).toggleBrightness()
///
/// This widget must wrap MaterialApp like:
/// class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
///    return ModeTheme(
//      data: (brightness) => (brightness == Brightness.light) ? ModeThemeData.bright() : ModeThemeData.dark(),
//      defaultBrightness: Brightness.light,
//      themedWidgetBuilder: (context, theme) {
//        return MaterialApp(
//          home: Zerky(),
//          initialRoute: '/',
//          routes: {
//            Zerky.route: (context) => MyApp(),
//          },
//          theme: theme,
//          title: 'Zerky Demo',
//        );
//      },
//    );
//  }
//}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ModeWidgetBuilder = Widget Function(BuildContext context, ThemeData data);

typedef ModeThemeDataWithBrightnessBuilder = ThemeData Function(Brightness brightness);

class ModeTheme extends StatefulWidget {
  const ModeTheme({Key key, this.data, this.themedWidgetBuilder, this.defaultBrightness}) : super(key: key);

  final ModeWidgetBuilder themedWidgetBuilder;
  final ModeThemeDataWithBrightnessBuilder data;
  final Brightness defaultBrightness;

  @override
  ModeThemeState createState() => ModeThemeState();

  static ModeThemeState of(BuildContext context) {
    return context.findAncestorStateOfType();
  }
}

class ModeThemeState extends State<ModeTheme> {
  ThemeData _data;

  Brightness _brightness;

  static const String _modeSharedPreferenceKey = 'com.Avoid.Collision.Name.isDarkMode';

  ThemeData get data => _data;

  Brightness get brightness => _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.defaultBrightness;
    _data = widget.data(_brightness);

    loadBrightness().then((bool dark) {
      _brightness = dark ? Brightness.dark : Brightness.light;
      _data = widget.data(_brightness);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data = widget.data(_brightness);
  }

  @override
  void didUpdateWidget(ModeTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.data(_brightness);
  }

  Future<void> setBrightness(Brightness brightness) async {
    setState(() {
      _data = widget.data(brightness);
      _brightness = brightness;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_modeSharedPreferenceKey, brightness == Brightness.dark ? true : false);
  }

  Future<void> toggleBrightness() async {
    if (_brightness == Brightness.dark)
      await setBrightness(Brightness.light);
    else
      await setBrightness(Brightness.dark);
  }

  void setThemeData(ThemeData data) {
    setState(() {
      _data = data;
    });
  }

  Future<bool> loadBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_modeSharedPreferenceKey) ?? widget.defaultBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _data);
  }
}
