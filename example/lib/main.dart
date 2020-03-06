import 'package:flutter/material.dart';
import 'package:flutter_mode_color/flutter_mode_color.dart';
import 'package:flutter_theme_package/flutter_theme_package.dart';
import 'package:flutter_tracers/trace.dart' as Log;
import 'package:notifier/notifier_provider.dart';

void main() {
  runApp(NotifierProvider(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModeTheme(
      data: (brightness) => (brightness == Brightness.light) ? ModeThemeData.bright() : ModeThemeData.dark(),
      defaultBrightness: Brightness.light,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          home: Exampler(),
          initialRoute: '/',
          routes: {
            Exampler.route: (context) => MyApp(),
          },
          theme: theme,
          title: 'Exampler Demo',
        );
      },
    );
  }
}

class Exampler extends StatefulWidget {
  const Exampler({Key key}) : super(key: key);
  static const route = '/exampler';

  @override
  _Exampler createState() => _Exampler();
}

class _Exampler extends State<Exampler> with WidgetsBindingObserver {
  bool _standardSpinner = true;
  bool _hideSpinner = true;
  String _url = 'http://tineye.com/images/widgets/mona.jpg';

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Log.t('exampler didChangeDependencies');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.t('exampler didChangeAppLifecycleState ${state.toString()}');
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    ModeTheme.of(context).setBrightness(brightness);
    Log.t('exampler didChangePlatformBrightness ${brightness.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    Log.t('exampler build');
    final _scaffold = Scaffold(
      appBar: AppBar(
        title: Text('Title: exampler'),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showHud();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
    final _progressText = HudScaffold.progressText(
      context,
      hide: _hideSpinner,
      indicatorColors: ModeColor(bright: Colors.redAccent, dark: Colors.yellowAccent),
      progressText: 'Standard Spinning for 3 seconds',
      scaffold: _scaffold,
    );
    final _customProgress = HudScaffold(
      hide: _hideSpinner,
      progressIndicator: Images.spinningBall(context),
      scaffold: _scaffold,
    );

    return _standardSpinner ? _progressText : _customProgress;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    Log.t('exampler didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    Log.t('exampler deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    Log.t('exampler dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Scaffold body
  Widget body() {
    final otherUrl = 'https://www.techsupportalert.com/files/images/Newtons-Cradle-Animation-200-150-Opt.gif';
    final url = 'http://tineye.com/images/widgets/mona.jpg';
    Log.t('Line ~143 body()');
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Exampler Template',
              style: Theme.of(context).textTheme.display1,
            ),
            WideAnimatedButton(
                caption: 'Toggle Light/Dark Mode',
                onTap: (a, b) {
                  ModeTheme.of(context).toggleBrightness();
                }),
            WideAnimatedButton(
                caption: _standardSpinner ? 'Switch to Custom' : 'Switch to Standard',
                padding: EdgeInsets.symmetric(horizontal: 46.0),
                onKeyPress: (a, b) {
                  if (a == WideAnimatedButtonPress.down) {
                    setState(() {
                      _standardSpinner = !_standardSpinner;
                    });
                  }
                }),
            Container(
              child: WideAnimatedButton(
                caption: 'Test Taps',
                colors: ModeThemeData.productModeColor,
                onDoubleTap: (action, dateTime) {
                  Log.t('Double Tap ${action.toString()} ${dateTime.toIso8601String()}');
                },
                onKeyPress: (action, dateTime) {
                  Log.t('onKeyPress ${action.toString()} ${dateTime.toIso8601String()}');
                },
                onLongPress: (action, dateTime) {
                  Log.t('Long Press ${action.toString()} ${dateTime.toIso8601String()}');
                },
              ),
              width: double.maxFinite,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaskableFormField(
                controller: _textEditingController,
                focusNode: _focusNode,
                isHideable: true,
                labelText: 'Password:',
                textInputAction: TextInputAction.done,
              ),
            ),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now(), null, Duration(seconds: 10)),
                    textSize: TextSizes.headline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now(), DateTime.now().add(Duration(minutes: 2))),
                    textSize: TextSizes.subtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now(), DateTime.now().subtract(Duration(minutes: 3))),
                    textSize: TextSizes.subtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData.now(),
                    textSize: TextSizes.subtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData.now(),
                    textSize: TextSizes.subtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now().add(Duration(seconds: 10))),
                    textSize: TextSizes.headline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now().subtract(Duration(seconds: 71))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntervalTextWidget(
                    intervalData: IntervalData(DateTime.now()),
                    textStyle: Theme.of(context).textTheme.title.copyWith(color: ModeThemeData.productModeColor.color(context)),
                  ),
                ),
                OvalImageTouchWidget(
                  url: 'intentallyBad_1',
                ),
                OvalImageTouchWidget(
                  error: (context, url, error) => NetworkErrorImage(),
                  url: 'intentallyBad_2',
                ),
                OvalImageTouchWidget(
                  error: (context, url, error) => NetworkErrorImage(
                    code: 404,
                    colors: ModeColor(bright: Colors.greenAccent, dark: Colors.redAccent),
                  ),
                  url: 'intentallyBad3',
                ),
                OvalImageTouchWidget(
                  error: (context, url, error) => NetworkErrorImage(
                    assets: [AssetNames.unknownPerson],
                    colors: ModeColor(bright: Colors.purpleAccent, dark: Colors.greenAccent),
                  ),
                  url: 'intentallyBad_4',
                ),
                OvalImageTouchWidget(
                  error: (context, url, error) => NetworkErrorImage(
                    widgetStack: <Widget>[
                      Images.spinningBall(context, ModeThemeData.primaryModeColor),
                      Center(child: Text('Error')),
                    ],
                  ),
                  url: 'intentallyBad_5',
                ),
                OvalImageTouchWidget(
                  error: (context, url, error) => NetworkErrorImage(
                    widgetStack: <Widget>[
                      Images.spinningBall(context, ModeThemeData.productModeColor),
                      Center(child: Text('works')),
                    ],
                  ),
                  url: url,
                ),
                OvalImageTouchWidget(
                  error: (context, url, error) => NetworkErrorImage(
                    widgetStack: <Widget>[
                      Images.spinningBall(context, ModeThemeData.primaryModeColor),
                      Center(child: Text('works')),
                    ],
                  ),
                  placeholder: ModeThemeData.getCircularProgressIndicator(
                    context,
                    colors: ModeColor(bright: Colors.brown, dark: Colors.greenAccent),
                  ),
                  url: url,
                ),
                OvalImageTouchWidget.asset(
                  context,
                  error: (context, url, error) => NetworkErrorImage(
                    widgetStack: <Widget>[
                      Images.spinningBall(context),
                      Center(child: Text('works')),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _url = (_url == url) ? otherUrl : url;
                    });
                  },
                  url: _url,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHud() {
    setState(() {
      _hideSpinner = false;
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _hideSpinner = true;
        });
      });
    });
  }
}
