import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'timing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nedo_app/map_setting.dart';
import 'package:nedo_app/api.dart';

// class DetailReserve extends StatelessWidget{
class DriverScheduleDestination extends StatefulWidget {
  final String origin;
  final String usertype;
  final User user;

  const DriverScheduleDestination(this.user, this.usertype, this.origin);

  // DetailReserve({Key? key, required this.user}) : super(key: key);
  @override
  _DriverScheduleDestinationPageState createState() =>
      _DriverScheduleDestinationPageState(
          this.user, this.usertype, this.origin);
}

class _DriverScheduleDestinationPageState
    extends State<DriverScheduleDestination> {
  final String origin;
  final String usertype;
  final User user;

  _DriverScheduleDestinationPageState(this.user, this.usertype, this.origin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("目的地の登録"),
      ),
      body: FutureBuilder(
        future: getNodeJsonString(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final nodeJson = jsonDecode(snapshot.data!);
            return selectMap(nodeJson, _onButtonPressed);
          } else {
            return const Text("データが存在しません");
          }
        },
      ),
    );
  }

  _onButtonPressed(String destination) {
    final origin = this.origin;
    final usertype = this.usertype;
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
          builder: (context) => Timing(
              user: user,
              usertype: usertype,
              origin: origin,
              destination: destination)),
      // MaterialPageRoute(builder: (context) => Timing(user: user, origin: origin, destination: destination)),
      // 遷移先の画面としてリスト追加画面を指定
      // onPressedには、(){}というカッコを書きます。
      // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
    );
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
