import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:provider/provider.dart';

class MyAppState extends ChangeNotifier {
  var favorites = <String>[];
  void buttonState() {
    notifyListeners();
  }

  bool compareStringParts(String str) {
    if (str.contains('/')) {
      List<String> parts = str.split('/');
      return parts[0] == parts[1];
    } else {
      return false;
    }
  }

  void toggleFavorite(String item) {
    if (favorites.contains(item)) {
      favorites.remove(item);
    } else {
      if(!compareStringParts(item)) {
        favorites.add(item);
      }
    }
    notifyListeners();
  }
}

class GeneratorPage extends StatelessWidget {
  static late MyAppState favouriteState;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ProviderApi>();
    favouriteState = context.watch<MyAppState>();
    Color color = Colors.white;
    final DropdownButtonExample card1 = DropdownButtonExample();
    final DropdownButtonExample card2 = DropdownButtonExample();
    MyInputField fild = MyInputField();
    IconData icon;

    if (favouriteState.favorites.contains(card1.getPair())) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double fontSize = deviceWidth * 0.05;
    final double spacing = deviceHeight * 0.02;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Center(
          child: SingleChildScrollView(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      fild,
      const SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 1.0), // Ajusta la cantidad de espacio a la derecha
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Convertir",
            style: TextStyle(color: color, fontSize: fontSize),
          ),
        ),
      ),
      SizedBox(height: 10.0),
      Align(
        alignment: Alignment.centerRight,
        child: card1,
      ),
    ],
  ),
),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "a:",
                    style: TextStyle(color: color, fontSize: fontSize),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.center,
                  child: card2,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      favouriteState.toggleFavorite(card1.getPair());
                    },
                    icon: Icon(icon),
                    label: Text(
                      'Fav',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: spacing),
      Container(
        color: Colors.white,
        child: CalcularButton(
          appState: appState,
          card1: card1,
          fild: fild,
          fontSize: fontSize,
        ),
      ),
      SizedBox(height: spacing),
      Text(
        appState.comp,
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    ],
  ),
)
        );
      },
    );
  }
}

//boton para hacer la llamada a la API

class CalcularButton extends StatefulWidget {
  const CalcularButton({
    Key? key,
    required this.appState,
    required this.card1,
    required this.fild,
    required this.fontSize,
  }) : super(key: key);
  
  final ProviderApi appState;
  final DropdownButtonExample card1;
  final MyInputField fild;
  final double fontSize;

  @override
  State<CalcularButton> createState() => CalcularButtonState();
}

class CalcularButtonState extends State<CalcularButton> {
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : handleButtonPress,
      child: _buildButtonChild(),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Calculando...'),
          SizedBox(width: 8.0),
          CircularProgressIndicator(),
        ],
      );
    } else {
      return Text(
        'Calcular',
        style: TextStyle(fontSize: widget.fontSize, color: Colors.blue),
      );
    }
  }

  void handleButtonPress() async {
    // Inicia la carga
    setState(() {
      isLoading = true;
    });

    try {
      // Realiza la operación asincrónica (puedes reemplazar esto con tu propia lógica)
      await widget.appState.convertRatioApiCall(
          widget.card1.getPair(), widget.fild.controller().text);
      widget.fild.controller().clear();
      widget.fild.controller().text = '';
      widget.fild.setHasInput(false);
    } catch (error) {
      // Manejar errores si es necesario
      print('Error: $error');
    } finally {
      // Detiene la carga después de que la operación asincrónica haya terminado
      setState(() {
        isLoading = false;
      });
    }
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});
  static int instances = 0;
  static List<String> divisas = ['EUR', 'EUR'];

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();

  List<String> getDivisas() {
    return divisas;
  }

  String getPair() {
    return "${divisas[0]}/${divisas[1]}";
  }
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  static List<String> list = <String>[
    "EUR",
    "USD",
    "JPY",
    "DKK",
    "GBP",
    "SEK",
    "CHF",
    "NOK",
    "RUB",
    "TRY",
    "AUD",
    "BRL",
    "CAD",
    "CNY",
    "INR",
    "MXN",
    "ZAR"
  ];
  String dropdownValue = list.first;
  int instanceNumber = -1;

  @override
  Widget build(BuildContext context) {
    if (instanceNumber == -1) {
      instanceNumber = DropdownButtonExample.instances;
      DropdownButtonExample.instances += 1;
      if (DropdownButtonExample.instances >= 2) {
        DropdownButtonExample.instances = 0;
      }
    }
    String dropdownValue = DropdownButtonExample.divisas[instanceNumber];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Card(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.blueGrey,
          ),
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blueGrey,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
              DropdownButtonExample.divisas[instanceNumber] = dropdownValue;
              GeneratorPage.favouriteState.buttonState();
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MyInputField extends StatefulWidget {
  @override
  MyInputFieldState createState() => MyInputFieldState();

  TextEditingController controller() {
    return MyInputFieldState.controller();
  }

  void setHasInput(bool toSet) {
    MyInputFieldState.hasInput = false;
  }
}

class MyInputFieldState extends State<MyInputField> {
  static TextEditingController _myController = TextEditingController();
  bool hasError = false;
  static bool hasInput = false;

  static void setText(String text) {
    _myController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      padding: EdgeInsets.all(20.0),
      width: 300,
      height: 90,
      child: Card(
        child: TextField(
          keyboardType: TextInputType.number,
          controller: _myController,
          decoration: InputDecoration(
            labelText: hasInput ? null : 'Ingresa la cantidad a convertir',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: hasError ? Colors.red : Colors.blue),
            ),
          ),
          onChanged: (text) {
            setState(() {
              hasInput = text.isNotEmpty;
              hasError = !isNumeric(text);
            });
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d{0,2})?$'))
          ],
        ),
      ),
    );
  }

  static TextEditingController controller() {
    return _myController;
  }

  bool isNumeric(String value) {
  return double.tryParse(value) != null;
  }
}
