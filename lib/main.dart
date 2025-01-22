import 'package:flutter/material.dart';
import 'package:university_library/components/appcolors.dart';
import 'package:university_library/components/approute.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:university_library/localization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); 

  // Change language dynamically
  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        scaffoldBackgroundColor: AppColors.gray100,
      ),
      initialRoute: Approute.home,
      routes: Approute.routes,
      locale: _locale,  // Apply the current locale
      supportedLocales: const [
        Locale('en', ''), 
        Locale('rw', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizationDelegate(),
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale?.languageCode) {
            return locale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
