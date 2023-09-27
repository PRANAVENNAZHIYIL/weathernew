import 'package:flutter/material.dart';
import 'package:weatherapp_3/view/Screen/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData.dark(useMaterial3: true),
        home: const WeatherApp());
  }
}
