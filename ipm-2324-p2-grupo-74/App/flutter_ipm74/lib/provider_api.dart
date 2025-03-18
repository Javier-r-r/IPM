import 'dart:convert';

import 'package:flutter/material.dart';
import 'server_stub.dart' as stub;

class ProviderApi extends ChangeNotifier {
  double _convertRatio = 0;
  String _comp = "";
  List<String> items = [];
  String _favoriteMessage = ""; // Nueva propiedad para el mensaje de favoritos

  String get comp => _comp;
  double get convertRatio => _convertRatio;
  String get favoriteMessage =>
      _favoriteMessage; // Getter para el mensaje de favoritos
  
  Future<void> convertRatioApiCall(String pair, String money) async {
    if (money.isEmpty) {
      _comp = "Error: Inserte una cantidad";
      notifyListeners();
      return;
    }

    try {
      double moneyD = double.parse(money);
      //Es para el historial, dinero en la primera divisa, par, dinero en la segunda divisa (se añade despues de la llamada a la API)
      String item = "$money $pair ";
      //creamos la Uri
      var uri = Uri(
          scheme: 'https',
          host: 'fcsapi.com',
          path: "/api-v3/forex/latest",
          queryParameters: {
            'symbol': pair,
            'access_key': 'MY_API_KEY',
          });

      //comprueba si las divisas son iguales, si lo son devuelve un error
      List<String> parts = pair.split("/");
      if (parts[0] == parts[1]) {
        _comp = "Error: Elige divisas diferentes";
        notifyListeners();
        return;
      }

      var response = await stub.get(uri);

      //si obtenemos un status code que nos ea 200, devolvemos un error
      if (response.statusCode != 200) {
        _comp = "Error: ${response.statusCode}";
        notifyListeners();
        return;
      }
      var dataAsDartMap = jsonDecode(response.body);
      double convertRatio = double.parse(dataAsDartMap["response"][0]["c"]);
      //Calculo del resultado
      _comp = (convertRatio * moneyD).toStringAsFixed(2);
      //se completa el valor que va a ir al historial
      item = item + _comp;
      items.add(item);
      notifyListeners();
    } catch (e) {
      if (e is FormatException) {
        _comp = "Error: Inserte un número";
        notifyListeners();
      } else {
        _comp = "Error inesperado: $e";
        notifyListeners();
      }
    }
  }
}
