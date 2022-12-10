import 'package:flutter/material.dart';
import 'package:h_f/domain/firebase_config.dart';
import 'package:h_f/domain/services/checker.dart';
import 'package:h_f/screens/error_page.dart';
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
  late Future<bool> futureCheckConnection;
  late Future<bool> futureCheckIsEmu;

  @override
  void initState() {
    super.initState();
    futureLink = getLink('link');
    futureCheckConnection = checkConnection();
    futureCheckIsEmu = checkIsEmu();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Linker>(
      future: futureLink,
      builder: (context, snapshotLink) {
        if (!snapshotLink.hasData) {
          return FutureBuilder(
              future: futureCheckIsEmu,
              builder: (context, snapshotCheckEmu) {
                if (!snapshotCheckEmu.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshotCheckEmu.hasData) {
                  if (snapshotCheckEmu.data!) {
                    return const UserInformationPage(
                      title: 'This is Emu',
                    );
                  } else if (!snapshotCheckEmu.data!) {
                    return const UserInformationPage(
                        title: 'This is Real Device!');
                  }
                } else if (snapshotCheckEmu.hasError) {
                  return Text('${snapshotCheckEmu.error}');
                }
                return const CircularProgressIndicator();
              });
        } else if (snapshotLink.hasData) {
          return FutureBuilder(
            future: Future.wait([checkConnection(), checkIsEmu()]),
            builder: (context, AsyncSnapshot<List<bool>> snapshotCheck) {
              if (!snapshotCheck.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshotCheck.hasData) {
                if (!snapshotCheck.data![0]) {
                  return const ErrorPage();
                } else if (snapshotCheck.data![0]) {
                  return WebViewPage(url: snapshotLink.data!.link);
                }

                /*if (snapshotLink.data!.link.isEmpty) {
                  return UserInformationPage();
                }*/
              } else if (snapshotCheck.hasError) {
                return Text('${snapshotCheck.error}');
              }
              /*if (!snapshot1.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot1.hasData) {
            return Text('data');
          }
          if (!snapshot1.data![0]) {
            return const ErrorPage();
          } else if (snapshot1.data![1]
              // || snapshot.data![0].link.isEmpty
              ) {
            return const UserInformationPage();
          } /*else if (snapshot.hasData) {
            return WebViewPage(url: snapshot.data![0].link);
          }*/
          else if (snapshot1.hasError) {
            return Text('${snapshot1.error}');
          }*/
              return const CircularProgressIndicator();
            },
          );
        } else if (snapshotLink.hasError) {
          return Text('${snapshotLink.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
/*
FutureBuilder<Linker>(
              future: futureLink,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const UserInformationPage();
                } else if (snapshot.hasData) {
                  if (!snapshot1.data![0]) {
                    return const ErrorPage();
                  } else if (snapshot1.data![0]) {
                    return WebViewPage(url: snapshot.data!.link);
                  }
                }
                return const CircularProgressIndicator();
              });
        */