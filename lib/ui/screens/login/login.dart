import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/configs/config.dart';
import 'package:bloc_boilerplate/utils/utils.dart';
import 'package:bloc_boilerplate/ui/widgets/app_button.dart';
import 'package:bloc_boilerplate/ui/widgets/app_text_input.dart';
import 'package:bloc_boilerplate/ui/widgets/theme_toggle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _canBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  void _checkBiometric() async {
    final account = await UtilSecureStorage.read(SecureStorage.account);
    if (account != null) {
      setState(() {
        _canBiometric = true;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onLogin() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    AppBloc.loginCubit.onLogin(username: username, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state == LoginState.success) {
          // Success is handled by AppContainer switching based on AuthenticationState
        }
        if (state == LoginState.fail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Translate.of(
                  context,
                ).translate("[jwt_auth] incorrect_password"),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: ThemeToggleButton(),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wallet,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      Translate.of(context).translate("sign_in"),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Access your account securely",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  AppTextInput(
                    labelText: Translate.of(context).translate("email"),
                    hintText: Translate.of(context).translate("input_id"),
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (v) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                  ),
                  const SizedBox(height: 24),
                  AppTextInput(
                    labelText: Translate.of(context).translate("password"),
                    hintText: Translate.of(
                      context,
                    ).translate("input_your_password"),
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    onSubmitted: (v) => _onLogin(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        Translate.of(context).translate("forgot_password"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return AppButton(
                        Translate.of(context).translate("sign_in"),
                        onPressed: _onLogin,
                        loading: state == LoginState.loading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          Translate.of(context).translate("sign_up"),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Quick Login",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_canBiometric)
                    Center(
                      child: IconButton(
                        iconSize: 54,
                        icon: Icon(
                          Icons.fingerprint,
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.8),
                        ),
                        onPressed: () {
                          AppBloc.loginCubit.onBiometricLogin();
                        },
                      ),
                    ),
                  if (!_canBiometric)
                    Center(
                      child: Text(
                        "Login once to enable biometric",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
