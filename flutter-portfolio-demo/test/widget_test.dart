import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_demo/main.dart';

void main() {
  testWidgets('zeigt Mock-Feed und filtert nach Suchbegriff', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Algorithmen Lernzettel'), findsOneWidget);
    expect(find.text('Datenbanken Uebungsblatt'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'Flutter');
    await tester.pumpAndSettle();

    expect(find.text('Flutter State Management Notizen'), findsOneWidget);
    expect(find.text('Algorithmen Lernzettel'), findsNothing);
  });
}

