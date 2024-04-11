import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/screens/home/intro_screen.dart';
import 'package:weatherapp/screens/provider/weatherProvidr/weatherProvidr.dart';

import 'core/constants.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => WeatherProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const CupertinoScrollBehavior(),
        theme: ThemeData(
          scaffoldBackgroundColor: kscaffoldBackgroundColor,
          colorScheme: const ColorScheme.dark(),
          appBarTheme: const AppBarTheme(
            backgroundColor: kscaffoldBackgroundColor,
            elevation: 0,
          ),
        ),
        home: const IntroScreen(),
      ),
    );
  }
}
