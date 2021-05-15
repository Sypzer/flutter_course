import 'dart:convert';

import 'package:http/http.dart';

class ApiManager {
  List<String> _currencyIds = [];
  List<String> _currencyNames = [];
  List<String> _currencySymbols = [];

  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    final String apiKey = '0c7c94c4afa941a4087d';

    final Response dataResponse =
        await get(Uri.https('free.currconv.com', '/api/v7/convert', {
      'q': '${fromCurrency}_$toCurrency',
      'compact': 'ultra',
      'apiKey': apiKey,
    }));

    final Map<String, dynamic> map = jsonDecode(dataResponse.body);

    double value = map['${fromCurrency}_$toCurrency'];
    return value;
  }

  Future<void> getCurrencies() async {
    final String apiKey = '0c7c94c4afa941a4087d';

    final Response dataResponse = await get(Uri.https(
      'free.currconv.com',
      'api/v7/currencies',
      {
        'apiKey': apiKey,
      },
    ));

    Map<String, dynamic> map = jsonDecode(dataResponse.body);

    map = map['results'];

    map.forEach((String key, dynamic value) {
      _currencyIds.add(key);
      _currencyNames.add(value['currencyName']);
      _currencySymbols.add(value['currencySymbol']);
    });
  }

  List<String> getCurrencyIds() {
    return _currencyIds;
  }

  List<String> getCurrencyNames() {
    return _currencyNames;
  }

  List<String> getCurrencySymbols() {
    return _currencySymbols;
  }
}
