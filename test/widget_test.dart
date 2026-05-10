import 'package:flutter/material.dart';
import 'package:product_list_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductListApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
