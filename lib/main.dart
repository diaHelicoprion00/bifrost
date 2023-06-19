import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:bifrost/app/app.dart';

Future<void> main() async {
  /// Ensures that the widgets are bound to the Flutter Engine.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes Bloc.Observer() to receive state changes.
  Bloc.observer = const AppBlocObserver();

  /// Initializes Firebase instance.
  await Firebase.initializeApp();

  /// Initialize Authentication repository and start user stream.
  final authentication = Authentication();
  await authentication.user.first;

  /// Run it
  runApp(App(authentication: authentication,));
}