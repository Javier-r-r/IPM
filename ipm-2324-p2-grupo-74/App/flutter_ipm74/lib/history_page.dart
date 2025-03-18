import 'package:flutter/material.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late ProviderApi appState; // Anotación de tipo añadida

  @override
  Widget build(BuildContext context) {
    appState = context.watch<ProviderApi>();

    return Column(
      children: <Widget>[
        SizedBox(height: 5.0),
        // Botón para eliminar todos los elementos
        ElevatedButton(
          onPressed: () {
            _eliminarTodosElementos();
          },
          child: Text('Eliminar Todos'),
        ),
        Divider(),
        // Lista de elementos
        Expanded(
          child: ListView.builder(
            itemCount: appState.items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Card(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(appState.items[index]),
                      textColor: Colors.white,
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.white,
                        onPressed: () {
                          _eliminarElemento(index);
                        },
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors
                        .white, // Puedes ajustar el color según tus preferencias
                    thickness:
                        1.0, // Puedes ajustar el grosor según tus preferencias
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _eliminarElemento(int index) {
    setState(() {
      appState.items.removeAt(index);
    });
  }

  void _eliminarTodosElementos() {
    setState(() {
      appState.items.clear();
    });
  }
}
