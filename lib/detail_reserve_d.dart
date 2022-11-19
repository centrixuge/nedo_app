import 'package:flutter/material.dart';
import 'timing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

// class DetailReserve extends StatelessWidget{
class DetailReserveDestination extends StatefulWidget {
  const DetailReserveDestination(this.user);

  final User user;

  // DetailReserve({Key? key, required this.user}) : super(key: key);
  @override
  _DetailReserveDestinationPageState createState() =>
      _DetailReserveDestinationPageState(this.user);
}

class _DetailReserveDestinationPageState extends State<DetailReserveDestination> {
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

  _DetailReserveDestinationPageState(this.user);

  @override
  Widget build(BuildContext context) {
    final mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];
    final mapboxUserID = dotenv.env['MAPBOX_USER_ID'];
    final mapboxStyleID = dotenv.env['MAPBOX_STYLE_ID'];

    return Scaffold(
        appBar: AppBar(
          title: const Text("目的地の登録"),
        ),
        body: Stack(children: [
          FlutterMap(
            options: MapOptions(
              center: latLng.LatLng(35.654827, 139.796382),
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
                  Marker(
                      point: latLng.LatLng(35.654827, 139.796382),
                      builder: (ctx) => IconButton(
                          icon: const Icon(
                            Icons.location_pin,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            () => _onButtonPressed();
                          })),
                ],
              ),
            ],
          ),
          ElevatedButton(
              // ボタンが有効かどうかを切り替えるには、三項演算子と「null」を使います。
              // 三項演算子の条件式に、有効・無効かの条件を指定し、無効であれば「null」を返すようにします。
              // https://www.choge-blog.com/programming/flutterbutton-enabled-disabled/
              onPressed: (isButtonActive_O && isButtonActive_D)
                  ? () => _onButtonPressed()
                  : null,
              child: Text('出発・到着時刻の設定に進む')),
        ]));
  }

  _onButtonPressed() {
    final origin = _textEditingController_O.text;
    final destination = _textEditingController_D.text;
    final usertype = "rider";
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
