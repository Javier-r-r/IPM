import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ipm74/provider_api.dart';
import 'package:flutter_ipm74/history_page.dart';

void main() {
  testWidgets('HistoryPage', (WidgetTester tester) async {
    // Crear una instancia de ProviderApi con datos de prueba
    final providerApi = ProviderApi();
    providerApi.items = ['item 1', 'item 2'];

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: providerApi,
        child: MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    // Verificar que los elementos se muestren correctamente
    expect(find.text('item 1'), findsOneWidget);
    expect(find.text('item 2'), findsOneWidget);

    // Tocar el botón de eliminar para el primer elemento
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    // Verificar que el primer elemento se elimine
    expect(find.text('item 1'), findsNothing);
    expect(find.text('item 2'), findsOneWidget);

    // Tocar el botón 'Eliminar Todos'
    await tester.tap(find.text('Eliminar Todos'));
    await tester.pump();

    // Verificar que se eliminen todos los elementos
    expect(find.text('item 1'), findsNothing);
    expect(find.text('item 2'), findsNothing);
  });
}
