// ignore: unused_import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class UnderlineInputField extends StatelessWidget {
  final String hint;
  final int? max;
  final int? maxChar;
  final Widget? end;
  final bool expand;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  const UnderlineInputField(
      {Key? key,
      required this.hint,
      this.controller,
      this.validator,
      this.max,
      this.maxChar,
      this.end,
      this.expand = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        validator: validator,
        controller: controller,
        maxLines: max,
        maxLength: maxChar,
        expands: expand,
        decoration: InputDecoration(
            helperText: Locales.string(context, hint),
            hintText: Locales.string(context, hint),
            suffixIcon: end),
      ),
    );
  }
}
