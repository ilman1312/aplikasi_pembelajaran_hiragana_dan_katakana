import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'text_format.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';


class DataHiragana {
  String huruf;
  String ejaan;

  DataHiragana(
    {
      this.huruf,
      this.ejaan,
    }
  );

  factory DataHiragana.fromJson(Map<String, dynamic> json) {
    return DataHiragana(
      huruf: json['huruf'],
      ejaan: json['ejaan_huruf'],
    );
  }
}



class LatihanHiragana extends StatefulWidget {
  @override
  _LatihanHiraganaState createState() => _LatihanHiraganaState();
}

class _LatihanHiraganaState extends State<LatihanHiragana> with TickerProviderStateMixin{

  String id;

  getid() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id");
    }

  jumlahsalah(){
      salah = jumlahpertanyaan - benar;
  }

  Future simpan() async {
    var url = "https://hirakana.000webhostapp.com/latihanscorehiragana.php";
    var response = await http.post(url, body: {
      "id": id,
      "score": score.toString(),
    });
    var data = json.decode(response.body);
    debugPrint(data);
    if (data == "error") {
      debugPrint('user ada');
      Fluttertoast.showToast(
        msg: "Skor Telah Disimpan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
         fontSize: (16.0),
      );
    } else {
       Fluttertoast.showToast(
        msg: "Skor Telah Disimpan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
         fontSize: (16.0),
      );
    }
  }

  final String urihiragana = 'https://hirakana.000webhostapp.com/hiragana.php';
  Future<List<DataHiragana>> fetchhhiragana() async {

    var response = await http.get(urihiragana);

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<DataHiragana> listOfHiragana = items.map<DataHiragana>((json) {
        return DataHiragana.fromJson(json);
      }).toList();

      return listOfHiragana;
      }
     else {
      throw Exception('Failed to load data.');
    }

  }
  
  
// List of questions from some data point
List<int> questions = [
  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
  41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70
];

   // Variables to hold questions list and current question
  List<int> _pageQuestions;
  int _currentQuestion;
  bool pertanyaanHabis = false;
  int score=0;
  int benar=0;
  int salah=0;
  int maxpertanyaan=0;
  int jumlahpertanyaan = 10;
  var _controller = TextEditingController();

  //timer
  final interval = const Duration(seconds: 1);
  bool habis =false;
  int tes = 0;
  final int timerMaxSeconds = 180;
  bool kondisi = false;
  int currentSeconds = 0;
  Timer _timer;
  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
   String get hasiltimer =>
      '${((tes + currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((tes + currentSeconds) % 60).toString().padLeft(2, '0')}';


  startTimeout([int milliseconds]) async {
    await(fetchhhiragana());
    var duration = interval;
    _timer = new Timer.periodic(duration, (timer) {
      setState(() {
        //print(timer.tick);
        currentSeconds = timer.tick;
        if (maxpertanyaan == 10){
          timer.cancel();
          print('stop');
          print('currentSecond = '+ currentSeconds.toString());
        }
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          print('time stop');
          habis = true;
        }
      });
    });
  }
//akhir timer

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}

  @override

void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = questions;
    super.initState();
    getid();
    startTimeout();
  }

  void _shuffleQuestions() {
    // Initialize an empty variable
    int question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {
      // Shuffle the list
      _pageQuestions.shuffle();
      // Take the last question from the list
      question = _pageQuestions.removeLast();
    }
    setState(() {
      // call set state to update the view
      _currentQuestion = question;
    });
  }

  Widget build(BuildContext context) {
if (_pageQuestions.isNotEmpty && _currentQuestion == null) {
            _shuffleQuestions();
            
          }   

  return  Scaffold(
    appBar: new AppBar(
          title: new Text("Latihan Hiragana"),
        ),

        body: FutureBuilder<List<DataHiragana>>(
    future: fetchhhiragana(),
    builder: (context, snapshot){
      
      if (snapshot.hasData){
       if (maxpertanyaan == jumlahpertanyaan || habis){
          simpan();
          jumlahsalah();
         return Padding(
           padding: EdgeInsets.all(10),
           child: Container(
             child: ListView(
               children: [
                 Container(
                   margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                   alignment: Alignment.center,
                   child: Text('Total Skor', style: TextStyle(
                     fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue[600],
                      ),
                     ),
                 ),

                 Container(
                   margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                   alignment: Alignment.center,
                   child: Text('$score', style: TextStyle(
                     fontSize: 80, fontWeight: FontWeight.bold, color: Colors.blue[600],
                      ),
                     ),
                 ),

                 Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.center,
                  child: Text('Waktu Pengerjaan',style: TextStyle(
                    fontSize: 18,
                  ),),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.center,
                  child: Text(hasiltimer, style: TextStyle(fontSize: 50),),
                ),

                 Container(
                   margin: EdgeInsets.all(10),
                   padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                   decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.grey[300],
                   ),
                   alignment: Alignment.center,
                   child: Text('Jumlah Pertanyaan = 10', style: TextStyle(
                     fontSize: 20,  color: Colors.black,
                      ),
                     ),
                 ),

                Container(
                   margin: EdgeInsets.all(10),
                   padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                   decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.grey[300],
                   ),
                   alignment: Alignment.center,
                   child: Text('Jawaban Yang Benar = $benar', style: TextStyle(
                     fontSize: 20,  color: Colors.black,
                      ),
                     ),
                 ),

                 Container(
                   margin: EdgeInsets.all(10),
                   padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                   decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.grey[300],
                   ),
                   alignment: Alignment.center,
                   child: Text('Jawaban Yang salah = $salah', style: TextStyle(
                     fontSize: 20,  color: Colors.black,
                      ),
                     ),
                 ),

               ],
             ),
           ),
         );
       }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal:100),
           
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[       
                     Icon(Icons.timer),
                     SizedBox(
                      width: 2
                      ),
                      
                    Center(child: Text(timerText, style: TextStyle(fontSize: 20),)),

                    Container(
                      child: Text("${snapshot.data[_currentQuestion].huruf}", style: TextStyle(fontSize: 80,),)
                      ),
                    SizedBox(height: 20,),
                    Container(
                      child: TextField(
                        inputFormatters: [
                          LowerCaseTxt(),
                        ],
                        controller: _controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40,  ), 
                      onSubmitted: (answer) {
                        setState(() {
                          maxpertanyaan++;
                        });
                          if (answer.contains("${snapshot.data[_currentQuestion].ejaan}")){
                             debugPrint("The answer is correct");
                             debugPrint("jumlah data ${snapshot.data.length}");
                             //
                             print(_currentQuestion);
                             setState (() {
                               score++;
                               benar++;
                                if (_pageQuestions.isEmpty){
                                  print('pertanyaan habis');
                                  pertanyaanHabis = true;
                                }else{
                                  _controller.clear();
                                  _shuffleQuestions();
                                }
                             });
                          }else{
                             debugPrint("The answer is incorrect");
                             Fluttertoast.showToast(
                                msg: "Jawaban Salah, jawaban yang benar ${snapshot.data[_currentQuestion].ejaan}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                             setState (() {
                               //salah++;
                                if (_pageQuestions.isEmpty){
                                  print('pertanyaan habis');
                                  pertanyaanHabis = true;
                                }else{
                                  _controller.clear();
                                  _shuffleQuestions();
                                }
                             });
                          }
                          }
                        ),
                    ),

                    
                      
    ],
          ),
          );
      } else if (snapshot.hasError) {
        return Text('error');
      }
        return Center(
          child: SpinKitFadingCircle(color: Color(0xFF333366),),
        );
    },
    ),
    );

  }
}