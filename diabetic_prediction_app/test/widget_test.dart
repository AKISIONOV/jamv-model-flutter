import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diabetic_prediction_app/main.dart';
import 'package:diabetic_prediction_app/screens/home_screen.dart';

void main() {
  testWidgets('Home screen renders correctly and contains key UI elements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verify that our title is present.
    expect(find.text('Diabetic Prediction AI'), findsOneWidget);
    expect(find.text('Offline Edge AI'), findsOneWidget);

    // Verify the buttons are present.
    expect(find.text('Start New Prediction'), findsOneWidget);
    expect(find.text('View History'), findsOneWidget);

    // Verify icons.
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);
  });
}
