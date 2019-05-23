
import 'package:flutter/material.dart';
import 'package:authflutter/views/home_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authflutter/models/user.dart';
import 'package:authflutter/blocs/user_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class LoginMultiplex extends StatefulWidget {
  @override
  _LoginMultiplexState createState() => _LoginMultiplexState();
}

class _LoginMultiplexState extends State<LoginMultiplex> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLogget=false;
  FirebaseUser myUser;
  // google
  void login(BuildContext context)async{
    GoogleSignInAccount gUser = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication= await gUser.authentication;
    final AuthCredential credential= GoogleAuthProvider.getCredential(idToken: authentication.idToken, accessToken: authentication.accessToken);
    FirebaseUser firebaseUser= await firebaseAuth.signInWithCredential(credential);
    if(firebaseUser!=null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeWidget()));
    }else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No se puede Iniciar Sesión")));
    }
  }
  // facebook
  Future<FirebaseUser> _loginWithFacebook() async{
    var facesLogin= new FacebookLogin();
    var result = await facesLogin.logInWithReadPermissions(['email','public_profile']);
    FacebookAccessToken myToken = result.accessToken;
    debugPrint(result.status.toString());

    if(result.status == FacebookLoginStatus.loggedIn){
      AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);
      FirebaseUser user= await firebaseAuth.signInWithCredential(credential);
      return user;
    }
    return null;
  }
  // twitter
  Future<FirebaseUser> _loginWithTwitter() async{
    var twLogin= new TwitterLogin(
      consumerKey: 'keytwitter' ,
      consumerSecret:'secretKey',
    );
    final TwitterLoginResult result= await twLogin.authorize();
    switch(result.status){
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        AuthCredential credential= TwitterAuthProvider.getCredential(authToken: session.token, authTokenSecret: session.secret);
        FirebaseUser user= await firebaseAuth.signInWithCredential(credential);
        return user;
        break;
      case TwitterLoginStatus.cancelledByUser:
        debugPrint(result.status.toString());
        return null;
        break;
      case TwitterLoginStatus.error:
        debugPrint(result.errorMessage.toString());
        return null;
        break;
    }
    return null;
  }
  // logOut
  void _logOut()async{
    await firebaseAuth.signOut().then((response){
      isLogget = false;
      setState((){});
    });
  }
  // login facebook
  void _loginFacebook(){
    _loginWithFacebook().then((response){
      if(response !=null){
        myUser=response;
        isLogget=true;
        setState(() {});
      }
    });
  }
  // login twitter
  void _loginTwitter(){
    _loginWithTwitter().then((response){
      if(response!=null){
        myUser=response;
        isLogget=true;
        setState(() {});
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc= BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogget? "Profile Page": "Facebook Login Example"),
        actions: <Widget>[
          isLogget? IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: _logOut,
          )
              : IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: (){},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.green,
                  ),
                  child: new Icon(Icons.local_offer,color: Colors.white,),
                ),
                new Container(
                  margin: new EdgeInsets.only(right: 50.0,top: 50.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.blue,
                  ),
                  child: new Icon(Icons.home,color: Colors.white,),
                ),
                new Container(
                  margin: new EdgeInsets.only(left: 30.0,top: 50.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.redAccent,
                  ),
                  child: new Icon(Icons.place,color: Colors.white,),
                ),
                new Container(
                  margin: new EdgeInsets.only(left: 90.0,top: 40.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.amber,
                  ),
                  child: new Icon(Icons.local_car_wash,color: Colors.white,),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 80.0),
                  child: Text("MulplexLogin",style: TextStyle(fontSize: 30),),
                ),
              ],
            ),
            // Google
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0),
                    child: BlocBuilder<UserEvent,User>(
                      bloc: userBloc,
                      builder: (context,user){
                        if(user.event == UserEvent.none) {
                          return ButtonTheme(
                            height: 60.0,
                            child: RaisedButton(
                              color: Colors.redAccent,
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(9.0)),
                              child: new Text("Google Account",style: new TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold),),
                              onPressed: ()=>login(context),
                            ),
                          );
                        }
                        if(user.event==UserEvent.waiting){
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            //facebook
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: isLogget? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Name: '+myUser.displayName),
                      Image.network(myUser.photoUrl),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FacebookSignInButton(
                        onPressed: _loginFacebook,
                      ),
                      SizedBox(height: 30.0,),
                      TwitterSignInButton(
                        onPressed: _loginTwitter,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
