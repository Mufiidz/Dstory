import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../utils/export_utils.dart';

class LocaleButton extends StatelessWidget {
  const LocaleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onCLickLocale(context),
        icon: Text(
          context.locale.toString().countryCodeToEmoji(),
          style: const TextStyle(fontSize: 24),
        ));
  }

  void _onCLickLocale(BuildContext context) async {
    final Locale currentLocale = context.locale;
    const Locale localeId = Locale('id');
    Locale newLocale = localeId;

    if (currentLocale == localeId) {
      newLocale = const Locale('en');
    }
    await context.setLocale(newLocale);
    await Jiffy.setLocale(newLocale.toString());
  }
}
