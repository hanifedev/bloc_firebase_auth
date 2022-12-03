import 'package:bloc_firebase_auth/blocs/register/register_bloc.dart';
import 'package:bloc_firebase_auth/blocs/register/register_state.dart';
import 'package:bloc_firebase_auth/screens/login_page.dart';
import 'package:bloc_firebase_auth/screens/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firebase_auth/utils/custom_colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            var snackBar = const SnackBar(
                backgroundColor: CustomColors.purple,
                content: Text("Kayıt Başarılı"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage(),
              ),
            );
          } else if (state is RegisterFailure) {
            var snackBar = const SnackBar(
                backgroundColor: CustomColors.darkPurple,
                content: Text("Hata!"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const RegisterForm());
  }
}
