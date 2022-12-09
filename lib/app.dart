import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:h_f/screens/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
