// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';  // adjust this if your app's package name or main file is different

void main() {
  testWidgets('Calculate total and change correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(CashierApp());

    // Find the TextFields by their label text
    final itemNameField = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Item Name',
    );
    final unitPriceField = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Unit Price',
    );
    final quantityField = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Quantity',
    );
    final amountPaidField = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Amount Paid',
    );

    // Enter some values
    await tester.enterText(itemNameField, 'Apple');
    await tester.enterText(unitPriceField, '10000');
    await tester.enterText(quantityField, '3');
    await tester.enterText(amountPaidField, '40000');

    // Tap the "Calculate Total" button
    final calculateButton = find.text('Calculate Total');
    expect(calculateButton, findsOneWidget);

    await tester.tap(calculateButton);
    await tester.pump(); // Rebuild widget after state changes

    // Check if total and change are displayed correctly
    expect(find.text('Total: Rp30000'), findsOneWidget);
    expect(find.text('Change: Rp10000'), findsOneWidget);
  });
}
