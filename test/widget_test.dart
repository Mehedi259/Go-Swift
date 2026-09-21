import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_swift/app.dart';

void main() {
  testWidgets('GoSwift app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoSwiftApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
