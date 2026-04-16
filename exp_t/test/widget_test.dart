import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exp_t/main.dart';

void main() {
  testWidgets('expense prototype supports core navigation flow', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ExpensePrototypeApp());

    expect(find.text('Track every rupee with clarity.'), findsOneWidget);
    expect(find.text('Log an expense'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byIcon(Icons.receipt_long_outlined),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Search and filters'), findsOneWidget);
    expect(find.text('Current view'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byIcon(Icons.add_circle_outline),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New expense'), findsOneWidget);
    expect(find.text('Live preview'), findsOneWidget);
  });
}
