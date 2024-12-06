import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await dotenv.load();
  await initializeDateFormatting('vi_VN', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool? _isDark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    MyApp.themeNotifier.addListener(_updateTheme);
  }

  @override
  void dispose() {
    MyApp.themeNotifier.removeListener(_updateTheme);
    super.dispose();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
      MyApp.themeNotifier.value = _isDark!;
    });
  }

  _updateTheme() {
    setState(() {
      _isDark = MyApp.themeNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDark ? ThemeData.dark() : ThemeData.light(),
          home: const LoginScreen(),
        );
      },
    );
  }
}
