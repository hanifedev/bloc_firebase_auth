import 'package:bloc_firebase_auth/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firebase_auth/blocs/login/login_bloc.dart';
import 'package:bloc_firebase_auth/blocs/login/login_state.dart';
import 'package:bloc_firebase_auth/screens/login_form.dart';
import 'package:bloc_firebase_auth/utils/custom_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomePage(),
              ),
            );
          } else if (state is LoginFailure) {
            var snackBar = const SnackBar(
                backgroundColor: CustomColors.purple,
                content: Text("Kullanıcı adı veya şifre yanlış!"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is LoginLoading) {
            const Center(
                child: CircularProgressIndicator(color: CustomColors.purple));
          }
        },
        child: const LoginForm());
  }
}
