import 'package:financial_family_tracker/features/auth/data/models/arguments/email_argument.dart';
import 'package:financial_family_tracker/features/auth/presentation/pages/verfication_page.dart';
import 'package:financial_family_tracker/features/dashboard/presentation/dashboard_page.dart';

import '../features/family/data/models/arguments/join_family_argument.dart';
import '../features/family/presentation/pages/create_family_page.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/registration_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/role_selection.dart';
import '../features/family/presentation/pages/join_family_page.dart';

class GenerateRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Ambil nama rute dan argument dari settings
    final String? routeName = settings.name;
    final Object? arguments = settings.arguments;

    switch (routeName) {
      // Auth
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case '/registration':
        return MaterialPageRoute(
          builder: (_) => const RegistrationPage(),
        );
      case '/role_selection':
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionPage(),
        );
      case '/verification':
        if (arguments is! EmailArgument)
          return _errorRoute("Invalid arguments for VerificationPage");
        return MaterialPageRoute(
          builder: (_) => VerficationPage(argument: arguments),
        );

      // Family
      case '/join_family':
        if (arguments is! RoleArgument)
          return _errorRoute("Invalid arguments for JoinFamilyPage");
        return MaterialPageRoute(
          builder: (_) => JoinFamilyPage(argument: arguments),
        );

      case '/create_family':
        if (arguments is! RoleArgument)
          return _errorRoute("Invalid arguments for JoinFamilyPage");
        return MaterialPageRoute(
          builder: (_) => CreateFamilyPage(argument: arguments),
        );

      //Dashboard
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );

      // case '/profile':
      //   if (arguments is ProfileArguments) {
      //     return MaterialPageRoute(
      //       builder: (_) => ProfilePage(
      //         userId: arguments.userId,
      //       ),
      //     );
      //   }
      // return _errorRoute("Invalid arguments for ProfilePage");
      // case '/settings':
      //   return MaterialPageRoute(
      //     builder: (_) => SettingsPage(),
      //   );
      default:
        return _errorRoute("Route not found: $routeName");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
