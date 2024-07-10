import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_ta_1/page/signup_page.dart';
 // Sesuaikan dengan path Anda

void main() {
  testWidgets('SignupPage UI Test', (WidgetTester tester) async {
    // Build a MaterialApp with SignupPage inside it
    await tester.pumpWidget(MaterialApp(home: SignupPage()));

    // Find widgets
    expect(find.text('Register\nTo Your Account'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Testing form validation
    await tester.enterText(find.byKey(ValueKey('nameField')), 'John Doe');
    await tester.enterText(find.byKey(ValueKey('phoneField')), '1234567890');
    await tester.enterText(find.byKey(ValueKey('emailField')), 'john.doe@example.com');
    await tester.enterText(find.byKey(ValueKey('passwordField')), 'password');

    // Dismiss keyboard
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Tap register button
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Expect to find success message after registration
    expect(find.text('Registration Successful'), findsOneWidget);
  });
}
