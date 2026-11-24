import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_food/app.dart';

void main() {
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> loginPage(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TastyFoodApp());
    await tester.pumpAndSettle();
    final login = find.text('Login').first;
    await tester.ensureVisible(login);
    await tap(tester, login);
  }

  testWidgets('basket quantities feed through to a completed demo order', (
    tester,
  ) async {
    await loginPage(tester, const Size(375, 812));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Dylan Flores');
    await tester.enterText(fields.at(1), 'demo1234');
    final submitLogin = find.text('LOGIN');
    await tester.ensureVisible(submitLogin);
    await tap(tester, submitLogin);
    expect(
      find.text('Welcome to Tasty Food'),
      findsOneWidget,
      reason: tester
          .widgetList<Text>(find.byType(Text))
          .map((widget) => widget.data)
          .toList()
          .toString(),
    );

    await tap(tester, find.byTooltip('Search'));
    await tester.enterText(find.byType(TextField), 'chicken fried rice');
    await tester.pumpAndSettle();
    await tap(tester, find.text('Chicken Fried Rice'));
    await tap(tester, find.text('Buy Now \$10'));

    await tap(tester, find.byTooltip('More Chicken Fried Rice'));
    expect(find.text('\$30'), findsOneWidget);
    await tap(tester, find.text('CHECKOUT'));
    expect(find.text('Shipping address'), findsOneWidget);
    expect(find.text('\$30'), findsOneWidget);
    await tap(tester, find.text('SUBMIT ORDER'));

    expect(find.text('Successfully!'), findsOneWidget);
    await tap(tester, find.text('BACK TO HOME'));
    await tap(tester, find.byTooltip('Basket'));
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('password reset validates the demo code and returns to login', (
    tester,
  ) async {
    await loginPage(tester, const Size(320, 640));
    await tap(tester, find.text('Forgot password?'));
    await tester.enterText(find.byType(TextFormField), 'dylan@example.com');
    await tap(tester, find.text('SEND'));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '123456');
    await tester.enterText(fields.at(1), 'demo1234');
    await tester.enterText(fields.at(2), 'demo1234');
    final submit = find.text('CHANGE PASSWORD');
    await tester.ensureVisible(submit);
    await tap(tester, submit);
    expect(find.text('Enter the demo reset code'), findsOneWidget);

    await tester.enterText(fields.at(0), '236545');
    await tester.ensureVisible(submit);
    await tap(tester, submit);
    await tester.ensureVisible(find.text('BACK TO LOGIN'));
    await tap(tester, find.text('BACK TO LOGIN'));
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
