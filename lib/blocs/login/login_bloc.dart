import 'dart:io';

import 'package:bloc_firebase_auth/blocs/repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final AuthenticationRepository _authenticationRepository;

  LoginBloc(this._authenticationRepository) : super(LoginInitial()) {
    on<LoginWithCredentialsPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        UserCredential userCredential = await _authenticationRepository
            .signInWithCredentials(event.email, event.password);
        if (userCredential.user != null) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure());
        }
      } catch (e) {
        emit(LoginFailure());
      }
    });

    on<LoginWithGooglePressed>((event, emit) async {
      emit(LoginLoading());
      try {
        UserCredential userCredential =
            await _authenticationRepository.signInWithGoogle();
        if (userCredential.user != null) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure());
        }
      } catch (e) {
        emit(LoginFailure());
      }
    });
  }
}
