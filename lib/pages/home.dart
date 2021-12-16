// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home/navigation_drawer_widget.dart';
import 'cards/lesson_card.dart';

import 'constants.dart' as AppColors;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.MAIN_COLOR,
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          foregroundColor: AppColors.ELEMENTS_COLOR,
          titleTextStyle: const TextStyle(
            color: AppColors.ELEMENTS_COLOR,
            fontSize: 18,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: AppColors.MAIN_COLOR,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: AppColors.MAIN_COLOR,
          title: const Text(
            "SDU Academy",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: const [
              LessonCard(
                  header: 'Mobile Programming',
                  description: 'Learn Mobile Programming',
                  title: 'Mobile Programming'),
              LessonCard(
                  header: 'Calculus',
                  description: 'Learn calculus',
                  title: 'Calculus'),
              LessonCard(
                  header: 'Physics',
                  description: 'Learn physics',
                  title: 'Physics'),
              LessonCard(
                  header: 'Astronomy',
                  description: 'Learn astronomy',
                  title: 'Astronomy'),
              LessonCard(
                  header: 'Programming',
                  description: 'Learn programming',
                  title: 'Programming'),
              LessonCard(
                  header: 'Geology',
                  description: 'Learn geology',
                  title: 'Geology'),
            ],
          ),
        ),
      ),
    );
  }
}
