import 'package:flutter/material.dart';
import 'file:///C:/Users/irimi/IdeaProjects/flutter_course/lib/Course 01/api_manager.dart';
import 'dart:async';

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
  ApiManager manager = ApiManager();

  List<String> currencyIds = [];
  List<String> currencyNames = [];
  List<String> currencySymbols = [];

  String _fieldInput = '';
  String resultedConversion = '';
  double opacity = 0;
  String error = '';

  double exchangeRate = 1.0;
  String fromCurrencyName = 'Euro';
  String toCurrencyName = 'Romanian Leu';

  //We are using this completer to show the ui only when the api data has been loaded
  final Completer<List<String>> completer = Completer<List<String>>();

  //getting currencies form https://www.currencyconverterapi.com/
  Future<void> getCurrenciesAll() async {
    await manager.getCurrencies();
    exchangeRate = await manager.getExchangeRate('EUR', 'RON');

    setState(() {
      currencyNames = manager.getCurrencyNames();
      currencyIds = manager.getCurrencyIds();
      currencySymbols = manager.getCurrencySymbols();

      completer.complete(currencyNames);
    });
  }

  //We will update the exchange rate everytime we make a change in the currencies we are to convert
  Future<void> updateExchangeRate() async {
    exchangeRate = await manager.getExchangeRate(
        currencyIds[currencyNames.indexOf(fromCurrencyName)],
        currencyIds[currencyNames.indexOf(toCurrencyName)]);
  }

  @override
  void initState() {
    getCurrenciesAll();
    super.initState();
  }

  //This function will invert the fromCurrency and toCurrency variables
  void invert() {
    setState(() {
      String aux = fromCurrencyName;
      fromCurrencyName = toCurrencyName;
      toCurrencyName = aux;
    });
    updateExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MONEY CONVERTER',
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 5.0,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //Center Column contents horizontally,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(
                        'https://media3.giphy.com/media/67ThRZlYBvibtdF9JH/200.gif'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: DropdownButton(
                        isExpanded: true,
                        value: fromCurrencyName,
                        onChanged: (newValue) {
                          setState(() {
                            opacity = 0;
                            fromCurrencyName = newValue;
                            updateExchangeRate();
                          });
                        },
                        items: currencyNames.map((valueItem) {
                          return DropdownMenuItem(
                            child: Text(
                              valueItem,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            value: valueItem,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3 - 16,
                    child: TextButton(
                      onPressed: invert,
                      child: Text(
                        'Invert',
                        style: TextStyle(
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      child: DropdownButton(
                        isExpanded: true,
                        value: toCurrencyName,
                        onChanged: (newValue) {
                          setState(() {
                            opacity = 0;
                            toCurrencyName = newValue;
                            updateExchangeRate();
                          });
                        },
                        items: currencyNames.map((valueItem) {
                          return DropdownMenuItem(
                            child: Text(
                              valueItem,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            value: valueItem,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Amount',
                        errorText: error,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _fieldInput = value;
                          opacity = 0;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        updateExchangeRate();
                        if (num.tryParse(_fieldInput) != null) {
                          double value = double.parse(_fieldInput);
                          value = value * exchangeRate;
                          resultedConversion = value.toStringAsFixed(2) +
                              ' ${currencySymbols[currencyNames.indexOf(toCurrencyName)]}';
                          error = '';
                          opacity = 1;
                        } else
                          error = 'Please enter a valid number';
                      });
                    },
                    child: Text(
                      'CONVERT!',
                      style: TextStyle(
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      resultedConversion,
                      style: TextStyle(
                        color: Colors.greenAccent.withOpacity(opacity),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        },
      ),
    );
  }
}
