import 'package:jiffy/jiffy.dart';

extension DateTimeExt on DateTime {
  /// Format date with pattern
  String formattedDate({String? pattern}) {
    if (pattern == null) return formatDefault;
    return Jiffy.parse(toString()).format(pattern: pattern);
  }

  /// Format date with default pattern
  /// dd MMMM yyyy hh:mm (01 January 2024 00:00)
  String get formatDefault =>
      Jiffy.parse(toString()).format(pattern: 'dd MMMM yyyy HH:mm');

  /// Format date without time
  /// dd MMMM yyyy (01 January 2024)
  String get formatWithoutTime =>
      Jiffy.parse(toString()).format(pattern: ('dd MMMM yyyy'));

  /// Format date with time only
  /// HH:mm:ss (00:00:00)
  String get formatTime =>
      Jiffy.parse(toString()).format(pattern: ('HH:mm:ss'));

  /// Format date with Weekday Pattern
  /// EEEE (Monday)
  String get toDate => Jiffy.parse(toString()).EEEE;

  /// Format date with relative pattern
  /// 5 hours ago
  String toRelativeTime() {
    final Jiffy dateValue = Jiffy.parseFromDateTime(toLocal());
    final Jiffy now = Jiffy.now();
    if (!dateValue.isBetween(now.subtract(years: 1), now)) {
      return formatWithoutTime;
    }
    return Jiffy.parseFromDateTime(toLocal()).fromNow();
  }
}
