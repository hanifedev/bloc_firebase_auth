import 'package:bloc_firebase_auth/blocs/register/register_event.dart';
import 'package:bloc_firebase_auth/blocs/repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firebase_auth/blocs/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterBloc(this._authenticationRepository) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        await _authenticationRepository.signUp(event.email, event.password);
        emit(RegisterSuccess());
      } catch (_) {
        emit(RegisterFailure());
      }
    });
  }
}
