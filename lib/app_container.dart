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
    FirebaseMessaging.onMessage.listen((message) {
      _notificationHandle(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _notificationHandle(message);
    });
  }

  ///Handle When Press Notification
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
          if (authentication == AuthenticationState.success) {
            return Scaffold(
              body: Container(
                child: Center(child: Text("Your App Widgets Here")),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  //
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            );
          }
          if (authentication == AuthenticationState.loading) {
            return const SplashScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
