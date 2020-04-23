import 'package:flutter/material.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';

class GrosModeles extends StatelessWidget {
  final int id;
  GrosModeles({Key key, this.id}) : super(key: key);
  var nom = [
    "Plum Pudding",
    "Magnésium",
    "Orbitales",
  ];
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text(this.nom[id]),
      ),
      body: new Center(
        child: new Object3D(
          size: const Size(400.0, 400.0),
          path: "assets/modele1.obj",
          asset: true,
        ),
      ),
    ));
  }
}
