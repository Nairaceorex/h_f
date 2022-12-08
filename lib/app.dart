import 'package:flutter/material.dart';
import 'package:h_f/screens/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: const Color.fromRGBO(118, 227, 0, 1))),
      home: const HomePage(),
    );
  }
}
