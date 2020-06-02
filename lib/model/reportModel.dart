import 'package:firebase_database/firebase_database.dart';

class reportModel {
  String name;
  String timestamp;
  String phone;
  String note;
  String address;
  String typeprocess;
  bool statusProcess;

  dynamic images = new List<String>();

  reportModel(this.name,this.timestamp,this.phone,this.note,this.address,this.typeprocess,this.statusProcess, this.images);

  reportModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        timestamp= snapshot.value["timestamp"],
        phone= snapshot.value["phone"],
        note= snapshot.value["note"],
        address= snapshot.value["address"],
        typeprocess= snapshot.value["typeprocess"],
        statusProcess= snapshot.value["statusProcess"],
        images = snapshot.value["images"];


  toJson() {
    return {
      "name": name,
      "timestamp": timestamp,
      "phone": phone,
      "note": note,
      "address": address,
      "typeprocess": typeprocess,
      "statusProcess": statusProcess,
      "images": images,
    };
  }
}