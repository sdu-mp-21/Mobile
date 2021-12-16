// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:project/pages/cards/JsonPage.dart';
import '../constants.dart' as AppColors;

class LessonPage extends StatelessWidget {
  final String title;

  const LessonPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.MAIN_COLOR,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.ELEMENTS_COLOR),
        ),
      ),
      body: JsonPage(title),
    );
  }
}
