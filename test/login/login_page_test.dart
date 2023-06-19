import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bifrost/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements Authentication {}


void main() {
  /// A test to ensure that LoginPage works as intended
  group('LoginPage', (){

    /// test that LoginPage exposes a method that returns a page of type
    /// MaterialPage.
    test('has a page', ()
    {
      expect(LoginPage.page(), isA<MaterialPage<void>>());
    });

    /// test that LoginPage renders a LoginForm
    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<Authentication>(
          create: (_) => MockAuthenticationRepository(),
          child: const MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });


}