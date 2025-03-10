import 'package:database_new/cubit/db_cubit.dart';
import 'package:database_new/db/db_helper.dart';
import 'package:database_new/provider/db_provider.dart';
import 'package:database_new/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/db_bloc.dart';
import 'ui/home_page.dart';

void main() {
  runApp(BlocProvider(create: (context) {
    return dbBloc(dbHelper: DBHelper.getInstance());
  },child: MyApp(),));
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
      home: SplashScreen(),
    );
  }
}