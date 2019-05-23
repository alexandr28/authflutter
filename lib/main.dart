import 'package:flutter/material.dart';
import 'views/loginMultiplex.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/user_bloc.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  UserBloc userBloc= UserBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      bloc: userBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
        primarySwatch: Colors.blue,),
        home: LoginMultiplex(),)
    );
  }
}

