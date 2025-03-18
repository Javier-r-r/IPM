import 'package:flutter/material.dart';
import 'package:flutter_ipm74/main.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:provider/provider.dart'; 
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ipm74/generator_page.dart'; 
import 'package:flutter_ipm74/favorites_page.dart';

void main() {
  
group('MyAppState', () {
    test('toggleFavorite', () {
      final myAppState = MyAppState();

      // Verificar que inicialmente no haya elementos en favoritos
      expect(myAppState.favorites.isEmpty, true);

      // Agregar varios elementos
      myAppState.toggleFavorite('Item 1');
      myAppState.toggleFavorite('Item 2');
      myAppState.toggleFavorite('Item 3');

      // Verificar que los elementos se hayan agregado a favoritos
      expect(myAppState.favorites.contains('Item 1'), true);
      expect(myAppState.favorites.contains('Item 2'), true);
      expect(myAppState.favorites.contains('Item 3'), true);

      // Verificar que la cantidad de elementos sea la esperada
      expect(myAppState.favorites.length, 3);

      // Eliminar un elemento
      myAppState.toggleFavorite('Item 2');

      // Verificar que se haya eliminado 'Item 2' de favoritos
      expect(myAppState.favorites.contains('Item 2'), false);

      // Crear una copia de la lista de favoritos
      final favoritesCopy = List.from(myAppState.favorites);

      // Eliminar todos los elementos
      favoritesCopy.forEach((item) {
        myAppState.toggleFavorite(item);
      });

      // Verificar que la lista de favoritos esté vacía después de eliminar todos los elementos
      expect(myAppState.favorites.isEmpty, true);

      // Verificar que la lista de favoritos esté vacía después de eliminar todos los elementos
      expect(myAppState.favorites.isEmpty, true);
    });

    group('FavoritesPage', () {
      
      testWidgets('Displays Favorites List', (WidgetTester tester) async {
        // Crea una instancia de MyAppState
         final myAppState = MyAppState();

        // Agrega elementos a la lista de favoritos
        myAppState.toggleFavorite('Item 1');
        myAppState.toggleFavorite('Item 2');
      
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<MyAppState>.value(
              value: myAppState,
              child: FavoritesPage(cambiarPaginaFunc: (_) {}),
            ),
          ),
        );

        // Verifica que los elementos se muestren en la lista de favoritos
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('Clears Favorites List', (WidgetTester tester) async {
        final myAppState = MyAppState();

        // Agrega elementos a la lista de favoritos
        myAppState.toggleFavorite('Item 1');
        myAppState.toggleFavorite('Item 2');

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<MyAppState>.value(
              value: myAppState,
              child: FavoritesPage(cambiarPaginaFunc: (_) {}),
            ),
          ),
        );

        // Simula el tap en el botón de eliminar todos los favoritos
        await tester.tap(find.widgetWithText(ElevatedButton, 'Eliminar Todos'));
        await tester.pump();

        // Verifica que la lista está vacía después de eliminar todos los favoritos
        expect(find.byType(ListTile), findsNothing);
      });
      
    });
    
  });

  testWidgets('Funcionalidad de los elementos en la lista de favoritos', (WidgetTester tester) async {
    // Construir nuestro widget y disparar un frame
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ProviderApi>(
          create: (_) => ProviderApi(),
          child: ChangeNotifierProvider<MyAppState>(
            create: (_) => MyAppState(),
            child: MyApp(),
          ),
        ),
      ),
    );
    
    //Damos el valor de un par de ejemplo para probar
    String pair = 'EUR/USD';
    DropdownButtonExample.divisas[0] = 'EUR';
    DropdownButtonExample.divisas[1] = 'USD';
    
    //Se pone como favorito el par de ejemplo
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();  

    //Ponemos los valores del dropdownbutton a un valor cualquiera (en este caso el de por defecto)
    DropdownButtonExample.divisas[0] = 'DKK';
    DropdownButtonExample.divisas[1] = 'EUR';

    //vamos a favoritos y le damos al boton para usar nuestro par
    await tester.tap(find.byIcon(Icons.favorite_sharp));
    await tester.pump();
    await tester.tap(find.text('Convertir ' + pair));


    //comprobamos que estamos en la pagina generator page

    expect(find.text('Convertir'), findsOneWidget);
    expect(find.text('a:'), findsOneWidget);
    expect(find.byType(CalcularButton), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);

    // y que los dropdownbutton tienen los valores deseados
    expect(DropdownButtonExample.divisas[0], 'EUR'); 
    expect(DropdownButtonExample.divisas[1], 'USD'); 


  });
  testWidgets('No añade divisas iguales', (WidgetTester tester) async {
    // Crea una instancia de MyAppState
    final myAppState = MyAppState();

    // Agrega elementos a la lista de favoritos
    myAppState.toggleFavorite('EUR/EUR');
    myAppState.toggleFavorite('USD/USD');

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<MyAppState>.value(
          value: myAppState,
          child: FavoritesPage(cambiarPaginaFunc: (_) {}),
        ),
      ),
    );

    // Verifica que los elementos no se muestren en la lista de favoritos
    expect(find.text('EUR/EUR'), findsNothing);
    expect(find.text('USD/USD'), findsNothing);
    });
}
