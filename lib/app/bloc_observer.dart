import 'package:bloc/bloc.dart';

/// {@template AppBlocObserver}
/// A BlocObserver to observe state changes in the App Class.
/// {@endtemplate}
class AppBlocObserver extends BlocObserver{
  /// {@macro AppBlocObserver}
  const AppBlocObserver();

  /// Called whenever an [event] is added to the [bloc].
  /// Takes a [bloc] and the associated [event] as input.
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event){
    super.onEvent(bloc, event);
    // print(event);
  }

  /// Called whenever an [error] occurs in the [bloc]
  /// [stackTrace] may be [StackTrace.empty]
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace){
    // print(error);
    super.onError(bloc, error, stackTrace);
  }

  /// Called whenever a [change] occurs in a [bloc]
  /// A [change] occurs when a new state is emitted.
  /// [onChange] is called before the new state is updated.
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change){
    super.onChange(bloc, change);
    // print(charge);
  }

  /// Called whenever a [transition] occurs in a [bloc]
  /// A [transition] occurs when a new event has been added to the [bloc]
  /// and a new state is emitted.
  /// [onTransition] is called before the new state is updated.
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition){
    super.onTransition(bloc, transition);
    // print(transition);
  }
}