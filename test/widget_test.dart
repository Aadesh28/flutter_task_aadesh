
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_aadesh/main.dart';

void main() {
  testWidgets('New diary UI test', (WidgetTester tester) async {
  // Build the app and trigger a frame.

  await tester.pumpWidget(const MyApp());
   
  // Tap button
  final button = find.byKey(const Key('add_photo_button'));
  await tester.tap(button);
  expect(button, findsOneWidget);

  await tester.pump();  

   final nextButton = find.byKey(const Key('next_button'));
  await tester.tap(nextButton);
  expect(nextButton, findsOneWidget);

  // Pump widget tree to advance time
  await tester.pump();

  });
}
