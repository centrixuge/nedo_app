import 'package:flutter/material.dart';
import 'checkview.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nedo_app/api.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class Timing extends StatefulWidget {
  final String origin;
  final String destination;
  final String usertype;
  final User user;

  // const Timing({Key? key, required this.value}) : super(key: key);
  // const Timing(this.user, this.usertype, this.origin, this.destination);

  const Timing(
      {Key? key,
      required this.user,
      required this.usertype,
      required this.origin,
      required this.destination})
      : super(key: key);

  @override
  _TimingPageState createState() =>
      _TimingPageState(this.user, this.usertype, this.origin, this.destination);
// _TimingPageState createState() => _TimingPageState();
}

class _TimingPageState extends State<Timing> {
  // final TextEditingController _textEditingController_B =
  // TextEditingController();
  // final TextEditingController _textEditingController_E =
  // TextEditingController();
  // // ignore: non_constant_identifier_names
  // bool isButtonActive_B = false;
  // // ignore: non_constant_identifier_names
  // bool isButtonActive_E = false;
  late String origin;
  late String destination;
  late String usertype;
  late User user;
  var selectedDate_B = null;
  var selectedDate_E = null;
  var selectedSeat = null;

  // late DateTime selectedDate_B;
  // late DateTime selectedDate_E;
  late String strDate_B = DateFormat('Hm').format(selectedDate_B);
  late String strDate_E = DateFormat('Hm').format(selectedDate_E);
  late String strSeat;

  final capacityList = <String>['1', '2', '3', '4'];

  _TimingPageState(this.user, this.usertype, this.origin, this.destination);

  @override
  void initState() {
    super.initState();
    origin = widget.origin;
    destination = widget.destination;
    usertype = widget.usertype;
    user = widget.user;
  }

