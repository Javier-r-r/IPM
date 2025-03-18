import 'package:flutter/material.dart';
import 'package:flutter_ipm74/generator_page.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  final Function(int) cambiarPaginaFunc;
  FavoritesPage({required this.cambiarPaginaFunc});
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late MyAppState appState;

  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();

    return Column(
      children: <Widget>[
        SizedBox(height: 5.0),
        // Botón para eliminar todos los favoritos
        ElevatedButton(
          onPressed: () {
            _eliminarTodosFavoritos();
          },
          child: Text('Eliminar Todos'),
        ),
        Divider(),
        // Lista de favoritos
        Expanded(
          child: ListView.builder(
            itemCount: appState.favorites.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Card(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(appState.favorites[index]),
                      textColor: Colors.white,
                      trailing: IconButton(
                        icon: Icon(Icons.heart_broken),
                        color: Colors.white,
                        onPressed: () {
                          _eliminarFavorito(index);
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Acción a realizar cuando se presiona el botón
                      DropdownButtonExample.divisas[0] =
                          appState.favorites[index].substring(0, 3);
                      DropdownButtonExample.divisas[1] =
                          appState.favorites[index].substring(4, 7);
                      widget.cambiarPaginaFunc(0);
                    },
                    child: Text('Convertir ${appState.favorites[index]}'),
                  ),
                  Divider(), // Opcional: agregar un divisor entre elementos
                ],
              );
            },
          ),
        ),
        // Mostrar mensajes de favoritos
        Text(
          "",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  void _eliminarFavorito(int index) {
    setState(() {
      appState.favorites.removeAt(index);
    });
  }

  void _eliminarTodosFavoritos() {
    setState(() {
      appState.favorites.clear();
    });
  }
}
