import 'package:local_auth/local_auth.dart';

class AuthService {

  final LocalAuthentication localAuth = LocalAuthentication();

  Future<bool> authenticateLocally() async {
    bool isAuthenticate = false;

    try{
      isAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to Use this application',
        // biometricOnly: true,
      );
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noBiometricHardware) {

      } else if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
      } else {

      }
    }catch(e){
      isAuthenticate =false;
      print( e.toString());
    }
    return isAuthenticate;
  }
}