import 'package:authentication/authentication.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _mockFirebaseUserUid = 'mock-uid';
const _mockFirebaseUserEmail = 'mock-email';

class MockCache extends Mock implements Cache {}

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

class FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const email = 'mock@gmail.com';
  const password = 'mockSecret42';
  const user = User(id: _mockFirebaseUserUid, email: _mockFirebaseUserEmail);

  /// A suite of tests to ensure that [Authentication] works as intended
  group('Authentication', () {
    late Cache cache;
    late firebase_auth.FirebaseAuth firebaseAuth;
    late GoogleSignIn googleSignIn;
    late Authentication authentication;

    /// Set Up Fallback Values for all tests.
    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
      registerFallbackValue(FakeAuthProvider());
    });

    setUp(() {
      const options = FirebaseOptions(
          apiKey: 'apiKey',
          appId: 'appId',
          messagingSenderId: 'messagingSenderId',
          projectId: 'projectId');
      final platformApp = FirebaseAppPlatform(defaultFirebaseAppName, options);
      final firebaseCore = MockFirebaseCore();

      when(() => firebaseCore.apps).thenReturn([platformApp]);
      when(firebaseCore.app).thenReturn(platformApp);
      when(() => firebaseCore.initializeApp(
            name: defaultFirebaseAppName,
            options: options,
          )).thenAnswer((_) async => platformApp);

      Firebase.delegatePackingProperty = firebaseCore;

      cache = MockCache();
      firebaseAuth = MockFirebaseAuth();
      googleSignIn = MockGoogleSignIn();
      authentication = Authentication(
          cache: cache, firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
    });

    /// A test to check that a new authentication instance is successfully created
    test('creates FirebaseAuth instance internally when not injected', () {
      expect(Authentication.new, isNot(throwsException));
    });

    /// A suite of tests to ensure that the signUp feature works as intended with the Authentication class.
    group('signUp', () {
      setUp(() {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      /// A test to check that the createUserWithEmailAndPassword is called only once in Authentication.signUp
      test('calls createUserWithEmailAndPassword', () async {
        await authentication.signUp(email: email, password: password);
        verify(() => firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).called(1);
      });

      /// A test to ensure that createUserWithEmailAndPassword successfully completes
      test('succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
            authentication.signUp(email: email, password: password), completes);
      });

      /// A test to ensure that createUserWithEmailAndPassword throws
      /// a SignUpWithEmailAndPasswordFailure exception when it fails
      test(
          'throws SignUpWithEmailAndPasswordFailure'
          'when createdUserWithEmailAndPassword throws', () async {
        when(() => firebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception());
        expect(
          authentication.signUp(email: email, password: password),
          throwsA(isA<SignUpWithEmailAndPasswordFailure>()),
        );
      });
    });

    /// A suite of tests to ensure that the Google Login feature works as intended with the Authentication class.
    group('logInWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        when(() => googleSignInAuthentication.accessToken)
            .thenReturn(accessToken);
        when(() => googleSignInAuthentication.idToken).thenReturn(idToken);
        when(() => googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignIn.signIn())
            .thenAnswer((_) async => googleSignInAccount);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => firebaseAuth.signInWithPopup(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
      });

      /// A test to ensure that GoogleSignIn.signIn() and FirebaseAuth.signInWithCredential()
      /// are called only once in Authentication.logInWithGoogle()
      test('calls signIn authentication, and signInWithCredential', () async {
        await authentication.logInWithGoogle();
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      /// A test to ensure that when kIsWeb is true and a LogInWithGoogleFailure Exception is thrown,
      ///  GoogleSignIn.signIn() is never called and FirebaseAuth.signInWithPopup() is called only once
      test(
          'throws LogInWithGoogleFailure and calls signIn authentication, '
          'and signInWithPopup when authCredential is null and kIsWeb is true',
          () async {
        authentication.isWeb = true;
        await expectLater(() => authentication.logInWithGoogle(),
            throwsA(isA<LogInWithGoogleFailure>()));
        verifyNever(() => googleSignIn.signIn());
        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });

      /// A test to ensure that when kIsWeb, Authentication.logInWithGoogle() successfully completes,
      /// GoogleSignIn.signIn() is never called and FirebaseAuth.signInWithPopup() is called only once
      test(
          'successfully calls signIn authentication, and '
          'signInWithPopup when authCredential is not null and kIsWeb is true',
          () async {
        final credential = MockUserCredential();
        when(() => firebaseAuth.signInWithPopup(any()))
            .thenAnswer((_) async => credential);
        when(() => credential.credential).thenReturn(FakeAuthCredential());
        authentication.isWeb = true;
        await expectLater(
          authentication.logInWithGoogle(),
          completes,
        );
        verifyNever(() => googleSignIn.signIn());
        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });

      /// A test to ensure that when an error occurs, a LogInWithGoogleFailure Exception is thrown.
      test('throws LogInWithGoogleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(
          authentication.logInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
      });
    });

    /// A suite of tests to ensure that the LogInWithEmailAndPassword method works as intended.
    group('logInWithEmailAndPassword', () {
      setUp(() {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      /// A test to ensure that Authentication.logInWithEmailAndPassword is called,
      /// FirebaseAuth.signInWithEmailAndPassword() is called once.
      test('calls signInWithEmailAndPassword', () async {
        await authentication.logInWithEmailAndPassword(
          email: email,
          password: password,
        );
        verify(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      /// A test to ensure that Authentication.logInWithEmailAndPassword() completes.
      test('succeeds when signInWithEmailAndPassword succeeds', () async {
        expect(
          authentication.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          completes,
        );
      });

      /// A test to ensure that when an Exception is thrown in Authentication.logInWithEmailAndPassword(),
      /// a LogInWithEmailAndPasswordFailure Exception is thrown.
      test(
          'throws LogInWithEmailAndPasswordFailure '
          'when signInWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          authentication.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<LogInWithEmailAndPasswordFailure>()),
        );
      });
    });

    /// A suite of tests to ensure that the logOut feature works as intended in the Authentication class.
    group('logout', () {
      /// A test to ensure that when Authentication.logOut() is called,
      /// FirebaseAuth.signOut() is called once and GoogleSignIn.signOut() is called once.
      test('calls signOut', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
        await authentication.logOut();
        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });

      /// A test to ensure that when an error occurs in Authentication.logOut(),
      /// A LogOutFailure Exception is thrown.
      test('throws LogOutFailure when signOut throws', () async {
        when(() => firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          authentication.logOut(),
          throwsA(isA<LogOutFailure>()),
        );
      });
    });

    /// A suite of tests to ensure that the User Stream works as intended in Authentication class.
    group('user', () {
      /// A test to ensure that that the Authentication.user Stream emits User.empty
      /// when the FirebaseUser is null.
      test('emits User.empty when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));
        await expectLater(
          authentication.user,
          emitsInOrder(const <User>[User.empty]),
        );
      });

      /// A test to ensure that the Authentication.user Stream emits the
      /// new state of the FirebaseUser when the user is not null and
      /// Cache.write() is called only once in the execution.
      test('emits User when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        when(() => firebaseUser.uid).thenReturn(_mockFirebaseUserUid);
        when(() => firebaseUser.email).thenReturn(_mockFirebaseUserEmail);
        when(() => firebaseUser.photoURL).thenReturn(null);
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(firebaseUser));
        await expectLater(
          authentication.user,
          emitsInOrder(const <User>[user]),
        );
        verify(
          () => cache.write(
            key: Authentication.userCacheKey,
            value: user,
          ),
        ).called(1);
      });
    });

    /// A suite of tests to ensure that the currentUser getter works as intended in the Authentication class.
    group('currentUser', () {
      /// A test to ensure that Authentication.currentUser returns User.empty if the user isn't in the cache
      test('returns User.empty when cached user is null', () {
        when(
          () => cache.read(key: Authentication.userCacheKey),
        ).thenReturn(null);
        expect(
          authentication.currentUser,
          equals(User.empty),
        );
      });

      /// A test to ensure that Authentication.currentUser returns User if the user is stored in the cache.
      test('returns User when cached user is not null', () async {
        when(
          () => cache.read<User>(key: Authentication.userCacheKey),
        ).thenReturn(user);
        expect(authentication.currentUser, equals(user));
      });
    });
  });
}
