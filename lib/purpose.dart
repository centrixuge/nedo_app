// import 'package:flutter/material.dart';
// import 'checkview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class Purpose extends StatefulWidget {
//   final String origin;
//   final String destination;
//   final DateTime departure;
//   final DateTime arrival;
//   final String usertype;
//   final User user;
//   const Purpose(this.user, this.usertype, this.origin, this.destination, this.departure, this.arrival);
//
//   // Purpose({Key? key, required this.user, required this.origin, required this.destination, required this.departure, required this.arrival}) : super(key: key);
//   @override
//   _PurposePageState createState() => _PurposePageState(this.user, this.usertype, this.origin, this.destination, this.departure, this.arrival);
// }
//
// class _PurposePageState extends State<Purpose> {
//   final TextEditingController _textEditingController_P =
//   TextEditingController();
//   final TextEditingController _textEditingController_C =
//   TextEditingController();
//   // ignore: non_constant_identifier_names
//   bool isButtonActive_P = false;
//   // ignore: non_constant_identifier_names
//   bool isButtonActive_C = false;
//   final String origin;
//   final String destination;
//   final DateTime departure;
//   final DateTime arrival;
//   final String usertype;
//
//   final User user;
//   _PurposePageState(this.user, this.usertype, this.origin, this.destination, this.departure, this.arrival);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("利用形態/利用人数"),
//       ),
//       body: Container(
//         child: Column(children: [
//           TextField(
//             controller: _textEditingController_P,
//             onChanged: (String value) {
//               setState(() {
//                 isButtonActive_P = value.isNotEmpty;
//               });
//             },
//             enabled: true,
//             // maxLength: 50, // 入力数
//             style: const TextStyle(color: Colors.black),
//             obscureText: false,
//             maxLines: 1,
//             decoration: const InputDecoration(
//               icon: Icon(Icons.maps_home_work_outlined),
//               hintText: '利用目的を設定してください',
//               labelText: '利用目的',
//             ),
//           ),
//           TextField(
//             controller: _textEditingController_C,
//             onChanged: (String value) {
//               setState(() {
//                 isButtonActive_C = value.isNotEmpty;
//               });
//             },
//             enabled: true,
//             // maxLength: 50, // 入力数
//             style: const TextStyle(color: Colors.black),
//             obscureText: false,
//             maxLines: 1,
//             decoration: const InputDecoration(
//               icon: Icon(Icons.maps_home_work),
//               hintText: '利用座席数を設定してください',
//               labelText: '利用座席数',
//             ),
//           ),
//
//           ElevatedButton(
//             // ボタンが有効かどうかを切り替えるには、三項演算子と「null」を使います。
//             // 三項演算子の条件式に、有効・無効かの条件を指定し、無効であれば「null」を返すようにします。
//             // https://www.choge-blog.com/programming/flutterbutton-enabled-disabled/
//               onPressed: (isButtonActive_P && isButtonActive_C) ? () => _onButtonPressed() : null,
//               // onPressed: (isButtonActive_O && isButtonActive_D) ? () {
//               //    final Origin = _textEditingController_O.text;
//               //    final Destination = _textEditingController_D.text;
//               //    CollectionReference posts = FirebaseFirestore.instance.collection('requests');
//               //    posts.add({"origin": _textEditingController_O, "destination": _textEditingController_D});
//               //  } : null,
//               child: Text('選択した旅程を確認する')),
//         ]),
//       ),
//     );
//   }
//   _onButtonPressed(){
//     final user = this.user.email;
//     final usertype = widget.usertype;
//     final departure = widget.departure;
//     final arrival = widget.arrival;
//     final origin = widget.origin;
//     final destination = widget.destination;
//     final purpose = _textEditingController_P.text;
//     final capacity = _textEditingController_C.text;
//     // CollectionReference posts = FirebaseFirestore.instance.collection('requests');
//     // posts.doc("1").set({"departure": Departure, "arrival": Arrival});
//     FirebaseFirestore.instance.collection('requests').add({
//       "user": user,
//       "usertype": usertype,
//       "origin": origin,
//       "destination": destination,
//       "departure": departure,
//       "arrival": arrival,
//       "purpose": purpose,
//       "capacity": capacity,
//     });
//     SetOptions(merge: true);
//     // 遷移先の画面としてリスト追加画面を指定
//     // onPressedには、(){}というカッコを書きます。
//     // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Checkview(
//           // origin: origin,
//           // destination: destination,
//           // departure: departure,
//           // arrival: arrival,
//           // purpose: purpose,
//           // capacity: capacity,
//       )),
//   // 遷移先の画面としてリスト追加画面を指定
//   // onPressedには、(){}というカッコを書きます。
//   // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
//     );
//   }
// }