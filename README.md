# theme_package

Collection of widgets and classed used by [Silversphere](https://www.silversphere.com) mobile
applications

## Overview:

[HudScaffold](https://github.com/SilversphereInc/theme_package/blob/master/lib/src/hud_scaffold.dart)
- A widget that overlays the screen and display a spinner and message (eg: 'Logging in')

[IntervalTextWidget](https://github.com/GitHubStuff/flutter_theme_package/blob/master/lib/src/interval_text_widget.dart)
- Creates a Text widget that displays an updating interval (days, hours, minutes, optional seconds) between
  a start time and the current time. (A fixed end-time can be supplied for non-changing interval)
  Seconds can be excluded/included and the style of negative intervals can be modified using a callback.
  (The default is to put '-' in from of the interval string)
  NOTE: Uses a stream provided by [DateTimeIntervals](https://github.com/GitHubStuff/theme_package/blob/develop/lib/src/time_helpers.dart)

[MaskableFormField](https://github.com/SilversphereInc/theme_package/blob/develop/lib/src/maskable_form_field.dart)
- Widget for maskable entry (eg password fields) that has a toggle to show/hide the input,
  and is responsive to dark/light mode changes
  
[ModeTheme](https://github.com/SilversphereInc/theme_package/blob/master/lib/src/mode_theme.dart) 
- Class that wraps the MaterialApp widget and allows for quick setting of light/dark display modes

[ModeThemeData](https://github.com/SilversphereInc/theme_package/blob/master/lib/src/mode_theme_data.dart)
- Contains color pairs for light and dark mode colors for optimal theme design but creating
  custom schemes for [Silversphere](https://www.silversphere.com) mobile applications.
  **NOTE:** Includes class 'Swatch' for creating colors pairs for light dark modes.

[NetworkApis](https://github.com/GitHubStuff/theme_package/blob/develop/lib/src/network_apis.dart)
- Class/Collection to wrap apis in custom helper class with responses that report HTTP status clearly
  and negates much of there error checking work done further up the call chain.

[NetworkErrorImage](https://github.com/GitHubStuff/theme_package/blob/develop/lib/src/network_error_image.dart)
- Widget that display an image when an network error has occurred. The image is good for Alert Dialogs, or
  on forms/screens to provide an informative feedback. Animations and text can be inter-mixed.

[OvalImageTouchWidget](https://github.com/GitHubStuff/theme_package/blob/develop/lib/src/oval_image_touch_widget.dart)
- Widgets that in the background will fetch an image url (target must be valid image file {.gif, .jpg, .pdf...})
  The image is transformed into an oval and can be made to respond to taps and long presses via callbacks.
  Also on network errors a custom image can be set as part of error handling.

[TimeHelpers](https://github.com/GitHubStuff/theme_package/blob/develop/lib/src/time_helpers.dart)
- A collection of abstracts, methods, typedefs, and stream builders that help date/time tasks and part of
  display for updating time intervals

[WideAnimatedButton](https://github.com/GitHubStuff/flutter_theme_package/blob/master/lib/src/wide_animated_button.dart)
- Successor to WideButtonWidget, displays a button with subtle tap animation, and optional clock sound.
  Callbacks for KeyPress, DoubleTap, Tap, and LongPress
