import 'package:flutter/material.dart';
import 'package:flutter_application/data/provider/thememode.dart';
import 'package:flutter_application/presentation/example_list/ViewMockapp.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Assignment'),
        actions: <Widget>[
          Consumer<MyThemeMode>(builder: (w, prv, _) {
            return InkWell(
              child: Icon(
                prv.thememode == ThemeMode.dark
                    ? Icons.lightbulb
                    : Icons.dark_mode,
                color: Colors.white,
              ),
              onTap: () {
                prv.change();
              },
            );
          })
        ],
      ),
      body: ViewMockappList(),
    );
  }
}
