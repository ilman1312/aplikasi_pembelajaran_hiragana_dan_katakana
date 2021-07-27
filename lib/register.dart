import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key = GlobalKey<FormState>();
  String username, password;
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
      await register();
    }
  }
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  
  Future register() async {
    var url = "https://hirakana.000webhostapp.com/register.php";
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      debugPrint('user ada');
      Fluttertoast.showToast(
        msg: "user already exist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
         fontSize: (16.0),
      );
    } else {
       Fluttertoast.showToast(
        msg: "Registration Succsessfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
         fontSize: (16.0),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                child: Text('Register', style: TextStyle(fontSize: 25),),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: user,
                  validator: (e){
                    if (e.isEmpty) {
                      return "Please insert username";
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'username',
                  ),
                ),
              ),
              Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          controller: pass,
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
                      SizedBox(height:20,),
                      Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xFF333366),
                            child: Text('Register'),
                            onPressed: ()async {
                              await check();
                            },
                        ),
                      ),
            ],
          ),
        ),
        ),
    );
  }
}