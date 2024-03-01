import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Trash extends StatelessWidget {
  const Trash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("Trash"),
      ),
    );
  }
}
