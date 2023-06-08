import 'package:flutter/material.dart';

/// {@template LoginPage}
/// This is the login page of Bifrost.
/// {@endtemplate}
class LoginPage extends StatelessWidget {
  ///{@macro LoginPage}
  const LoginPage({super.key});

  /// Returns a [Page] object of [LoginPage].
  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
