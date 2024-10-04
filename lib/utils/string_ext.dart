import 'package:easy_localization/easy_localization.dart';

extension StringExt on String? {
  int get toInt => int.tryParse(this ?? '') ?? 0;
  String get clearId => (this ?? '').replaceAll('-', '').substring(0, 10);
  String countryCodeToEmoji() {
    String? countryCode = this;
    if (countryCode == null) return '';
    if (countryCode == 'en') {
      countryCode = 'US';
    }
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter =
        countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter =
        countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  String get localized => (this ?? '').tr();
  String get countryName =>
      switch (this) { 'en' => 'English', 'id' => 'Indonesia', _ => '-' };
  String get cleanedText =>
      (this ?? '').trim().replaceAll(RegExp(r'\s+\b|\b\s'), ' ');
}
