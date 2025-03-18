import 'package:flutter/material.dart';
import 'package:flutter_ipm74/generator_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:flutter_ipm74/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test Widgets', (WidgetTester tester) async {
    // Construir nuestro widget y disparar un frame
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProviderApi>(
              create: (_) => ProviderApi(),
            ),
            ChangeNotifierProvider<MyAppState>(
              create: (_) => MyAppState(),
            ),
          ],
          child: MyApp(),
        ),
      ),
    );

    // Probar el botón para navegar a favoritos
    await tester.tap(find.byIcon(Icons.favorite_sharp));
    await tester.pump();

    
    // Verificar la presencia de elementos específicos en FavoritesPage cuando esté en la sección de favoritos
    expect(find.text('Eliminar Todos'), findsOneWidget);

    // Probar el botón para navegar a la página principal (home)
    final homeIconFinder = find.byIcon(Icons.home, skipOffstage: false);

    if (homeIconFinder.evaluate().isNotEmpty) {
      if (tester.widget(homeIconFinder) is IconButton) {
        await tester.tap(homeIconFinder);
        await tester.pump();

        // Verificar que los elementos estén presentes en la página principal
      expect(find.byType(MyInputField), findsOneWidget);
      expect(find.byType(DropdownButtonExample), findsNWidgets(2));
      expect(find.text('Convertir'), findsOneWidget);
      expect(find.text('a:'), findsOneWidget);
      expect(find.byType(CalcularButton), findsOneWidget);
      expect(find.text('Calcular'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      }
    }

    // Probar el botón para navegar al historial
    await tester.tap(find.byIcon(Icons.history));
    await tester.pump();

    // Verificar que los elementos estén presentes después de la navegación al historial
    expect(find.text('Eliminar Todos'), findsOneWidget);

    // Comprobar widgets en HistoryPage
    await tester.pumpAndSettle(); // Asegurar que la transición de navegación se complete

    //final eliminarTodosButtonFinder = find.byType(ElevatedButton);
    //expect(eliminarTodosButtonFinder, findsOneWidget);


  });
}
