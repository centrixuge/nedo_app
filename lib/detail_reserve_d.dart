import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'timing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:nedo_app/api.dart';

// class DetailReserve extends StatelessWidget{
class DetailReserveDestination extends StatefulWidget {
  final String origin;
  final String usertype;
  final User user;

  const DetailReserveDestination(this.user, this.usertype, this.origin);

  // DetailReserve({Key? key, required this.user}) : super(key: key);
  @override
  _DetailReserveDestinationPageState createState() =>
      _DetailReserveDestinationPageState(this.user, this.usertype, this.origin);
}

class _DetailReserveDestinationPageState
    extends State<DetailReserveDestination> {
  final TextEditingController _textEditingController_O =
      TextEditingController();
  final TextEditingController _textEditingController_D =
      TextEditingController();

  // dynamic isDisabled = true;
  // ignore: non_constant_identifier_names
  bool isButtonActive_O = false;

  // ignore: non_constant_identifier_names
  bool isButtonActive_D = false;

  final String origin;
  final String usertype;
  final User user;

  _DetailReserveDestinationPageState(this.user, this.usertype, this.origin);

  @override
  Widget build(BuildContext context) {
    final mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];
    final mapboxUserID = dotenv.env['MAPBOX_USER_ID'];
    final mapboxStyleID = dotenv.env['MAPBOX_STYLE_ID'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("目的地の登録"),
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
          builder: (context) => Timing(user: user, usertype: usertype, origin: origin, destination: destination)),
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
