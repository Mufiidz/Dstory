import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'context_ext.dart';

extension IntExt on int? {
  String toIdr({bool withSymbol = true}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    );
    return currencyFormatter.format(this ?? 0);
  }

  Color? colorizeAmount(BuildContext context) {
    final int? amount = this;
    if (amount == null || amount == 0) return null;
    if (amount > 0) return context.colorScheme.primary;
    if (amount < 0) return context.colorScheme.error;
    return null;
  }
}
