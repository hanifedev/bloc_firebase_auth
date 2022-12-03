import 'package:bloc_firebase_auth/utils/bezier_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firebase_auth/blocs/register/register_bloc.dart';
import 'package:bloc_firebase_auth/blocs/register/register_event.dart';
import 'package:bloc_firebase_auth/utils/custom_colors.dart';
import 'package:bloc_firebase_auth/utils/validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _obscured = true;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isUsernameValid = false;

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
        ],
      ),
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
          "Kayıt Olun",
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
              child: const Text("Kayıt Olun"),
              onPressed: () {
                if (isPasswordValid && isEmailValid) {
                  BlocProvider.of<RegisterBloc>(context).add(RegisterSubmitted(
                      _emailController.text, _passwordController.text));
                } else if (!isPasswordValid && isEmailValid) {
                  var snackBar = const SnackBar(
                      backgroundColor: CustomColors.purple,
                      content: Text(
                          "Parolanız en az 6 karakter, bir büyük harf ve rakam içermelidir!"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (!isEmailValid && isPasswordValid) {
                  var snackBar = const SnackBar(
                      backgroundColor: CustomColors.purple,
                      content:
                          Text("Lütfen geçerli bir email adresi giriniz."));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  var snackBar = const SnackBar(
                      backgroundColor: CustomColors.purple,
                      content:
                          Text("Gerekli alanları doğru şekilde doldurunuz."));
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
          return !isPasswordValid
              ? "Parolanız büyük harf, rakam ve karakter içermelidir"
              : null;
        },
      ),
    );
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

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}
