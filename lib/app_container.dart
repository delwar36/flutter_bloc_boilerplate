import 'package:bloc_boilerplate/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';
import 'package:bloc_boilerplate/models/model.dart';
import 'package:bloc_boilerplate/ui/ui.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  _AppContainerState createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessage.listen((message) {
    //   _notificationHandle(message);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   _notificationHandle(message);
    // });
  }

  ///Handle When Press Notification
  // ignore: unused_element
  void _notificationHandle(RemoteMessage message) {
    final notification = NotificationModel.fromRemoteMessage(message);
    switch (notification.action) {
      case NotificationAction.created:
        Navigator.pushNamed(
          context,
          Routes.productDetail,
          arguments: notification.id,
        );
        return;

      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, authentication) async {
        //
      },
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, authentication) {
          UtilLogger.log(authentication.toString());
          if (authentication == AuthenticationState.success) {
            return const HomeScreen();
          }
          if (authentication == AuthenticationState.loading) {
            return const SplashScreen();
          }
          if (authentication == AuthenticationState.locked) {
            return const LoginScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
