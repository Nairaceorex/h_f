import 'package:cloud_firestore/cloud_firestore.dart';

class Linker {
  final String link;

  const Linker({required this.link});
}

class City {
  final String? link;

  City({
    this.link,
  });

  factory City.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return City(
      link: data?['link'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (link != null) "link": link,
    };
  }
}
