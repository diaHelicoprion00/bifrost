import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bifrost/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthentication extends Mock
    implements Authentication {}

void main() {

  /// A group of tests to ensure that the SignUpPage works as intended
  group('SignUpPage', (){

    /// test that the SignUpPage exposes a method that returns an object of
    /// type MaterialPageRoute
    test('has a route', () {
      expect(SignUpPage.route(), isA<MaterialPageRoute<void>>());
    });

    /// test that the SignUpPage renders a SignUpForm widget
    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<Authentication>(
          create: (_) => MockAuthentication(),
          child: const MaterialApp(home: SignUpPage()),
        ),
      );
      expect(find.byType(SignUpForm), findsOneWidget);
    });
  });
}