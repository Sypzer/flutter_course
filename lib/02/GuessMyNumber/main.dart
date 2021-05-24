import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'guess_logic.dart';

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
  GuessLogic logics = GuessLogic();
  String guessedInt = '';

  @override
  void initState() {
    logics.initializeLogic();
  }

  void showGuessedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('You guessed right'),
            content: Text('It was $guessedInt'),
            actions: <Widget>[
              TextButton(
                child: Text('Try again!'),
                onPressed: () {
                  logics.initializeLogic();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  setState(() {
                    logics.setButtonToReset();
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                "I'm thinking of a number between 1 and 100",
                style: TextStyle(),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "It's your turn to guess my nymber!",
                style: TextStyle(),
              ),
              if (logics.guessed)
                Text(
                  logics.youTriedTxt,
                ),
              if (logics.guessed)
                Text(
                  logics.adviceTxt,
                ),
              SizedBox(
                height: 16,
              ),
              Material(
                elevation: 16,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Try a number!',
                          style: TextStyle(fontSize: 24),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Your guess:'),
                          validator: (String value) {
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            guessedInt = value;
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Builder(builder: (BuildContext context) {
                          return TextButton(
                            onPressed: () {
                              setState(() {
                                if (logics.buttonToReset == false) {
                                  if (Form.of(context).validate()) {
                                    if (logics.guess(int.parse(guessedInt))) {
                                      showGuessedDialog();
                                    }
                                  }
                                } else {
                                  logics.initializeLogic();
                                }
                              });
                            },
                            child: Text(logics.buttonTxt),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
