import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';
import 'package:bloc_boilerplate/utils/utils.dart';
import 'package:bloc_boilerplate/ui/widgets/theme_toggle_button.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() {
    return _IntroState();
  }
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On complete preview intro
  void _onCompleted() {
    AppBloc.applicationCubit.onCompletedIntro();
  }

  @override
  Widget build(BuildContext context) {
    ///List Intro view page model
    final List<PageViewModel> pages = [
      PageViewModel(
        pageColor: const Color(0xff93b7b0),
        bubble: const Icon(Icons.shop, color: Colors.white),
        body: Text(
          "Favorite brands and hottest trends.",
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
        title: Text(
          Translate.of(context).translate('shopping'),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        mainImage: Image.asset(Images.intro1, fit: BoxFit.contain),
      ),
      PageViewModel(
        pageColor: const Color(0xff93b7b0),
        bubble: const Icon(Icons.phonelink, color: Colors.white),
        body: Text(
          Translate.of(context).translate('shopping_intro'),
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
        title: Text(
          Translate.of(context).translate('payment'),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        mainImage: Image.asset(Images.intro2, fit: BoxFit.contain),
      ),
      PageViewModel(
        pageColor: const Color(0xff93b7b0),
        bubble: const Icon(Icons.home, color: Colors.white),
        body: Text(
          Translate.of(context).translate('payment_intro'),
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
        title: Text(
          Translate.of(context).translate('location'),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        mainImage: Image.asset(Images.intro3, fit: BoxFit.contain),
      ),
    ];

    ///Build Page
    return Scaffold(
      body: Stack(
        children: [
          IntroViewsFlutter(
            pages,
            onTapSkipButton: _onCompleted,
            onTapDoneButton: _onCompleted,
            doneText: Text(Translate.of(context).translate('done')),
            nextText: Text(Translate.of(context).translate('next')),
            skipText: Text(Translate.of(context).translate('skip')),
            backText: Text(Translate.of(context).translate('back')),
            pageButtonTextStyles: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ThemeToggleButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
