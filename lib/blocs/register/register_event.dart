abstract class RegisterEvent {}

class RegisterEmailChange extends RegisterEvent {
  final String email;
  RegisterEmailChange(this.email);
}

class RegisterPasswordChange extends RegisterEvent {
  final String password;
  RegisterPasswordChange(this.password);
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  RegisterSubmitted(this.email, this.password);
}
