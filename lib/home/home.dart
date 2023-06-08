import 'package:flutter/material.dart';

///{@template HomePage}
/// This is the home page of Bifrost.
/// {@endtemplate}
class HomePage extends StatelessWidget{
  const HomePage({super.key});

  /// Returns a [Page] object of [HomePage].
  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context){
    return Container();
  }
}
