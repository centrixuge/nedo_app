import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nedo_app/api.dart';
import 'package:nedo_app/driver_schedule_o.dart';

class DriverRoute extends StatefulWidget {
  const DriverRoute(this.user);

  final User user;

  @override
  _DriverRoutePageState createState() => _DriverRoutePageState(this.user);
}

class _DriverRoutePageState extends State<DriverRoute> {
  final User user;

  _DriverRoutePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("乗車予定"),
      ),
      body: Column(children: [
        FutureBuilder(
          future: getDriverJsonString(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              final driversJson = jsonDecode(snapshot.data!);

              return SingleChildScrollView(
                  child: Column(
                children: [
                  for (final item in driversJson["trip"])
                    Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            child: Image.network(getStaticImageWithMarker(
                              width: MediaQuery.of(context).size.width.toInt(),
                              height: 150,
                              driverJsonString: Uri.encodeComponent(
                                  jsonEncode(item["geojson"])),
                            ))),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(text: '🔵${item["dep_time"]} 発予定'),
                            const TextSpan(text: '\n'),
                            TextSpan(text: '🔴${item["arr_time"]} 着予定 '),
                            TextSpan(
                                text: arrTaskJA(item["arr_task"]),
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ])),
                        )
                      ],
                    )
                ],
              ));
            } else {
              return const Text("データが存在しません");
            }
          },
        ),
        ElevatedButton(
            onPressed: () => _onButtonPressed(),
            child: const Text('新しい旅程を設定する'))
      ]),
    );
  }

  _onButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverScheduleOrigin(user)),
    );
  }
}

String arrTaskJA(String? arrTaskEN) {
  switch (arrTaskEN) {
    case "load":
      return "荷積み";
    case "unload":
      return "荷下ろし";
    default:
      return "帰宅";
  }
}

String getStaticImageWithMarker(
    {required int width,
    required int height,
    required String driverJsonString,
    int zoom = 16}) {
  final mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];
  final mapboxUserID = dotenv.env['MAPBOX_USER_ID'];
  final mapboxStyleID = dotenv.env['MAPBOX_STYLE_ID'];
  return 'https://api.mapbox.com/styles/v1/$mapboxUserID/$mapboxStyleID/static/'
      'geojson($driverJsonString)'
      '/auto'
      '/${width}x$height?access_token=$mapboxPublicToken';
}
