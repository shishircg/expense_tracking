import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exp_t/main.dart';

void main() {
  testWidgets('monthly budget flow shows overview and saves a new entry', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const BudgetTrackerApp());

    expect(find.text('Monthly summary'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Spent'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.byIcon(Icons.add_circle_outline),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New entry'), findsOneWidget);
    expect(find.text('Save entry'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Coffee run');
    await tester.enterText(find.byType(TextFormField).at(1), '12.50');
    await tester.tap(find.text('Save entry'));
    await tester.pumpAndSettle();

    expect(find.textContaining('entries in'), findsOneWidget);
    expect(find.text('Coffee run'), findsOneWidget);
  });
}
