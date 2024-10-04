import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DropdownWidget<T> extends FormBuilderDropdown<T> {
  final String id;
  final List<T> list;
  final InputDecoration? decor;
  final String? hint;
  final String? label;
  final String? prefix;
  final String? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? radius;
  final List<FormFieldValidator<T>>? validators;
  DropdownWidget(this.id, this.list,
      {super.key,
      this.decor,
      this.hint,
      this.label,
      this.radius,
      this.prefix,
      this.suffix,
      this.prefixIcon,
      this.suffixIcon,
      super.initialValue,
      super.onChanged,
      this.validators})
      : super(
            name: id,
            items: list
                .map((T e) =>
                    DropdownMenuItem<T>(value: e, child: Text(e.toString())))
                .toList(),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
            decoration: decor?.copyWith(
                  labelText: label,
                  hintText: hint,
                  prefixText: prefix,
                  suffixText: suffix,
                  prefixIcon: Icon(prefixIcon),
                  suffixIcon: Icon(suffixIcon),
                ) ??
                InputDecoration(
                  labelText: label,
                  hintText: hint,
                  prefixText: prefix,
                  suffixText: suffix,
                  prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                  suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
            validator: FormBuilderValidators.compose<T>(
                validators ?? <FormFieldValidator<T>>[]));
}
