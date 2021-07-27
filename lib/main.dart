import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'DashBoard.dart';
import 'register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum LoginStatus { notSignIn, signIn }


class _MyHomePageState extends State<MyHomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password, id;
  //int id;

  final _key = GlobalKey<FormState>();
  bool _secureText = true;
   showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      await login();
    }
  }

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  login() async {
    final response = await http.post(
        "https://hirakana.000webhostapp.com/login.php",
        body: {
          "username": username,
          "password": password,
        });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String usernameAPI = data['username'];
    String idAPI = data['id_user'];

    if (value == 1) {
      print(data);
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, idAPI);
      });
    } else {
      print(data);
      Fluttertoast.showToast(
          msg: "Username or Password Inccorect!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

savePref(int value, String username, String id ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("id", id);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

   signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      // ignore: deprecated_member_use
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

   @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
   switch (_loginStatus){
     case LoginStatus.notSignIn:
     return MaterialApp(
       home: Scaffold(
         appBar: AppBar(
           title: Text('Login'),
         ),
         body: Padding(
           padding: EdgeInsets.all(10),
           child: Form(
             key: _key,
             child: ListView(
               children: [
                 Container(
                   alignment: Alignment.center,
                   padding: EdgeInsets.all(10),
                   child: Text('Login', style: TextStyle(fontSize: 25),),
                 ),

                 Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert username";
                            }
                          },
                          onSaved: (e) => username = e,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'User Name',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: _secureText,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert password";
                            }
                          },
                          onSaved: (e) => password = e,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Color(0xFF333366),
                            child: Text('Login'),
                            onPressed: () async {
                              await check();
                            },
                          )
                          ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                                  context,
                                 MaterialPageRoute(builder: (context) => Register()),
                                  );
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                          child: Text("register",
                              style: TextStyle(
                                  color: Color(0xFF333366),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      )
               ],
             ),
           ),
         ),
       ),
     );

     break;
     case LoginStatus.signIn:
      return DashBoard(signOut);
    break;
   }
    
  }
}