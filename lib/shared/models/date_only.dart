import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// A class to represent a Date without time information.
/// Mimics the behavior of the DateOnly class in TypeScript.
class DateOnly extends Equatable implements Comparable<DateOnly> {
  final DateTime _dateTime;

  // Internal constructor
  DateOnly._(this._dateTime);

  /// Creates a DateOnly from a DateTime, stripping time info.
  factory DateOnly.fromDateTime(DateTime dt) {
    return DateOnly._(DateTime(dt.year, dt.month, dt.day));
  }

  /// Creates a DateOnly for the current day.
  factory DateOnly.today() {
    final now = DateTime.now();
    return DateOnly._(DateTime(now.year, now.month, now.day));
  }

  /// Parses a string (e.g., "YYYY-MM-DD") into a DateOnly object.
  factory DateOnly.fromString(String dateString) {
    try {
      final parsedDate = DateTime.parse(dateString);
      return DateOnly._(
          DateTime(parsedDate.year, parsedDate.month, parsedDate.day));
    } catch (e) {
      // Handle potential formatting errors
      throw FormatException("Invalid DateOnly string format: $dateString");
    }
  }

  DateTime get dateTime => _dateTime;
  int get year => _dateTime.year;
  int get month => _dateTime.month;
  int get day => _dateTime.day;

  /// Returns the date formatted as "YYYY-MM-DD".
  @override
  String toString() {
    return DateFormat('yyyy-MM-dd').format(_dateTime);
  }

  @override
  int compareTo(DateOnly other) {
    return _dateTime.compareTo(other._dateTime);
  }

  @override
  List<Object?> get props => [_dateTime.toIso8601String()];
}