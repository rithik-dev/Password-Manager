class LoginException implements Exception {
  String message;

  LoginException(this.message);
}

class RegisterException implements Exception {
  String message;

  RegisterException(this.message);
}

class ForgotPasswordException implements Exception {
  String message;

  ForgotPasswordException(this.message);
}

class ChangePasswordException implements Exception {
  String message;

  ChangePasswordException(this.message);
}

class AppDataReceiveException implements Exception {
  String message;

  AppDataReceiveException(this.message);
}

class DeleteUserException implements Exception {
  String message;

  DeleteUserException(this.message);
}