// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:vigil/main.dart';

void main() {
  testWidgets('App starts with splash screen on first time', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isFirstTime: true));

    // Wait for animations
    await tester.pumpAndSettle();

    // Verify splash screen shows Vigil text
    expect(find.text('Vigil'), findsOneWidget);
  });

  testWidgets('App navigates to welcome screen for first time user', (
    WidgetTester tester,
  ) async {
    // Build our app with first time user
    await tester.pumpWidget(const MyApp(isFirstTime: true));

    // Fast-forward through the 4-second splash timer
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify we navigated away from splash
    expect(find.text('Vigil'), findsNothing);
  });

  testWidgets('App navigates to login screen for returning user', (
    WidgetTester tester,
  ) async {
    // Build our app with returning user
    await tester.pumpWidget(const MyApp(isFirstTime: false));

    // Fast-forward through the 4-second splash timer
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify splash screen is gone
    expect(find.text('Vigil'), findsNothing);
  });

  testWidgets('Welcome screen skip button marks user as visited', (
    WidgetTester tester,
  ) async {
    // Build our app with first time user
    await tester.pumpWidget(const MyApp(isFirstTime: true));

    // Wait for splash to navigate to welcome screen
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Find and tap the skip button
    final skipButton = find.text('Skip');
    expect(skipButton, findsOneWidget);

    await tester.tap(skipButton);
    await tester.pumpAndSettle();

    // Verify navigation happened
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
