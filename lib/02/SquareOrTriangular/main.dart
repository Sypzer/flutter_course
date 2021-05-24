import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String error;
  String input;
  String alertTxT;

  bool isTriangular(int num) {
    if (num < 0) return false;

    int sum = 0;
    for (int i = 1; i < num; i++) {
      sum += i;
      if (sum == num) return true;
    }
    return false;
  }

  bool isSquare(int num) {
    if (num < 0) return false;

    for (int i = 1; i * i <= num; i++) {
      if (i * i == num) return true;
    }
    return false;
  }

  void showResultedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(input),
            content: Text(alertTxT),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Shapes'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Text(
                  'Please input a number to see if it is square or triangular'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter number: ',
                  errorText: error,
                ),
                onChanged: (String value) {
                  input = value;
                },
              ),

              TextButton(
                onPressed: () {
                  if (int.tryParse(input) != null) {
                    setState(() {
                      error = null;
                    });
                    if (isTriangular(int.tryParse(input))) {
                      if (isSquare(int.tryParse(input))) {
                        alertTxT =
                            'Number $input is both SQUARE and TRIANGULAR';
                        showResultedDialog();
                      } else {
                        alertTxT = 'Number $input is TRIANGULAR';
                        showResultedDialog();
                      }
                    } else {
                      if (isSquare(int.tryParse(input))) {
                        alertTxT = 'Numeber $input is SQUARE';
                        showResultedDialog();
                      }else{
                        alertTxT = 'Number $input is neither SQUARE or TRIANGULAR.';
                        showResultedDialog();
                      }
                    }
                  } else {
                    setState(() {
                      error = 'Please enter a valid number';
                    });
                  }
                },
                child: Icon(Icons.check),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
