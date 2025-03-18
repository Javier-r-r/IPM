import 'package:flutter/material.dart';
import 'package:flutter_ipm74/generator_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:flutter_ipm74/main.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar el archivo correcto

void main(){ 
  testWidgets('Testear Navigation rail', (WidgetTester tester) async {
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

    // Probar el boton para navegar a favoritos
    await tester.tap(find.byIcon(Icons.favorite_sharp));
    expect(find.text('Eliminar Todos'), findsOneWidget);
    await tester.pump();


        // Probar el boton para navegar a home
   final homeIconFinder = find.byIcon(Icons.home, skipOffstage: false);

  if (homeIconFinder.evaluate().isNotEmpty) {
    if (tester.widget(homeIconFinder) is IconButton) {
      await tester.tap(homeIconFinder);
      await tester.pump();
      // Verificar que los elementos esenciales estén presentes en la página
      expect(find.text('Convertir:'), findsOneWidget);
      expect(find.text('a:'), findsOneWidget);
      expect(find.byType(CalcularButton), findsOneWidget);
      expect(find.text('Calcular'), findsOneWidget);
    } 
  }

    // Probar el boton para navegar a historial
    await tester.tap(find.byIcon(Icons.history));
    expect(find.text('Eliminar Todos'), findsOneWidget);
    await tester.pump();

  });
}