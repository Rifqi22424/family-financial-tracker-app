import 'package:financial_family_tracker/features/auth/data/models/arguments/email_argument.dart';
import 'package:financial_family_tracker/features/auth/states/password_provider.dart';
import 'package:financial_family_tracker/features/auth/states/verification_provider.dart';
import 'package:financial_family_tracker/features/dashboard/states/dashboard_provider.dart';
import 'package:financial_family_tracker/features/family/data/models/arguments/join_family_argument.dart';
import 'package:financial_family_tracker/features/family/presentation/pages/create_family_page.dart';
import 'package:financial_family_tracker/features/family/states/create_family_provider.dart';
import 'package:financial_family_tracker/features/family/states/join_family_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/consts/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/verfication_page.dart';
import 'features/auth/states/registration_provider.dart';
import 'features/dashboard/states/family_code_provider.dart';
import 'routes/generate_route.dart';
import 'features/auth/states/login_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => VerificationProvider()),
        ChangeNotifierProvider(create: (_) => JoinFamilyProvider()),
        ChangeNotifierProvider(create: (_) => CreateFamilyProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => FamilyCodeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
      // onGenerateInitialRoutes: (initialRoute) {
      //   if (initialRoute == '/create_family') {
      //     return [
      //       MaterialPageRoute(
      //         builder: (context) => CreateFamilyPage(
      //           argument: RoleArgument(role: "ANAK"),
      //         ),
      //       ),
      //     ];
      //   }
      //   // Default route
      //   return [
      //     MaterialPageRoute(builder: (context) => LoginPage()),
      //   ];
      // },
        onGenerateRoute: GenerateRoute.onGenerateRoute,
        localizationsDelegates: [
          // Delegasi bawaan Flutter
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // Delegasi untuk month_year_picker
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // Bahasa Inggris
          const Locale('id', ''), // Bahasa Indonesia (opsional)
        ],
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
