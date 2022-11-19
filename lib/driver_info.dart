import 'package:flutter/material.dart';
import 'timing.dart';
import 'driver_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class DetailReserve extends StatelessWidget{
class DriverInfo extends StatefulWidget {
  const DriverInfo(this.user);

  final User user;

  // DetailReserve({Key? key, required this.user}) : super(key: key);
  @override
  _DriverInfoPageState createState() => _DriverInfoPageState(this.user);
}

class _DriverInfoPageState extends State<DriverInfo> {
  final TextEditingController _textEditingController_O =
      TextEditingController();
  final TextEditingController _textEditingController_D =
      TextEditingController();

  // dynamic isDisabled = true;
  // ignore: non_constant_identifier_names
  bool isButtonActive_O = false;

  // ignore: non_constant_identifier_names
  bool isButtonActive_D = false;

  late final User user;

  _DriverInfoPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("出発地/目的地の登録"),
      ),
      body: Container(
        child: Column(children: [
          TextField(
            controller: _textEditingController_O,
            // onSubmitted: _onSubmitted0, // onSubmitted関数を定義

            onChanged: (String value) {
              setState(() {
                isButtonActive_O = value.isNotEmpty;
              });
            },
            enabled: true,
            // maxLength: 50, // 入力数
            style: const TextStyle(color: Colors.black),
            obscureText: false,
            maxLines: 1,
            decoration: const InputDecoration(
              icon: Icon(Icons.maps_home_work_outlined),
              hintText: '出発地を設定してください',
              labelText: '出発地',
            ),
          ),
          TextField(
            controller: _textEditingController_D,
            onChanged: (String value) {
              setState(() {
                isButtonActive_D = value.isNotEmpty;
              });
            },
            // onSubmitted: _onSubmittedD, // onSubmitted関数を定義
            enabled: true,
            // maxLength: 50, // 入力数
            style: const TextStyle(color: Colors.black),
            obscureText: false,
            maxLines: 1,
            decoration: const InputDecoration(
              icon: Icon(Icons.maps_home_work),
              hintText: '目的地を設定してください',
              labelText: '目的地',
            ),
          ),
          ElevatedButton(
              // ボタンが有効かどうかを切り替えるには、三項演算子と「null」を使います。
              // 三項演算子の条件式に、有効・無効かの条件を指定し、無効であれば「null」を返すようにします。
              // https://www.choge-blog.com/programming/flutterbutton-enabled-disabled/
              onPressed: (isButtonActive_O && isButtonActive_D)
                  ? () => _onButtonPressed()
                  : null,
              // onPressed: (isButtonActive_O && isButtonActive_D) ? () {
              //    final Origin = _textEditingController_O.text;
              //    final Destination = _textEditingController_D.text;
              //    CollectionReference posts = FirebaseFirestore.instance.collection('requests');
              //    posts.add({"origin": _textEditingController_O, "destination": _textEditingController_D});
              //  } : null,
              child: Text('出発・到着時刻の設定に進む')),
          ElevatedButton(
              onPressed: () => _onRouteButtonPressed(), child: Text('旅程を確認'))
        ]),
      ),
    );
  }

  _onButtonPressed() {
    final origin = _textEditingController_O.text;
    final destination = _textEditingController_D.text;
    final usertype = "driver";
    // CollectionReference posts = FirebaseFirestore.instance.collection('requests');
    // posts.doc("1").set({"origin": Origin, "destination": Destination});

    // FirebaseFirestore.instance.collection('requests').doc('1').set({
    //   "origin": Origin,
    //   "destination": Destination,
    // });
    // SetOptions(merge: true);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Timing(user, usertype, origin, destination)),
      // MaterialPageRoute(builder: (context) => Timing(user: user, origin: origin, destination: destination)),
      // 遷移先の画面としてリスト追加画面を指定
      // onPressedには、(){}というカッコを書きます。
      // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
    );
  }

  _onRouteButtonPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DriverRoute(user)));
  }
}

// _onSubmitted0(String content){
//   CollectionReference posts = FirebaseFirestore.instance.collection('requests');
//   posts.add({
//     "origin": content
//   });
//
//   /// 入力欄をクリアにする
//   // _textEditingController.clear();
// }

// _onSubmittedD(String content){
//   CollectionReference posts = FirebaseFirestore.instance.collection('requests');
//   posts.add({
//     "destination": content
//   });
//
//   /// 入力欄をクリアにする
//   // _textEditingController.clear();
// }
