import 'package:bloc_firebase_auth/app_bloc_observer.dart';
import 'package:bloc_firebase_auth/blocs/repository/authentication_repository.dart';
import 'package:bloc_firebase_auth/screens/home_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firebase_auth/blocs/login/login_bloc.dart';
import 'package:bloc_firebase_auth/blocs/register/register_bloc.dart';
import 'package:bloc_firebase_auth/screens/login_page.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const MyApp({Key? key, required this.authenticationRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RegisterBloc>(
              create: (context) => RegisterBloc(authenticationRepository)),
          BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(authenticationRepository)),
        ],
        child: MaterialApp(
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            home: FirebaseAuth.instance.currentUser != null
                ? const HomePage()
                : const LoginPage()));
  }
}
