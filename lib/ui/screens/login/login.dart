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
  bool _canBiometric = true;
  bool _showManualLogin = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  void _checkBiometric() async {
    final user = await UtilSecureStorage.read(SecureStorage.user);
    if (user != null) {
      if (!mounted) return;
      setState(() {
        _canBiometric = true;
      });
    }
  }

  void _onFillDemo() {
    _usernameController.text = Application.demoUser.email;
    _passwordController.text = Application.demoUser.password ?? 'demo123';
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
    if (username == Application.demoUser.email) {
      AppBloc.authenticateCubit.onLoginDemo();
    } else {
      AppBloc.authenticateCubit.onLogin(username: username, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked =
        AppBloc.authenticateCubit.state == AuthenticationState.locked;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state == AuthenticationState.fail) {
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
                      // child: Icon(
                      //   Icons.wallet,
                      //   size: 40,
                      //   color: Theme.of(context).primaryColor,
                      // ),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      isLocked
                          ? "Unlock App"
                          : Translate.of(context).translate("sign_in"),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      isLocked
                          ? "Verify biometrics to continue"
                          : "Access your account securely",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  if (isLocked && !_showManualLogin) ...[
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          IconButton(
                            iconSize: 84,
                            icon: Icon(
                              Icons.fingerprint,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              AppBloc.authenticateCubit.onBiometricLogin();
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tap to unlock",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showManualLogin = true;
                          });
                        },
                        child: Text(
                          "Login with credentials",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Translate.of(context).translate("email"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6),
                          ),
                        ),
                        if (!isLocked)
                          TextButton(
                            onPressed: _onFillDemo,
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Demo?",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppTextInput(
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
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
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
                    BlocBuilder<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        return AppButton(
                          Translate.of(context).translate("sign_in"),
                          onPressed: _onLogin,
                          loading: state == AuthenticationState.loading,
                        );
                      },
                    ),
                    if (isLocked) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _showManualLogin = false;
                            });
                          },
                          child: const Text("Use Biometric"),
                        ),
                      ),
                    ],
                  ],
                  if (!isLocked) ...[
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
                            AppBloc.authenticateCubit.onBiometricLogin();
                          },
                        ),
                      ),
                    if (!_canBiometric)
                      Center(
                        child: Text(
                          "Login once to enable biometric",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
