import 'package:bifrost/app/app.dart';
import 'package:bifrost/home/home.dart';
import 'package:bifrost/login/login.dart';

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:authentication/authentication.dart';

class MockUser extends Mock implements User {}

class MockAuthentication extends Mock implements Authentication{}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  /// A suite of tests to ensure that App works as intended.
  group('App', (){
    late Authentication authentication;
    late User user;

    setUp((){
      authentication = MockAuthentication();
      user = MockUser();
      when(() => authentication.user).thenAnswer(
            (_) => const Stream.empty(),
      );
      when(() => authentication.currentUser).thenReturn(user);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn('testEmail@gmail.com');
    });
    
    /// A test to ensure that only one AppView Widget is rendered by the App on startup
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(authentication: authentication)
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });
  
  /// A suite of tests to ensure that AppView works as intended.
  group('AppView', (){
    late Authentication authentication;
    late AppBloc appBloc;

    setUp((){
      authentication = MockAuthentication();
      appBloc = MockAppBloc();
    });

    /// A test to ensure that the AppView returns only one LoginPage when it receives an
    /// unauthenticated state from the Bloc
    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authentication,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    /// A test to ensure that the AppView returns only one HomePage when it receives an
    /// authenticated state from the Bloc.
    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('testEmail@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authentication,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView(),),
          ),
        )
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}