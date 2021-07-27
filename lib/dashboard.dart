import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hirakanav2/latihan_katakana.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'list_huruf.dart';
import 'latihan_hiragana.dart';
import 'score.dart';
import 'latihan_katakana.dart';
import 'quiz_hiragana.dart';
import 'quiz_katakana.dart';
import 'list_kata.dart';

class DashBoard extends StatefulWidget {
  final VoidCallback signOut;
  DashBoard(this.signOut);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

// dialog latihan
  void _latihan(BuildContext ctx){
    showDialog(
      context: ctx,
      builder: (_) {
        return SimpleDialog(
          title: Text('Latihan', style: TextStyle(fontSize: 28, color: Colors.black),),
          children: [
            SimpleDialogOption(
              child: Text('Hiragana',style: TextStyle(fontSize: 25),),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => LatihanHiragana()),);
                
              },
            ),
            SimpleDialogOption(
              child: Text('Katakana',style: TextStyle(fontSize: 25),),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => LatihanKatakana()),);
              },
            ),
          ],
        );
      }
    );
  }

  //dialog quiz
  void _quiz(BuildContext ctx){
    showDialog(
      context: ctx,
      builder: (_) {
        return SimpleDialog(
          title: Text('Quiz', style: TextStyle(fontSize: 28, color: Colors.black),),
          children: [
            SimpleDialogOption(
              child: Text('Hiragana',style: TextStyle(fontSize: 25),),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => QuizHiragana()),);
              },
            ),
            SimpleDialogOption(
              child: Text('Katakana',style: TextStyle(fontSize: 25),),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => QuizKatakana()),);
              },
            ),
          ],
        );
      }
    );
  }

  bool isLoading = true;
  signOut() {
    setStateIfMounted(() {
      widget.signOut();
    });
  }

    String username,id;

    void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setStateIfMounted(() {
      username = preferences.getString("username");
      id = preferences.getString("id");
    });
  }


   void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Hirakana'),
        actions: [
          InkWell(
            onTap: (){
              signOut();
            },
            child: Icon(Icons.logout)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            // username
            SizedBox(height:20),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text('Selamat Datang $username', 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, 
                color: Colors.blue[600],
                ),),
            ),
            SizedBox(height:20),

            //List huruf
            Container(
              
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                      textColor: Colors.white,
                      color: Color(0xFF333366),
                        child: Text('List Huruf', style: TextStyle(fontSize: 20),),
                          onPressed: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ListHuruf()),);
                            },
                      )
              ),
            SizedBox(height:20),

            //List kata
            Container(
              
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                      textColor: Colors.white,
                      color: Color(0xFF333366),
                        child: Text('Contoh Kata', style: TextStyle(fontSize: 20),),
                          onPressed: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ListKata()),);
                            },
                      )
              ),
            SizedBox(height:20),

            //Latihan
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                      textColor: Colors.white,
                      color: Color(0xFF333366),
                        child: Text('Latihan', style: TextStyle(fontSize: 20),),
                          onPressed: () async {
                            _latihan(context);
                            },
                      )
              ),
            SizedBox(height:20),

            //Quiz
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                      textColor: Colors.white,
                      color: Color(0xFF333366),
                        child: Text('Quiz', style: TextStyle(fontSize: 20),),
                          onPressed: () async {
                            _quiz(context);
                            },
                      )
              ),
            SizedBox(height:20),

            //skor
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                      textColor: Colors.white,
                      color: Color(0xFF333366),
                        child: Text('Skor', style: TextStyle(fontSize: 20),),
                          onPressed: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => Score()),);
                            },
                      )
              ),

          ],
        ), 
      ),
    );
  }
}