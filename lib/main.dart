import 'package:financial_family_tracker/features/auth/states/verification_provider.dart';
import 'package:financial_family_tracker/features/dashboard/states/dashboard_provider.dart';
import 'package:financial_family_tracker/features/family/states/create_family_provider.dart';
import 'package:financial_family_tracker/features/family/states/join_family_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/states/registration_provider.dart';
import 'routes/generate_route.dart';
import 'features/auth/states/login_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegistrationProvider>(
            create: (_) => RegistrationProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<VerificationProvider>(create: (_) => VerificationProvider()),

        ChangeNotifierProvider<JoinFamilyProvider>(
            create: (_) => JoinFamilyProvider()),
        ChangeNotifierProvider<CreateFamilyProvider>(
            create: (_) => CreateFamilyProvider()),


        ChangeNotifierProvider<DashboardProvider>(
            create: (_) => DashboardProvider()),
      ],
      child: const MaterialApp(
        initialRoute: "/login",
        onGenerateRoute: GenerateRoute.onGenerateRoute,
      ),
    );
  }
}
