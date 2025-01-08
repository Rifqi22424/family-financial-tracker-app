import 'package:financial_family_tracker/features/auth/data/models/arguments/email_argument.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/consts/app_padding.dart';
import '../../../../core/consts/image_routes.dart';
import '../../states/registration_provider.dart';
import '../widgets/form_field_registration.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController.text = "username";
    _emailController.text = "gmail@gmail.com";
    _passwordController.text = "password";
    _confirmPasswordController.text = "password";
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
                  controller: _usernameController, labelText: "Username"),
              AuthFormField(controller: _emailController, labelText: "Email"),
              AuthFormField(
                  controller: _passwordController, labelText: "Password"),
              AuthFormField(
                  controller: _confirmPasswordController,
                  labelText: "Konfirmasi Password"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, "/login"),
                      child: Text("Login")),
                  Consumer<RegistrationProvider>(
                    builder: (context, registrationProvider, child) {
                      switch (registrationProvider.state) {
                        case RegistrationState.loading:
                          return const CircularProgressIndicator();
                        case RegistrationState.loaded:
                          return const Text(
                            "Registration successful!",
                            style: TextStyle(color: Colors.green),
                          );
                        default:
                          return ElevatedButton(
                            onPressed: () async {
                              final username = _usernameController.text;
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final confirmPassword =
                                  _confirmPasswordController.text;

                              await registrationProvider.registration(
                                  username, email, password, confirmPassword);

                              if (registrationProvider.state ==
                                  RegistrationState.error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        registrationProvider.errorMessage ??
                                            "Login failed."),
                                  ),
                                );
                                return;
                              }

                              Navigator.pushNamed(context, "/verification",
                                  arguments: EmailArgument(email: email));
                            },
                            child: const Text("Registration"),
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
