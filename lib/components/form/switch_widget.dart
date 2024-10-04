import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SwitchWidget extends StatefulWidget {
  final String id;
  final bool? initialValue;
  final void Function(bool)? onChanged;
  const SwitchWidget(this.id, {super.key, this.initialValue, this.onChanged});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool value = false;
  @override
  void initState() {
    value = widget.initialValue ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: widget.id,
      initialValue: value,
      builder: (FormFieldState<bool> field) {
        return Switch.adaptive(
            value: value,
            onChanged: (bool newValue) {
              setState(() => value = newValue);
              field.didChange(newValue);
              widget.onChanged?.call(newValue);
            });
      },
    );
  }
}
