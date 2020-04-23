import 'package:flutter/material.dart';
import 'package:testing/imstoopid.dart';

class Modeles extends StatefulWidget {
  Modeles({Key key}) : super(key: key);
  @override
  _ModelesState createState() => _ModelesState();
}

class _ModelesState extends State<Modeles> {
  var nom = [
    "Plum Pudding",
    "Normal",
    "Orbitales",
  ];
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text("Choix modèles"),
      ),
      body: Container(
          child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return SuperBouton(title: nom[index], id: index);
        },
      )),
    ));
  }
}

class SuperBouton extends StatelessWidget {
  final String title;
  final int id;
  SuperBouton({Key key, this.title, this.id}) : super(key: key);

  void changePage(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GrosModeles(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160,
        child: RaisedButton(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          color: Colors.pink,
          onPressed: () => changePage(context, this.id),
        ));
  }
}
