import 'package:financial_family_tracker/core/consts/app_padding.dart';
import 'package:flutter/material.dart';

import '../../../../core/consts/image_routes.dart';
import '../../states/login_provider.dart';
import '../widgets/form_field_registration.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _identifierController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _identifierController.text = "username2";
    _passwordController.text = "password";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        // height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImageRoutes.appLogo, width: 200, height: 200),
              AuthFormField(
                  controller: _identifierController,
                  labelText: "Username or email"),
              AuthFormField(
                  controller: _passwordController, labelText: "Password"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/registration"),
                      child: Text("Register")),
                  // ElevatedButton(onPressed: () {}, child: Text("Login")),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                      switch (loginProvider.state) {
                        case LoginState.loading:
                          return const CircularProgressIndicator();
                        default:
                          return ElevatedButton(
                            onPressed: () async {
                              final identifier = _identifierController.text;
                              final password = _passwordController.text;

                              await loginProvider.login(identifier, password);

                              if (loginProvider.state == LoginState.error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(loginProvider.errorMessage ??
                                        "Login failed."),
                                  ),
                                );
                                return;
                              }

                              Navigator.pushNamed(context, "/dashboard");
                            },
                            child: const Text("Login"),
                          );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: AppPadding.medium),
            ],
          ),
        ),
      ),
    ));
  }
}
