import 'package:flutter/material.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';

class GrosModeles extends StatelessWidget {
  final int id;
  GrosModeles({Key key, this.id}) : super(key: key);
  var nom = [
    "Plum Pudding",
    "Modèle de Rutherford (Magnésium)",
    "Orbitales (Krypton, 1s2 2s2 2p6 3s2 3p6 3d10 4s2 4p6)",
  ];
  var nomModele = [
    "assets/modele1.obj",
    "assets/modele2.obj",
    "assets/modele3.obj",
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
          path: this.nomModele[id],
          asset: true,
        ),
      ),
    ));
  }
}
