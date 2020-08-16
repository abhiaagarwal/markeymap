import 'package:markeymap/data/api.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:markeymap/models/action.dart';
import 'package:markeymap/models/county.dart';
import 'package:markeymap/models/town.dart';

class FirebaseApi extends Api {
  FirebaseApi({FirebaseFirestore firestore})
      : store = firestore ?? FirebaseFirestore.instance;
      
  final FirebaseFirestore store;

  @override
  Future<List<EdAction>> getActions(County county, Town town) async =>
      (await store
              .collection(county.name.toLowerCase())
              .doc(town.name.toLowerCase())
              .collection('actions')
              .get())
          .docs
          .map<EdAction>((QueryDocumentSnapshot snapshot) =>
              EdAction.fromMap(snapshot.data()))
          .toList();
  @override
  List<County> getCounties() => County.values;

  @override
  Future<List<Town>> getTowns(County county) async =>
      (await store.collection(county.name.toLowerCase()).get())
          .docs
          .map<Town>(
              (QueryDocumentSnapshot snapshot) => Town.fromMap(snapshot.data()))
          .toList();
}
