import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class AppBloc {
  static final applicationCubit = ApplicationCubit();
  static final userCubit = UserCubit();
  static final authenticateCubit = AuthenticationCubit();
  static final languageCubit = LanguageCubit();
  static final themeCubit = ThemeCubit();
  static final messageBloc = MessageBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationCubit>(create: (context) => applicationCubit),
    BlocProvider<UserCubit>(create: (context) => userCubit),
    BlocProvider<LanguageCubit>(create: (context) => languageCubit),
    BlocProvider<ThemeCubit>(create: (context) => themeCubit),
    BlocProvider<AuthenticationCubit>(create: (context) => authenticateCubit),
    BlocProvider<MessageBloc>(create: (context) => messageBloc),
  ];

  static void dispose() {
    applicationCubit.close();
    userCubit.close();
    languageCubit.close();
    themeCubit.close();
    authenticateCubit.close();
    messageBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
