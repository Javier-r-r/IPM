import 'package:flutter/material.dart';
import 'package:flutter_ipm74/generator_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:flutter_ipm74/main.dart' as app;
import 'package:flutter_ipm74/main.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar el archivo correcto

void main() {
 testWidgets('Testear GeneratorPage elementos basicos', (WidgetTester tester) async {
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

    // Verificar que los elementos esenciales estén presentes en la página
    expect(find.text('Convertir'), findsOneWidget);
    expect(find.text('a:'), findsOneWidget);
    expect(find.byType(CalcularButton), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);

    // Verificar que el estado del botón de favoritos ha cambiado
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);


  });

   testWidgets('Error en la entrada de texto:', (WidgetTester tester) async {
    app.main();
    
     await tester.pumpWidget(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProviderApi>(
        create: (context) => ProviderApi(),
      ),
      ChangeNotifierProvider<MyAppState>(
        create: (context) => MyAppState(),
      )
    ],
    child: MaterialApp(  // Añade un MaterialApp aquí
      home: Builder(
        builder: (_) => GeneratorPage(),
      ),
    ),
  ),);

    // Verificar si se muestra un mensaje de error al estar vacío
    await tester.enterText(find.byType(TextField), '');
    await tester.pump(); // Asegura que los cambios se reflejen

    expect(find.text('Ingresa la cantidad a convertir'), findsOneWidget);
  });

  testWidgets('Manejo de errores en el botón de cálculo:', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProviderApi>(
        create: (context) => ProviderApi(),
      ),
      ChangeNotifierProvider<MyAppState>(
        create: (context) => MyAppState(),
      )
    ],
    child: MaterialApp(  // Añade un MaterialApp aquí
      home: Builder(
        builder: (_) => GeneratorPage(),
      ),
    ),
  ),);

   CalcularButtonState calcularButtonState = tester.state(
      find.byType(CalcularButton),
    );

    // Verificar si el botón está habilitado inicialmente
    expect(calcularButtonState.isLoading, isFalse);


    //Simula q se esta haciendo una llamada a la API
    calcularButtonState.handleButtonPress();

    // Verificar si el botón está deshabilitado mientras se realiza una operación
    expect(calcularButtonState.isLoading, isTrue);
  });
}
