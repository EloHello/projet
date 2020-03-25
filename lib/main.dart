import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testing/imdumb.dart';
import 'package:extended_math/extended_math.dart';

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

  void solution() {
    List diffReactifs = new List();
    List diffProduits = new List();

    var textReactifs = reactifs.text;
    var textProduits = produits.text;

    diffReactifs = textReactifs.split('+');
    diffProduits = textProduits.split('+');

    var atomesReactifsTotal =
        new List.generate(diffReactifs.length, (_) => new List());
    var nbReactifsTotal =
        new List.generate(diffReactifs.length, (_) => new List<int>());

    for (int i = 0; i < diffReactifs.length; i++) {
      Atome.fonctionTest(
          atomesReactifsTotal[i], nbReactifsTotal[i], diffReactifs[i]);
    }

    var atomesProduitsTotal =
        new List.generate(diffProduits.length, (_) => new List());
    var nbProduitsTotal =
        new List.generate(diffProduits.length, (_) => new List<int>());

    for (int i = 0; i < diffProduits.length; i++) {
      Atome.fonctionTest(
          atomesProduitsTotal[i], nbProduitsTotal[i], diffProduits[i]);
    }

    List<List<double>> matrix = new List<List<double>>();

    Atome.CreerMatrice(atomesReactifsTotal, nbReactifsTotal,
        atomesProduitsTotal, nbProduitsTotal, matrix);

    final c = Matrix(matrix);
    print(c);

    if (matrix.length == matrix[0].length) {
      Atome.ResoudreMatrice(matrix);
    }

    /*int taille = matrix.length;
    int nbZeros = 0;

    for (int j = 0; j < matrix[0].length; j++) {
      if (matrix[taille - 1][j] == 0) {
        nbZeros++;
      }
    }

    if (nbZeros == matrix[taille - 1].length) {
      print(c);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
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
                child: Text('Solution:'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
