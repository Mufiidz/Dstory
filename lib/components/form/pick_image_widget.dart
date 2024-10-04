import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../utils/export_utils.dart';

typedef OnClick = void Function(FormFieldState<String> field);

class PickImageWidget extends StatelessWidget {
  final String keyName;
  final OnClick pickImage;
  final String? image;

  const PickImageWidget(this.keyName,
      {required this.pickImage, super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: keyName,
      initialValue: image,
      validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
        FormBuilderValidators.required(),
      ]),
      builder: (FormFieldState<String> field) => InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          errorText: field.errorText,
        ),
        child: Builder(
          builder: (BuildContext context) {
            final String? image = this.image;
            if (image == null || image.isEmpty) {
              return InkWell(
                onTap: () => pickImage(field),
                child: Container(
                  width: context.mediaSize.width,
                  height: context.mediaSize.height * 0.3,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
              );
            }
            return InkWell(
              onTap: () => pickImage(field),
              child: Image.file(
                File(image),
                height: context.mediaSize.height * 0.3,
              ),
            );
          },
        ),
      ),
    );
  }
}
