import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bifrost/app/app.dart';
import 'package:bifrost/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  const logoutButtonKey = Key('homePage_logout_iconButton');
  group('HomePage', () {
    late AppBloc appBloc;
    late User user;

    setUp(() {
      appBloc = MockAppBloc();
      user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    group('calls', () {
      testWidgets('AppLogoutRequested when logout is pressed', (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        await tester.tap(find.byKey(logoutButtonKey));
        verify(() => appBloc.add(const AppLogoutRequested())).called(1);
      });
    });

    group('renders', () {
      testWidgets('avatar widget', (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        expect(find.byType(Avatar), findsOneWidget);
      });
    });
  });
}
