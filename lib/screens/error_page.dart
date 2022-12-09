import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Text(
          'Для работы приложения необходим доступ к сети',
          style: TextStyle(color: Colors.yellowAccent),
        ),
      ),
    );
  }
}
