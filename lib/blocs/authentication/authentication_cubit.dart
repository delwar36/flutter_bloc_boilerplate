import 'package:bloc_boilerplate/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';
import 'package:bloc_boilerplate/models/model.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LocalAuthentication _auth = LocalAuthentication();
  AuthenticationCubit() : super(AuthenticationState.loading);

  Future<void> onCheck() async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event load user
    final savedUser = await AppBloc.userCubit.onLoadUser();

    if (savedUser != null) {
      ///Attach token push
      // await Application.setDeviceToken();

      ///Save user
      await AppBloc.userCubit.onSaveUser(savedUser);
      emit(AuthenticationState.locked);

      ///Valid token server
      // final result = await UserRepository.validateToken();

      // if (result) {
      //   ///Fetch user
      //   await AppBloc.userCubit.onFetchUser();

      //   ///Notify
      //   emit(AuthenticationState.locked);
      // } else {
      //   ///Logout
      //   onClear();
      // }
    } else {
      ///Notify
      emit(AuthenticationState.fail);
    }
  }

  Future<void> onLogin({
    required String username,
    required String password,
  }) async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Login api
    final user = await UserRepository.login(
      username: username,
      password: password,
    );

    if (user != null) {
      ///Login success
      await onSave(user);
    } else {
      ///Notify
      emit(AuthenticationState.fail);
    }
  }

  Future<void> onLoginDemo() async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Login demo
    final user = await UserRepository.loginDemo();

    if (user != null) {
      ///Login success
      await onSave(user);
    } else {
      ///Notify
      emit(AuthenticationState.fail);
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
        emit(AuthenticationState.loading);
        final savedUser = await UserRepository.loadUser();
        print("SAVED USER: ${savedUser?.toJson()}");
        final username = savedUser?.email;
        final password = savedUser?.password;

        if (username != null && password != null) {
          print("USERNAME: $username");
          if (username == Application.demoUser.email &&
              password == Application.demoUser.password) {
            await onLoginDemo();
          } else {
            final user = await UserRepository.login(
              username: username,
              password: password,
            );

            if (user != null) {
              await onSave(user);
            } else {
              emit(AuthenticationState.fail);
            }
          }
        } else {
          AppBloc.messageBloc.add(
            OnMessage(message: "No credentials found. Login manually first."),
          );
          emit(AuthenticationState.fail);
        }
      }
    } catch (e) {
      if (e is LocalAuthException) {
        if (e.code == LocalAuthExceptionCode.userCanceled) {
          AppBloc.messageBloc.add(
            OnMessage(message: "Biometric authentication cancelled"),
          );
        } else {
          AppBloc.messageBloc.add(
            OnMessage(message: "Biometric authentication failed"),
          );
        }
      } else {
        AppBloc.messageBloc.add(
          OnMessage(message: "Biometric authentication failed"),
        );
      }
      emit(AuthenticationState.locked);
    }
  }

  Future<void> onSave(UserModel user) async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event Save user
    await AppBloc.userCubit.onSaveUser(user);

    /// Notify
    emit(AuthenticationState.success);
  }

  void onLock() {
    emit(AuthenticationState.locked);
  }

  void onLogout() {
    /// Notify
    emit(AuthenticationState.fail);

    ///Delete user
    AppBloc.userCubit.onDeleteUser();
  }

  void onClear() {
    onLogout();
  }
}
