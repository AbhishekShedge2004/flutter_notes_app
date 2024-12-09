import 'package:database_new/db_helper.dart';
import 'package:database_new/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() {
  runApp(ChangeNotifierProvider<DBProvider>(
    create: (context) {
    return DBProvider(dbHelper: DBHelper.getInstance());
  },
    child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}