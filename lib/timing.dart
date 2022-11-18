import 'package:flutter/material.dart';
import 'purpose.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Timing extends StatefulWidget {
  final String origin;
  final String destination;
  final User user;
  const Timing(this.user, this.origin, this.destination);

  // Timing({Key? key, required this.user , required this.origin, required this.destination}) : super(key: key);
  @override
  _TimingPageState createState() => _TimingPageState(this.user, this.origin, this.destination);
}

class _TimingPageState extends State<Timing> {
  final TextEditingController _textEditingController_B =
  TextEditingController();
  final TextEditingController _textEditingController_E =
  TextEditingController();
  // ignore: non_constant_identifier_names
  bool isButtonActive_B = false;
  // ignore: non_constant_identifier_names
  bool isButtonActive_E = false;
  final String origin;
  final String destination;

  final User user;
  _TimingPageState(this.user, this.origin, this.destination);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("出発時刻/到着時刻の登録"),
      ),
      body: Container(
        child: Column(children: [
          TextField(
            controller: _textEditingController_B,
            onChanged: (String value) {
              setState(() {
                isButtonActive_B = value.isNotEmpty;
              });
            },
            enabled: true,
            // maxLength: 50, // 入力数
            style: const TextStyle(color: Colors.black),
            obscureText: false,
            maxLines: 1,
            decoration: const InputDecoration(
              icon: Icon(Icons.maps_home_work_outlined),
              hintText: '希望出発時刻を設定してください',
              labelText: '出発時刻',
            ),
          ),
          TextField(
            controller: _textEditingController_E,
            onChanged: (String value) {
              setState(() {
                isButtonActive_E = value.isNotEmpty;
              });
            },
            enabled: true,
            // maxLength: 50, // 入力数
            style: const TextStyle(color: Colors.black),
            obscureText: false,
            maxLines: 1,
            decoration: const InputDecoration(
              icon: Icon(Icons.maps_home_work),
              hintText: '希望到着時刻を設定してください',
              labelText: '到着時刻',
            ),
          ),

          ElevatedButton(
            // ボタンが有効かどうかを切り替えるには、三項演算子と「null」を使います。
            // 三項演算子の条件式に、有効・無効かの条件を指定し、無効であれば「null」を返すようにします。
            // https://www.choge-blog.com/programming/flutterbutton-enabled-disabled/
              onPressed: (isButtonActive_B && isButtonActive_E) ? () => _onButtonPressed() : null,
              // onPressed: (isButtonActive_O && isButtonActive_D) ? () {
              //    final Origin = _textEditingController_O.text;
              //    final Destination = _textEditingController_D.text;
              //    CollectionReference posts = FirebaseFirestore.instance.collection('requests');
              //    posts.add({"origin": _textEditingController_O, "destination": _textEditingController_D});
              //  } : null,
              child: Text('選択した旅程を確認する')),
        ]),
      ),
    );
  }
  _onButtonPressed(){
    final departure = _textEditingController_B.text;
    final arrival = _textEditingController_E.text;
    final origin = widget.origin;
    final destination = widget.destination;
    // CollectionReference posts = FirebaseFirestore.instance.collection('requests');
    // posts.doc("1").set({"departure": Departure, "arrival": Arrival});

    // FirebaseFirestore.instance.collection('requests').add({
    //   "origin": origin,
    //   "destination": destination,
    //   "departure": departure,
    //   "arrival": arrival,
    // });
    // SetOptions(merge: true);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Purpose(user, origin, destination, departure, arrival
          // user: user,
          // origin: origin,
          // destination: destination,
          // departure: departure,
          // arrival: arrival
        )));
      // 遷移先の画面としてリスト追加画面を指定
      // onPressedには、(){}というカッコを書きます。
      // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
  }
}