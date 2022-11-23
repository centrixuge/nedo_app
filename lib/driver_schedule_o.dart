import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'driver_schedule_d.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:nedo_app/api.dart';

class DriverScheduleOrigin extends StatefulWidget {
  const DriverScheduleOrigin(this.user);

  final User user;
  @override
  _DriverScheduleOriginPageState createState() =>
      _DriverScheduleOriginPageState(this.user);
}

class _DriverScheduleOriginPageState extends State<DriverScheduleOrigin> {
  final TextEditingController _textEditingController_O =
  TextEditingController();
  final TextEditingController _textEditingController_D =
  TextEditingController();

  late final User user;

  _DriverScheduleOriginPageState(this.user);

  @override
  Widget build(BuildContext context) {
    final mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];
    final mapboxUserID = dotenv.env['MAPBOX_USER_ID'];
    final mapboxStyleID = dotenv.env['MAPBOX_STYLE_ID'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("出発地の登録"),
      ),
      body: FutureBuilder(
        future: getNodeJsonString(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final nodeJson = jsonDecode(snapshot.data!);
            return FlutterMap(
                options: MapOptions(
                  center: latLng.LatLng(36.552541, 140.058133),
                  zoom: 16.0,
                  maxZoom: 17.0,
                  minZoom: 3.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://api.mapbox.com/styles/v1/$mapboxUserID/$mapboxStyleID/tiles/{z}/{x}/{y}?access_token=$mapboxPublicToken',
                  ),
                  MarkerLayer(
                    markers: [
                      for (final item in nodeJson)
                        Marker(
                            point: latLng.LatLng(
                                item["coordinates"][1], item["coordinates"][0]),
                            builder: (ctx) => IconButton(
                                icon: const Icon(
                                  Icons.location_pin,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  _onButtonPressed(item["name"]);
                                })),
                    ],
                  )
                ]);
          } else {
            return const Text("データが存在しません");
          }
        },
      ),
    );
  }

  _onButtonPressed(String origin) {
    const usertype = "rider";
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
          builder: (context) =>
              DriverScheduleDestination(user, usertype, origin)),
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
