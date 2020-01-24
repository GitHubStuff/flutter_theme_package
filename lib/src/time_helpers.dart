import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Typedef of function that takes a negative duration and formats it, this allows for
/// standard interval updates with a custom approach to negative durations
typedef String NegativeIntervalFormatter(Duration duration);

/// Defines the data in creating interval data for creation of the stream and what the stream returns
abstract class IntervalInformation {
  DateTime startTime;
  DateTime endTime;
  Duration duration;
}

/// Class based on IntervalInformation.
class IntervalData with IntervalInformation {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  IntervalData(this.startTime, [this.endTime, this.duration]) : assert(startTime != null);
  factory IntervalData.now() => IntervalData(DateTime.now());
}

/// Collection of static methods and instances classes for creating streams for updating time
///
class DateTimeIntervals {
  /// Gets the duration between the starting and ending times, if end time is NOT provided uses current time
  static Duration getDuration({
    @required DateTime starting,
    DateTime ending,
  }) {
    assert(starting != null);
    return (ending ?? DateTime.now()).toUtc().difference(starting.toUtc());
  }

  /// Creates the days, hours, minutes, and optional seconds of a Duration in the form:
  /// 'ddd hh:mm:ss', 'ddd hh:mm', 'hh:mm:ss', 'hh:mm'
  /// Inclusion of days and seconds is controlled by parameters.
  static String getAbsoluteDurationText(
    Duration duration, {
    bool includeSeconds = false,
    bool showDays = false,
  }) {
    String result = '';
    final days = duration.inDays.abs();
    if (days > 0 || (showDays ?? false)) result = NumberFormat('000').format(duration.inDays.abs()) + ' ';
    final hours = duration.inHours.abs() - (24 * days);
    final minutes = duration.inMinutes.abs() - (days * 1440 + hours * 60);
    final seconds = duration.inSeconds.abs() - (days * 86400 + hours * 3600 + minutes * 60);
    result += NumberFormat('00').format(hours) + ':' + NumberFormat('00').format(minutes);
    if (includeSeconds ?? false) result += ':' + NumberFormat('00').format(seconds);
    return result;
  }

  /// Removes a leading '-' sign on zero time TODO: find Regex that will do this
  static String _fixMinusZero(String string) {
    return (string == '-000 00:00:00' || string == '-00:00:00') ? string.substring(1) : string;
  }

  /// Creates a string that shows the days, hours, minutes, optional seconds of a duration.
  /// NOTE: 'String NegativeIntervalFormatter(Duration duration)' can be supplied to provide
  /// an override on how negative durations are displayed (default is to put a '-' in front of the string)
  static String getDurationText(
    Duration duration, {
    bool includeSeconds = true,
    NegativeIntervalFormatter negativeInterval,
  }) {
    assert(duration != null);
    if (duration.isNegative) {
      final answer = (negativeInterval != null)
          ? negativeInterval(duration)
          : _fixMinusZero('-' + getAbsoluteDurationText(duration, includeSeconds: includeSeconds));
      return answer;
    }
    return getAbsoluteDurationText(duration, includeSeconds: includeSeconds);
  }

  /// Creates a string that shows days, hours, minutes, optional seconds between two times.
  /// How negative intervals can be displayed can be provided (default puts a '-' in front of the text)
  static String getIntervalText({
    @required DateTime starting,
    DateTime ending,
    bool includeSeconds = false,
    NegativeIntervalFormatter negativeInterval,
  }) {
    final duration = getDuration(starting: starting, ending: ending);
    return getDurationText(duration, includeSeconds: includeSeconds, negativeInterval: negativeInterval);
  }

  /// Helper to convert string to date or null if not parse-able
  static DateTime parse(String dateTime) {
    try {
      DateTime result = DateTime.parse(dateTime);
      return result;
    } catch (error) {
      return null;
    }
  }

  /// Helper to create a reader friendly date/time (default format is 'E MMM dd, yyyy h:mm:ss a')
  /// If not date is supplied the current date/time is used
  /// NOTE: As times should be managed to UTC this also handles conversion to local time
  static String prettyTime(
    DateTime dateTime, {
    String fmt = 'E MMM dd, yyyy h:mm:ss a',
  }) {
    assert(fmt != null);
    final useDate = dateTime?.toLocal() ?? DateTime.now().toLocal();
    return DateFormat(fmt).format(useDate);
  }

  /// For updating times a stream is used to regularly update time
  /// The starting time cannot be null, and if the ending time is then the current time is used
  /// (note: if ending time is NOT null the stream will complete after one cycle because the interval
  /// will never change).
  /// The refresh rate must be a non-null, positive interval
  Stream<IntervalInformation> stream({
    @required DateTime startingTime,
    DateTime endingTime,
    Duration interval = const Duration(milliseconds: 250),
  }) async* {
    assert(startingTime != null);
    assert(interval != null && !interval.isNegative);
    do {
      final endTime = endingTime ?? DateTime.now();
      final duration = getDuration(starting: startingTime, ending: endTime);
      final result = IntervalData(startingTime, endTime, duration);
      yield result;
      await Future.delayed(interval);

      /// If there is a supplied endTime then the interval will never change, so after the one(1) stream yield
      /// it will fall-through and stop updating (should spare system resources {or I'm being too anal})
    } while (endingTime == null);
  }
}

/// ----------------------------------------------------------------------------------------------
///
