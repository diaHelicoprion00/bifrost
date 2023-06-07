import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bifrost/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthentication extends Mock implements Authentication {}

class MockUser extends Mock implements User {}

void main() {
  /// A suite of tests to ensure that the Authentication Bloc works as intended
  group('Authentication Bloc', () {
    final user = MockUser();
    late Authentication authentication;

    setUp(() {
      authentication = MockAuthentication();
      when(() => authentication.user).thenAnswer((_) => const Stream.empty());
      when(() => authentication.currentUser).thenReturn(User.empty);
    });

    /// A test to ensure that the state emitted from the Bloc when the User is empty is AppState.unauthenticated
    test('initial state is unauthenticated when user is empty', () {
      expect(
          AppBloc(authentication: authentication).state,
          const AppState.unauthenticated()
      );
    });

    /// A suite of tests to ensure that the Authentication Bloc reacts as expected to a userChanged event.
    group('UserChanged', () {
      /// A test to ensure that the state emitted from the Bloc is AppState.authenticated when the User is not empty
      blocTest<AppBloc, AppState>(
          'state is authenticated when user is not empty',
          setUp: () {
            when(() => user.isEmpty).thenReturn(false);
            when(() => authentication.user).thenAnswer((_) =>
                Stream.value(user));
          },
          build: () =>
              AppBloc(
                  authentication: authentication
              ),
          seed: AppState.unauthenticated,
          expect: () => [AppState.authenticated(user)]
      );

      /// A test to ensure that the state emitted from the Bloc is AppState.unauthenticated when the User is empty
      blocTest<AppBloc, AppState>('state is unauthenticated when user is empty',
          setUp: () {
            when(() => user.isEmpty).thenReturn(true);
            when(() => authentication.user).thenAnswer((_) =>
            Stream.value(User.empty));
          },
        build: () =>
            AppBloc(
              authentication: authentication
            ),
        expect: () => [const AppState.unauthenticated()]
      );
    });

    /// A suite of tests to ensure that the Bloc reacts as expected to a LogoutRequested event
    group('LogoutRequested', (){
      /// A test to ensure that the Authentication bloc calls Authentication.logOut() once, when an
      /// AppLogoutRequested() event is added to the bloc
      blocTest<AppBloc, AppState>(
      'invokes logOut'
      ,setUp: (){
        when(() => authentication.logOut()).thenAnswer((_) async {});
        },
        build: () => AppBloc(
          authentication: authentication
        ),
        act: (bloc) => bloc.add(const AppLogoutRequested()),
        verify: (_) {
          verify(() => authentication.logOut()).called(1);
        }
      );
    });
  });
}