import 'package:flutter/material.dart';
import 'package:flutter_application/data/provider/thememode.dart';
import 'package:flutter_application/presentation/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => MyThemeMode(),
    child: App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyThemeMode>(
      builder: (a, prv, _) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Assignment',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: prv.thememode,
            home: Dashboard());
      },
    );
  }
}
