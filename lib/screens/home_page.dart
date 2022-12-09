import 'package:flutter/material.dart';
import 'package:h_f/domain/firebase_config.dart';
import 'package:h_f/domain/services/check_device.dart';
import 'package:h_f/screens/user_information_page.dart';
import 'package:h_f/screens/web_view_page.dart';
import 'package:h_f/domain/services/classes.dart';

//Переключает окна в зависимости от статуса
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Linker> futureLink;
  @override
  void initState() {
    super.initState();
    futureLink = getLink('link');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Linker>(
      future: futureLink,
      builder: (context, snapshot) {
        /* if (checkIsEmu() || snapshot.data!.link.isEmpty) {
          return const UserInformationPage();
        } else*/
        if (!snapshot.hasData) {
          return const UserInformationPage();
        } else if (snapshot.hasData) {
          return WebViewPage(url: snapshot.data!.link, title: 'title');
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
