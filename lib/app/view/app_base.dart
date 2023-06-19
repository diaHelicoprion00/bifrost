import 'package:bifrost/app/app.dart';
import 'package:bifrost/theme.dart';
import 'package:authentication/authentication.dart';

import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template App}
/// A stateless widget that passes the Authentication Bloc
/// and Authentication Repository to its children.
/// {@endtemplate}
class App extends StatelessWidget{
  /// {@macro App}
  const App({
    required Authentication authentication,
    super.key,
}) : _authentication = authentication;

  final Authentication _authentication;
  
  @override
  Widget build(BuildContext context){
    return RepositoryProvider.value(
      value: _authentication,
      child: BlocProvider(
        create: (_) => AppBloc(authentication: _authentication),
        child: const AppView(),
      ),
    );
  }
}

/// {@template AppView}
/// A stateless widget that updates the App's route based on the AuthenticationState
/// obtained from the AppBloc.
/// {@endtemplate}
class AppView extends StatelessWidget{
  /// {@macro AppView}
  const AppView({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        /// update UI (routes) based on states
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViews,
      )
    );
  }
}














