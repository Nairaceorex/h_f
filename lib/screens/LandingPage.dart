import 'package:flutter/material.dart';
import 'package:h_f/domain/FirebaseConfig.dart';
import 'package:h_f/screens/UserInformation.dart';
import 'package:h_f/screens/WebViewPage.dart';
import 'package:h_f/services/classes.dart';

//Переключает окна в зависимости от статуса
class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<Linker> futureLink;
  @override
  void initState() {
    super.initState();
    futureLink = getLink('link');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Linker>(
        future: futureLink,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return UserInformation();
          } else if (snapshot.hasData) {
            print(snapshot.data!.link);
            return WebViewPage(snapshot.data!.link, 'title');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
