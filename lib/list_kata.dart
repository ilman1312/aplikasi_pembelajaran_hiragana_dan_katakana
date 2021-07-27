import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DataQuizHiragana {
  String soal;
  String arti;
  String jawaban;

  DataQuizHiragana(
    {
      this.soal,
      this.arti,
      this.jawaban,
    }
  );

  factory DataQuizHiragana.fromJson(Map<String, dynamic> json) {
    return DataQuizHiragana(
      soal: json['soal'],
      arti: json['arti'],
      jawaban: json['jawaban'],
    );
  }
}

class DataQuizKatakana {
  String soal;
  String arti;
  String jawaban;

  DataQuizKatakana(
    {
      this.soal,
      this.arti,
      this.jawaban,
    }
  );

  factory DataQuizKatakana.fromJson(Map<String, dynamic> json) {
    return DataQuizKatakana(
      soal: json['soal'],
      arti: json['arti'],
      jawaban: json['jawaban'],
    );
  }
}

class ListKata extends StatefulWidget {

  @override
  _ListKataState createState() => _ListKataState();
}

class _ListKataState extends State<ListKata> with TickerProviderStateMixin {

  final String urihiragana = 'https://hirakana.000webhostapp.com/tampilquizhiragana.php';
  Future<List<DataQuizHiragana>> fetchhhiragana() async {

    var response = await http.get(urihiragana);

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<DataQuizHiragana> listOfHiragana = items.map<DataQuizHiragana>((json) {
        return DataQuizHiragana.fromJson(json);
      }).toList();

      return listOfHiragana;
      }
     else {
      throw Exception('Failed to load data.');
    }

  }

  final String urikatakana = 'https://hirakana.000webhostapp.com/tampilquizkatakana.php';
  Future<List<DataQuizKatakana>> fetchkatakana() async {

    var response = await http.get(urikatakana);

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<DataQuizKatakana> listOfKatakana = items.map<DataQuizKatakana>((json) {
        return DataQuizKatakana.fromJson(json);
      }).toList();

      return listOfKatakana;
      }
     else {
      throw Exception('Failed to load data.');
    }

  }

  TabController tabController;

  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);

    var tabBarItem = new TabBar(
      tabs: [
        new Tab(
          child: Text('Hiragana'),
        ),
        new Tab(
          child: Text('Katakana'),
        ),
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );

    var hiraganaview = new FutureBuilder<List<DataQuizHiragana>>(
      future: fetchhhiragana(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: new Card(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    elevation: 7.0,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "${snapshot.data[index].soal}",
                          style: TextStyle(fontSize: 30,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${snapshot.data[index].jawaban}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${snapshot.data[index].arti}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      
                    ],),
                  ),

                  onTap: () {
                    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(
                      Audio('kata/${snapshot.data[index].jawaban}.mp3')
                    );
                  },
                );
              }
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return Center(
          child: SpinKitFadingCircle(color: Color(0xFF333366),),
        );
      },
    );

    var katakanaview = new FutureBuilder<List<DataQuizKatakana>>(
      future: fetchkatakana(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: new Card(
                    elevation: 5.0,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "${snapshot.data[index].soal}",
                          style: TextStyle(fontSize: 30,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${snapshot.data[index].jawaban}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${snapshot.data[index].arti}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],),
                  ),

                  onTap: () {
                    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(
                      Audio('kata/${snapshot.data[index].jawaban}.mp3')
                    );
                    print(snapshot.data[index].jawaban);
                  },
                );
              }
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return Center(
          child: SpinKitFadingCircle(color: Color(0xFF333366),),
        );
      },
    );    

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Contoh Kata"),
          bottom: tabBarItem,
        ),
        body: new TabBarView(
          controller: tabController,
          children: [
            hiraganaview,
            katakanaview,
          ],
        ),
      ),
    );


  }
}