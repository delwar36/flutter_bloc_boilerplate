import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';
import 'package:bloc_boilerplate/repository/repository.dart';
import 'package:bloc_boilerplate/utils/utils.dart';

enum LoginState { init, loading, success, fail }

class LoginCubit extends Cubit<LoginState> {
  final LocalAuthentication _auth = LocalAuthentication();
  LoginCubit() : super(LoginState.init);

  Future<void> onLogin({
    required String username,
    required String password,
  }) async {
    ///Notify
    emit(LoginState.loading);

    ///Login api
    final user = await UserRepository.login(
      username: username,
      password: password,
    );

    if (user != null) {
      ///Login success
      await AppBloc.authenticateCubit.onSave(user);

      ///Store Secure for Biometric next time
      await UtilSecureStorage.write(SecureStorage.account, username);
      await UtilSecureStorage.write(SecureStorage.password, password);

      ///Notify
      emit(LoginState.success);
    } else {
      ///Notify
      emit(LoginState.fail);
    }
  }

  Future<void> onBiometricLogin() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        AppBloc.messageBloc.add(OnMessage(message: "Biometric not supported"));
        return;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to login securely',
      );

      if (authenticated) {
        emit(LoginState.loading);
        final username = await UtilSecureStorage.read(SecureStorage.account);
        final password = await UtilSecureStorage.read(SecureStorage.password);

        if (username != null && password != null) {
          final user = await UserRepository.login(
            username: username,
            password: password,
          );

          if (user != null) {
            await AppBloc.authenticateCubit.onSave(user);
            emit(LoginState.success);
          } else {
            emit(LoginState.fail);
          }
        } else {
          AppBloc.messageBloc.add(
            OnMessage(message: "No credentials found. Login manually first."),
          );
          emit(LoginState.fail);
        }
      }
    } catch (e) {
      UtilLogger.log("BIOMETRIC ERROR", e);
      emit(LoginState.fail);
    }
  }
}
