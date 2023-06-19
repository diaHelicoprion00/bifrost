import 'package:authentication/authentication.dart';
import 'package:bifrost/login/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template LoginPage}
/// This is the login page of [Bifrost].
/// {@endtemplate}
class LoginPage extends StatelessWidget {
  ///{@macro LoginPage}
  const LoginPage({super.key});

  /// Returns a [Page] object of [LoginPage].
  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<Authentication>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
