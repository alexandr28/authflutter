import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:authflutter/views/login_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authflutter/models/user.dart';
import 'package:authflutter/blocs/user_bloc.dart';

class HomeWidget extends StatefulWidget {


  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  /*
  final GoogleSignIn _googleSignIn= GoogleSignIn();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  void signOut(BuildContext context)async{
    await _auth.signOut();
    if(_auth == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginWidget()));
    }else{
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No se puede Cerrar Sesión")));
    }
  }*/
  @override
  Widget build(BuildContext context) {
    //final UserBloc userBloc= BlocProvider.of<UserBloc>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 80.0),
                  child: Text("SingelAr",style: TextStyle(fontSize: 30),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
