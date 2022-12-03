abstract class LoginEvent {}

class LoginEmailChange extends LoginEvent {
  final String email;
  LoginEmailChange(this.email);
}

class LoginPasswordChange extends LoginEvent {
  final String password;
  LoginPasswordChange(this.password);
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;
  LoginWithCredentialsPressed(this.email, this.password);
}

class LoginWithGooglePressed extends LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}
