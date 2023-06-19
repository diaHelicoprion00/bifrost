import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bifrost/sign_up/sign_up.dart';
import 'package:authentication/authentication.dart';

///{@template SignUpPage}
///This is the SignUp Page for [Bifrost].
///{@endtemplate}
class SignUpPage extends StatelessWidget{
  ///{@macro SignUpPage}
  const SignUpPage({super.key});

  /// Returns a [Route] object to [SignUpPage].
  static Route<void> route(){
    return MaterialPageRoute(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<Authentication>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}