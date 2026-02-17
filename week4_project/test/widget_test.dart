import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_project/main.dart';

void main() {
  testWidgets('Expense Tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is present
    expect(find.text('Expense Tracker'), findsOneWidget);

    // Verify that the FAB is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that we navigated to the 'Add Expense' screen
    expect(find.text('Add Expense'), findsOneWidget);
  });
}
