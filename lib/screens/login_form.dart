import 'package:bloc_firebase_auth/utils/bezier_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firebase_auth/blocs/login/login_bloc.dart';
import 'package:bloc_firebase_auth/blocs/login/login_event.dart';
import 'package:bloc_firebase_auth/screens/register_page.dart';
import 'package:bloc_firebase_auth/utils/custom_colors.dart';
import 'package:bloc_firebase_auth/utils/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _obscured = true;
  bool isEmailValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(seconds: 25),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    isEmailValid = Validators.isValidEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    isPasswordValid = Validators.isValidPassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: buildForm(size)));
  }

  Form buildForm(Size size) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            buildStack(size),
            const SizedBox(height: 16),
            buildEmailTextField(),
            buildPasswordTextField(),
            buildButton(),
            buildGoogleButton(),
            SizedBox(height: size.height * 0.02),
            buildSignUpRow(),
          ],
        ));
  }

  Container buildGoogleButton() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.8,
      height: 40,
      child: ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.grey),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(29))),
          primary: Colors.white,
        ),
        label: const Text("Google ile Giriş",
            style: TextStyle(color: Colors.grey)),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
            LoginWithGooglePressed(),
          );
        },
      ),
    );
  }

  Row buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabınız yok mu?",
          style: TextStyle(color: CustomColors.purple),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const RegisterPage(),
              ),
            );
          },
          child: const Text(
            "Kayıt olun",
            style: TextStyle(
              color: CustomColors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Stack buildStack(Size size) {
    final height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            top: -height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: const BezierContainer()),
        const Text(
          "Giriş Yap",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Container buildButton() {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.8,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              child: const Text("Giriş Yap"),
              onPressed: () {
                if (isPasswordValid && isEmailValid) {
                  BlocProvider.of<LoginBloc>(context).add(
                      LoginWithCredentialsPressed(
                          _emailController.text, _passwordController.text));
                } else {
                  var snackBar = const SnackBar(
                      backgroundColor: CustomColors.purple,
                      content:
                          Text("Lütfen geçerli bir email ve parola giriniz"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            )));
  }

  Container buildPasswordTextField() {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: CustomColors.lightWhitePurple,
          borderRadius: BorderRadius.circular(29),
        ),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          obscureText: _obscured,
          controller: _passwordController,
          cursorColor: CustomColors.darkPurple,
          decoration: InputDecoration(
            icon: const Icon(
              Icons.lock,
              color: CustomColors.purple,
            ),
            suffixIcon: GestureDetector(
              onTap: () => {_toggleObscured()},
              child: const Icon(
                Icons.visibility,
                color: CustomColors.purple,
              ),
            ),
            hintText: "Parola",
            border: InputBorder.none,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          validator: (_) {
            return !isPasswordValid ? "Geçersiz Parola" : null;
          },
        ));
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  Container buildEmailTextField() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: CustomColors.lightWhitePurple,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        cursorColor: CustomColors.darkPurple,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.email,
            color: CustomColors.purple,
          ),
          hintText: "Email",
          border: InputBorder.none,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: false,
        validator: (_) {
          return !isEmailValid ? "Geçersiz Email" : null;
        },
      ),
    );
  }
}
