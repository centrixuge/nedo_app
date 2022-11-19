import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserRoute extends StatefulWidget {
  const UserRoute(this.user);

  final User user;

  @override
  _UserRoutePageState createState() => _UserRoutePageState(this.user);
}

class _UserRoutePageState extends State<UserRoute> {
  final User user;

  _UserRoutePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("旅程を確認"),
        ),
        body: FutureBuilder(
            future: getUserJsonString(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                final userJson = jsonDecode(snapshot.data!);
                return Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: 150,
                        padding: const EdgeInsets.all(10),
                        child: Image.network(getStaticImageWithMarker(
                          width: MediaQuery.of(context).size.width.toInt(),
                          height: 300,
                          driverJsonString:
                              Uri.encodeComponent(jsonEncode(userJson["geojson"])),
                        ))),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          Text('🔵${userJson["dep_time"]} 発予定'),
                          Text('🔵${userJson["arr_time"]} 着予定')
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return const Text("データが存在しません");
              }
            }));
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

Future<String> getUserJsonString() {
  return rootBundle.loadString('user.json');
}
