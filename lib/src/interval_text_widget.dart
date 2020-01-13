import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'mode_theme_data.dart';
import 'time_helpers.dart';

/// Creates a Text widget with the interval between to Date/Times, and an do updates via a stream for continuously updating
/// changes between a start time and current time.
/// Note: If an end-time is specified it displays a non-updated interval {makes sense}
class IntervalTextWidget extends StatefulWidget {
  final IntervalData intervalData;
  final NegativeIntervalFormatter negativeIntervalFormatter;
  final bool showSeconds;
  final TextSizes textSize;
  final TextStyle textStyle;

  IntervalTextWidget({
    Key key,

    /// Cannot be null, and intervalData.startTime cannot be null
    /// if intervalData.endTime is null it uses the current date/time
    /// if intervalData.duration is null it will default to 250ms
    @required this.intervalData,

    /// If not null this function will create a custom string for negative intervals
    this.negativeIntervalFormatter,
    this.showSeconds = true,

    /// if not null it will adjust the font size of the text widget, if not null then 'textStyle' must be null
    this.textSize,

    /// if not null it will style the text widget, if not null then 'textSize' must be null
    this.textStyle,
  })  : assert(intervalData != null && intervalData.startTime != null),
        assert((textStyle == null && textSize == null) ||
            (textStyle != null && textSize == null) ||
            (textStyle == null && textSize != null)),
        super(key: key);

  @override
  _IntervalTextWidget createState() => _IntervalTextWidget();
}

class _IntervalTextWidget extends State<IntervalTextWidget> {
  Stream<IntervalInformation> _stream;

  @override
  initState() {
    super.initState();

    /// Create stream and insure it will have at least a 250ms refresh rate.
    /// Note: If endTime is not null the stream will only publish the interval once.
    _stream = DateTimeIntervals().stream(
      startingTime: widget.intervalData.startTime,
      endingTime: widget.intervalData.endTime,
      interval: widget.intervalData.duration ?? Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IntervalInformation>(
      builder: (context, snapshot) {
        TextStyle style;
        if (widget.textSize != null || widget.textStyle != null) {
          style = widget.textStyle ?? Theme.of(context).textTheme.caption.copyWith(fontSize: getTextSizes(widget.textSize));
        }
        if (!snapshot.hasData)
          return AutoSizeText(
            widget.showSeconds ? '--:--:--' : '--:--',
            style: style,
          );
        final string = DateTimeIntervals.getDurationText(
          snapshot.data.duration,
          includeSeconds: widget.showSeconds,
          negativeInterval: widget.negativeIntervalFormatter,
        );
        return AutoSizeText(
          string,
          style: style,
        );
      },
      stream: _stream,
    );
  }
}
