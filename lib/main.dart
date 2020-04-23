import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testing/imdumb.dart';
import 'package:extended_math/extended_math.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:testing/imfat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  final reactifs = TextEditingController();
  final produits = TextEditingController();

  String solution_finale = "Solution:";

  @override
  void dispose() {
    reactifs.dispose();
    produits.dispose();
    super.dispose();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void solution() async {
    List diffReactifs = new List();
    List diffProduits = new List();

    var textReactifs = reactifs.text;
    var textProduits = produits.text;

    //split text dans les cases
    diffReactifs = textReactifs.split('+');
    diffProduits = textProduits.split('+');

    var atomesReactifsTotal =
        new List.generate(diffReactifs.length, (_) => new List());
    var nbReactifsTotal =
        new List.generate(diffReactifs.length, (_) => new List<int>());

    var atomesProduitsTotal =
        new List.generate(diffProduits.length, (_) => new List());
    var nbProduitsTotal =
        new List.generate(diffProduits.length, (_) => new List<int>());

    //vefif pour texte vide et caractères autres
    RegExp exp = new RegExp(r"[^A-Za-z0-9\+]");
    bool isLegit = !exp.hasMatch(textReactifs);
    bool isLegit2 = !exp.hasMatch(textProduits);
    if (!isLegit ||
        textReactifs.toString().isEmpty ||
        !isLegit2 ||
        textProduits.toString().isEmpty) {
      print("fuck u");
      return;
    }

    //split les atomes
    for (int i = 0; i < diffReactifs.length; i++) {
      Atome.fonctionTest(
          atomesReactifsTotal[i], nbReactifsTotal[i], diffReactifs[i]);
    }

    for (int i = 0; i < diffProduits.length; i++) {
      Atome.fonctionTest(
          atomesProduitsTotal[i], nbProduitsTotal[i], diffProduits[i]);
    }

    //vérif si atomes réactifs sont dans les produits
    var list1 = List<String>();
    for (int i = 0; i < atomesReactifsTotal.length; i++) {
      for (int j = 0; j < atomesReactifsTotal[i].length; j++) {
        list1.add(atomesReactifsTotal[i][j]);
      }
    }
    var list2 = List<String>();
    for (int i = 0; i < atomesProduitsTotal.length; i++) {
      for (int j = 0; j < atomesProduitsTotal[i].length; j++) {
        list2.add(atomesProduitsTotal[i][j]);
      }
    }

    bool allo = true;
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        allo = false;
      }
    }

    if (!allo) {
      print("fuckk u");
      return;
    } else {
      print("hola");
    }

    //mettre atomes dans une matrice
    List<List<double>> matrix = new List<List<double>>();

    Atome.CreerMatrice(atomesReactifsTotal, nbReactifsTotal,
        atomesProduitsTotal, nbProduitsTotal, matrix);

    final mat = Matrix(matrix);
    print(mat);

    //résoudre la matrice
    String url = "http://vps.benliam12.net:8000/";
    Map<String, String> headers = {"Content-type": "application/json"};

    String json = jsonEncode(matrix);

    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('$body - $statusCode');

    //trouver les coefficients
    String newbody = body.replaceAll('{', '').replaceAll('}', '');

    var firstSplit = newbody.split(', ');
    var secondsplit = {};

    for (var i = 0; i < firstSplit.length; i++) {
      var t = firstSplit[i].split(':');
      var letter = t[0].replaceAll('"', '');
      var answer = t[1].replaceAll('"', '');
      secondsplit[letter] = answer;
    }

    var alp = "a".codeUnitAt(0);
    var alp_end = "z".codeUnitAt(0);

    while (alp <= alp_end) {
      var letter = new String.fromCharCode(alp);
      if (!secondsplit.containsKey(letter)) {
        break;
      }
      alp++;
    }

    var listValeurs = {};
    var alp2 = "a".codeUnitAt(0);

    for (alp2 = "a".codeUnitAt(0); alp2 < alp; alp2++) {
      var let = new String.fromCharCode(alp);
      var curLet = new String.fromCharCode(alp2);
      listValeurs[curLet] = double.parse(
          secondsplit[curLet].replaceAll("*$let", '').replaceAll(" $let", '1'));
    }

    print(new String.fromCharCode(alp));

    double valMin = 100.0;
    var let2 = new String.fromCharCode(alp);
    listValeurs[let2] = 1.0;

    for (alp2 = "a".codeUnitAt(0); alp2 <= alp; alp2++) {
      var curLet = new String.fromCharCode(alp2);
      if (listValeurs[curLet] < valMin) {
        valMin = listValeurs[curLet];
      }
    }

    for (alp2 = "a".codeUnitAt(0); alp2 <= alp; alp2++) {
      var curLet = new String.fromCharCode(alp2);
      listValeurs[curLet] *= (1 / valMin);
      listValeurs[curLet] = listValeurs[curLet].round();
    }

    //afficher la solution
    setState(() {
      solution_finale = "Solution: ";
      var list = listValeurs.values.toList();
      for (int i = 0; i < diffReactifs.length; i++) {
        if (list[i] != 1) {
          solution_finale += list[i].toString();
        }
        solution_finale += diffReactifs[i];
        if ((i + 1) < diffReactifs.length) solution_finale += " + ";
      }
      solution_finale += " -> ";
      for (int i = 0; i < diffProduits.length; i++) {
        if (list[i + diffReactifs.length] != 1) {
          solution_finale += list[i + diffReactifs.length].toString();
        }
        solution_finale += diffProduits[i];
        if ((i + 1) < diffProduits.length) solution_finale += " + ";
      }
    });
  }

  void killMe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Modeles()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => killMe(context),
          )
        ],
        title: Text(
          "Calculatrice de stoechiométrie",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Entrez l\'équation à balancer'),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: reactifs,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: '1',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Première case vide';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: produits,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: '2',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Deuxième case vide';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RaisedButton(
                  padding: new EdgeInsets.all(5.0),
                  child: Text('OK'),
                  onPressed: () {
                    solution();
                  }),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(solution_finale),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
