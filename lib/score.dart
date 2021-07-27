import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Score extends StatefulWidget {
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  bool isLoading = true;

List listScore = List();
  getScore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setStateIfMounted(() {
      id = preferences.getString("id");
    });
    String url;
      url = "https://hirakana.000webhostapp.com/score.php?id=$id";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setStateIfMounted(() {
        listScore = jsonDecode(response.body);
        isLoading = false;
      });
      print(listScore);
      return listScore;
    }
  }




  String username, id;

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
    getScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skor latihan dan quiz'),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
               (isLoading) 
            ? Center(
              child: SpinKitFadingCircle(
                color: Color(0xFF333366),
              )
            ) : listScore.isEmpty
                    ? Center(child: Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0)  ,
                        child: Text('Belum ada skor', style: TextStyle(fontSize: 30)),
                      ),
                    )
                : ListView.builder(
                  itemCount: listScore == null ? 0 : listScore.length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Padding(
                     padding: EdgeInsets.all(0),
                        child: Column( 
                          children:[

                          // nama
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Text(
                              'Skor $username',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold, 
                              ),
                            ),
                          ),
                          
                          //row 1
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                height: 50,
                                child: Text('Latihan Hiragana', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text(listScore[index]['score_latihan_hiragana'], style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('/', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('10', style: TextStyle(fontSize: 27,color: Colors.blue[600],fontWeight: FontWeight.bold),),
                                ),
                              ], 
                            ),
                          ),
                          
                          //row 2
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            color: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                height: 50,
                                child: Text('Latihan Katakana', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text(listScore[index]['score_latihan_katakana'], style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('/', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('10', style: TextStyle(fontSize: 27,color: Colors.blue[600],fontWeight: FontWeight.bold),),
                                ),
                              ], 
                            ),
                          ),

                          //row 3
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                height: 50,
                                child: Text('Quiz Hiragana      ', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text(listScore[index]['score_quiz_hiragana'], style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('/', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('25', style: TextStyle(fontSize: 27,color: Colors.blue[600],fontWeight: FontWeight.bold),),
                                ),
                              ], 
                            ),
                          ),

                          //row 4
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            color: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                height: 50,
                                child: Text('Quiz Katakana      ', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text(listScore[index]['score_quiz_katakana'], style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('/', style: TextStyle(fontSize: 27),),
                                ),
                                Container(
                                height: 50,
                                child: Text('25', style: TextStyle(fontSize: 27,color: Colors.blue[600],fontWeight: FontWeight.bold),),
                                ),
                              ], 
                            ),
                          ),

                          ],
                        ),

                    );
                  }
                  ),
            ],
           
          )
        ],
      ),
    );
  }
}