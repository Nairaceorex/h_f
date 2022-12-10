import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Plans').snapshots();
  late Future<Linker> futureLink;
  late Future<bool> futureCheckConnection;
  late Future<bool> futureCheckIsEmu;
  late Future<String?> futureCity;

  Future<String?> getDataOnce_customObjects() async {
    // [START get_data_once_custom_objects]
    final ref = FirebaseFirestore.instance
        .collection("Plans")
        .doc("Healthy")
        .withConverter(
          fromFirestore: City.fromFirestore,
          toFirestore: (City city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    final city = docSnap.data(); // Convert to City object
    return city!.link;
    // [END get_data_once_custom_objects]
  }

  @override
  void initState() {
    super.initState();
    futureLink = getLink('link');
    futureCheckConnection = checkConnection();
    futureCheckIsEmu = checkIsEmu();
    futureCity = getDataOnce_customObjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Linker>(
      future: futureLink,
      builder: (context, snapshotLink) {
        if (!snapshotLink.hasData) {
          /*Future<City?> getDataOnce_customObjects() async {
            // [START get_data_once_custom_objects]
            final ref = FirebaseFirestore.instance
                .collection("Plans")
                .doc("Healthy")
                .withConverter(
                  fromFirestore: City.fromFirestore,
                  toFirestore: (City city, _) => city.toFirestore(),
                );
            final docSnap = await ref.get();
            final city = docSnap.data(); // Convert to City object
            return city;
            // [END get_data_once_custom_objects]
          }

          getDataOnce_customObjects();*/
          return FutureBuilder<String?>(
              future: futureCity,
              builder: (context, snapshotCity) {
                if (snapshotCity.hasData) {
                  return FutureBuilder(
                      future: futureCheckIsEmu,
                      builder: (context, snapshotCheckEmu) {
                        if (!snapshotCheckEmu.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshotCheckEmu.hasData) {
                          if (snapshotCheckEmu.data! ||
                              snapshotCity.data!.isEmpty) {
                            return const UserInformationPage(
                              title: 'This is Emu',
                            );
                          } else if (!snapshotCheckEmu.data! ||
                              snapshotCity.data!.isNotEmpty) {
                            setLink('link', snapshotCity.data!);
                            return WebViewPage(url: snapshotCity.data!);
                          }
                        } else if (snapshotCheckEmu.hasError) {
                          return Text('${snapshotCheckEmu.error}');
                        }
                        return const CircularProgressIndicator();
                      });
                }
                return CircularProgressIndicator();
              });
          /*StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshotData) {
                if (!snapshotData.hasData) {
                  return Text('data');
                } else if (snapshotData.hasError) {
                  return Text('${snapshotData.error}');
                }
                return FutureBuilder(
                    future: futureCheckIsEmu,
                    builder: (context, snapshotCheckEmu) {
                      if (!snapshotCheckEmu.hasData) {
                        return Text('data2');
                      }
                      if (snapshotCheckEmu.hasData) {
                        snapshotData.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          if (snapshotCheckEmu.data! ||
                              data['link'] == '' ||
                              data['link'] == null) {
                            return const UserInformationPage(
                              title: 'This is Emu',
                            );
                          } else if (!snapshotCheckEmu.data! ||
                              data['link'] != '' ||
                              data['link'] != null) {
                            setLink('link', data['link']);
                            return WebViewPage(url: data['link']);
                          }
                        });
                      } else if (snapshotCheckEmu.hasError) {
                        return Text('${snapshotCheckEmu.error}');
                      }
                      return const CircularProgressIndicator();
                    });
                ;
              });
       */
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

        /*
        FutureBuilder(
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
              
        */