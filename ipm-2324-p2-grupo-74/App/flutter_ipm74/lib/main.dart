import 'package:flutter/material.dart';
import 'package:flutter_ipm74/favorites_page.dart';
import 'package:flutter_ipm74/generator_page.dart';
import 'package:flutter_ipm74/history_page.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:flutter_ipm74/responsive.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProviderApi>(
        create: (_) => ProviderApi(),
      ),
      ChangeNotifierProvider<MyAppState>(
        create: (_) => MyAppState(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderApi(),
      child: MaterialApp(
        title: 'Currency Conversor',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Conversor de Divisas',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.blue,
              ),
            ),
          ),
          body: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void cambiarPagina(int index) {
    setState(() {
      selectedIndex = index; // Cambia la página al índice deseado
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageL = [
      GeneratorPage(),
      FavoritesPage(
        cambiarPaginaFunc: cambiarPagina,
      ),
      HistoryPage(),
    ];
    Widget page = GeneratorPage();
    if (Responsive.isMobile(context)) {
      switch (selectedIndex) {
        case 0:
          page = pageL[0];
          break;
        case 1:
          page = pageL[1];
          break;
        case 2:
          page = pageL[2];
          break;
        default:
          throw UnimplementedError('No hay widget para $selectedIndex');
      }
    } else {
      switch (selectedIndex) {
        case 0:
          page = pageL[1];
          break;
        case 1:
          page = pageL[2];
          break;
        case 2: //este caso es porque para que no halla errores,
          page = pageL[2]; //el navigation rail debe tener el mismo numero de
          break; //destinos tanto para la tablet como para el movil
        default:
          throw UnimplementedError('No hay widget para $selectedIndex');
      }
    }

    return Scaffold(
        body: Responsive(
      mobileV: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_sharp),
                  label: Text('Favoritos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: page,
            ),
          ),
        ],
      ),
      mobileH: Row(
        children: [
          Expanded(
            flex: 2,
            child: NavigationRail(
              extended: true,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_sharp),
                  label: Text('Favoritos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: page,
            ),
          ),
        ],
      ),
      tabletH: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_sharp),
                  label: Text('Favoritos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
                NavigationRailDestination(
                  icon: IgnorePointer(
                    ignoring:
                        true, // Esto desactiva la interacción con el ícono
                    child: Icon(Icons.history_rounded, color: Colors.transparent),
                  ),
                  label: Text('Relleno'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  if (value == 2) {
                    value -= 1;
                  }
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: page,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: pageL[0],
            ),
          ),
        ],
      ),
      tabletV: Row(
        children: [
          Expanded(
            // Agregamos el Expanded para el NavigationRail
            flex: 0,
            child: SafeArea(
              child: NavigationRail(
                extended: false,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_sharp),
                    label: Text('Favoritos'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history),
                    label: Text('Hisrotial'),
                  ),
                  NavigationRailDestination(
                    icon: IgnorePointer(
                      ignoring:
                          true, // Esto desactiva la interacción con el ícono
                      child: Icon(Icons.history_rounded, color: Colors.transparent),
                    ),
                    label: Text('Relleno'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    if (value == 2) {
                      value -= 1;
                    }
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: page,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: pageL[0]),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
