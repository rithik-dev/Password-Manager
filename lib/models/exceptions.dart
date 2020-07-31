class LoginException implements Exception {
  String text;
  LoginException(this.text);
  String get message => this.text;
}

class RegisterException implements Exception {
  String text;
  RegisterException(this.text);
  String get message => this.text;
}

class ForgotPasswordException implements Exception {
  String text;
  ForgotPasswordException(this.text);
  String get message => this.text;
}

class ChangePasswordException implements Exception {
  String text;
  ChangePasswordException(this.text);
  String get message => this.text;
}