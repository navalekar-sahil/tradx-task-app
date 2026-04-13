import 'dart:async';

class LoginService {

  final String _validUsername = "test";
  final String _validPassword = "test@123";

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (username == _validUsername && password == _validPassword) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authenticateLocally() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}