import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark =
            state.darkOption == DarkOption.alwaysOn ||
            (state.darkOption == DarkOption.dynamic &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return IconButton(
          onPressed: () {
            final newOption = isDark
                ? DarkOption.alwaysOff
                : DarkOption.alwaysOn;
            AppBloc.themeCubit.onChangeTheme(darkOption: newOption);
          },
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        );
      },
    );
  }
}