  void showDatePicker_B() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (value) {
                if (value != null && value != selectedDate_B)
                  // ignore: curly_braces_in_flow_control_structures
                  setState(() {
                    selectedDate_B = value;
                    strDate_B = DateFormat('Hm').format(selectedDate_B);
                  });
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2019,
              maximumYear: 2021,
            ),
          );
        });
  }

  void showDatePicker_E() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (value) {
                if (value != selectedDate_E) {
                  setState(() {
                    selectedDate_E = value;
                    strDate_E = DateFormat('Hm').format(selectedDate_E);
                  });
                }
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2019,
              maximumYear: 2021,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("出発時刻/到着時刻の登録"),
        ),

        // // body部分
        // body: Container(
        //     child: Column(children: [
        //       // ドラムロールに書き換え中
        //       // Text(
        //       //   formatter.format(_mydatetime),
        //       //   style: Theme.of(context).textTheme.display1,
        //       // )
        //
        //       TextField(
        //         controller: _textEditingController_B,
        //         onChanged: (String value) {
        //           setState(() {
        //             isButtonActive_B = value.isNotEmpty;
        //           });
        //         },
        //         enabled: true,
        //         // maxLength: 50, // 入力数
        //         style: const TextStyle(color: Colors.black),
        //         obscureText: false,
        //         maxLines: 1,
        //         decoration: const InputDecoration(
        //           icon: Icon(Icons.maps_home_work_outlined),
        //           hintText: '希望出発時刻を設定してください',
        //           labelText: '出発時刻',
        //         ),
        //       ),
        //       TextField(
        //         controller: _textEditingController_E,
        //         onChanged: (String value) {
        //           setState(() {
        //             isButtonActive_E = value.isNotEmpty;
        //           });
        //         },
        //         enabled: true,
        //         // maxLength: 50, // 入力数
        //         style: const TextStyle(color: Colors.black),
        //         obscureText: false,
        //         maxLines: 1,
        //         decoration: const InputDecoration(
        //           icon: Icon(Icons.maps_home_work),
        //           hintText: '希望到着時刻を設定してください',
        //           labelText: '到着時刻',
        //         ),
        //       ),

        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: Row(children: <Widget>[
                Expanded(child: Icon(Icons.access_time, size: 60)),
                Expanded(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 40.0),
                        child: ElevatedButton(
                          child: const Text("出発希望時刻の選択",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            showDatePicker_B();
                          },
                        ))),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(selectedDate_B == null ? "" : "選択した出発時刻",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                      Text(selectedDate_B == null ? "" : strDate_B,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                    ]))
              ])),
              Expanded(
                  child: Row(children: <Widget>[
                Expanded(child: Icon(Icons.access_time_filled, size: 60)),
                Expanded(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 40.0),
                        child: ElevatedButton(
                          child: const Text("到着希望時刻の選択",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            showDatePicker_E();
                          },
                        ))),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(selectedDate_E == null ? "" : "選択した到着時刻",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                    Text(selectedDate_E == null ? "" : strDate_E,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ))
              ])),
              Expanded(
                child: Row(children: <Widget>[
                  Expanded(child: Icon(Icons.event_seat_sharp, size: 60)),
                  Expanded(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 40.0),
                        child: ElevatedButton(
                          child: const Text("座席数の選択",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  // height: MediaQuery.of(context).size.height / 3,
                                  child: CupertinoPicker(
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        selectedSeat = capacityList[index];
                                        strSeat = selectedSeat.toString();
                                      });
                                    },
                                    itemExtent: 30,
                                    children: const [
                                      Text('1'),
                                      Text('2'),
                                      Text('3'),
                                      Text('4')
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(selectedSeat == null ? "" : "選択した座席数",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                      Text(selectedSeat == null ? "" : selectedSeat,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ))
                ]),
              ),
              ElevatedButton(
                  // ボタンが有効かどうかを切り替えるには、三項演算子と「null」を使います。
                  // 三項演算子の条件式に、有効・無効かの条件を指定し、無効であれば「null」を返すようにします。
                  // https://www.choge-blog.com/programming/flutterbutton-enabled-disabled/
                  onPressed: (selectedDate_B != null && selectedDate_E != null)
                      ? () => _onButtonPressed()
                      : null,
                  // onPressed: (isButtonActive_B && isButtonActive_E) ? () => _onButtonPressed() : null,
                  // onPressed: (isButtonActive_O && isButtonActive_D) ? () {
                  //    final Origin = _textEditingController_O.text;
                  //    final Destination = _textEditingController_D.text;
                  //    CollectionReference posts = FirebaseFirestore.instance.collection('requests');
                  //    posts.add({"origin": _textEditingController_O, "destination": _textEditingController_D});
                  //  } : null,
                  child: Text('選択した旅程を確認する')),
              Expanded(
                child: Container(
                  constraints: BoxConstraints.expand(height: 3),
                  alignment: Alignment.center,
                  width: 400,
                  height: 3,
                  // color: Colors.indigoAccent,
                  // child: Text("アイコンをタッチしてください", style: TextStyle(color: Colors.white)),
                ),
              ),
            ]));
  }

  _onButtonPressed() {
    // final user = this.user.email;
    final user = widget.user.email;
    final usertype = widget.usertype;
    final departure = selectedDate_B;
    final arrival = selectedDate_E;
    final origin = widget.origin;
    final destination = widget.destination;
    final capacity = selectedSeat;

    // final capacity = _textEditingController_C.text;
    // CollectionReference posts = FirebaseFirestore.instance.collection('requests');
    // posts.doc("1").set({"departure": Departure, "arrival": Arrival});
    FirebaseFirestore.instance.collection('requests').add({
      "user": user,
      "usertype": usertype,
      "origin": origin,
      "departure": departure,
      "arrival": arrival,
      "destination": destination,
      // "purpose": purpose,
      "capacity": capacity,
    });
    
    DateFormat outputFormat = DateFormat("yyyy-MM-dd hh:mm");

    postTiming(jsonEncode({
      "usertype": usertype,
      "origin": origin,
      "departure": outputFormat.format(departure),
      "arrival": outputFormat.format(arrival),
      "destination": destination
    }));

    SetOptions(merge: true);
    // 遷移先の画面としてリスト追加画面を指定
    // onPressedには、(){}というカッコを書きます。
    // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Checkview(user!
              // origin: origin,
              // destination: destination,
              // departure: departure,
              // arrival: arrival,
              // purpose: purpose,
              // capacity: capacity,
              )),
      // 遷移先の画面としてリスト追加画面を指定
      // onPressedには、(){}というカッコを書きます。
      // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
    );
  }
}

/// datePickerの表示構成
// Widget _bottomPicker(Widget picker) {
//   return Container(
//     height: 216,
//     padding: const EdgeInsets.only(top: 6.0),
//     color: CupertinoColors.white,
//     child: DefaultTextStyle(
//       style: const TextStyle(
//         color: CupertinoColors.black,
//         fontSize: 22.0,
//       ),
//       child: GestureDetector(
//         onTap: () {},
//         child: SafeArea(
//           top: false,
//           child: picker,
//         ),
//       ),
//     ),
//   );
// }
