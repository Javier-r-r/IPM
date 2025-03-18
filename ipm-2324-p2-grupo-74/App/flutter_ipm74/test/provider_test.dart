import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipm74/generator_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:flutter_ipm74/main.dart';
import 'package:provider/provider.dart';

void main(){
  testWidgets('Testear Error mismas divisas en el pair a convertir', (WidgetTester tester) async {
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

   //Le metemos un valor random al input fild
   MyInputFieldState.setText("12.5");//Le metemos un valor random al input fild
   MyInputFieldState.setText("12.5");
   //Le da la boton de calcular
   await tester.tap(find.byType(CalcularButton));
   await tester.pump(); 

   //no hace falta modificar los dropdownbutton example devido a que por defecto los dos estan en EUR
   expect(find.text('Error: Elige divisas diferentes'), findsOneWidget);
  
  });

  testWidgets('Testear Error cuando no insertas texto en el input field', (WidgetTester tester) async {
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

    
   //Le da la boton de calcular
   await tester.tap(find.byType(CalcularButton));
   await tester.pump(); 

   expect(find.text('Error: Inserte una cantidad'), findsOneWidget);

  });


}