import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      body: Center(
        child: FutureBuilder(
          future: getDriverJsonString(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              final driversJson = jsonDecode(snapshot.data!)["0"];

              return SingleChildScrollView(
                  child: Column(
                children: [
                  for (final item in driversJson)
                    SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.network(getStaticImageWithMarker(
                          width: MediaQuery.of(context).size.width.toInt(),
                          height: 150,
                          driverJsonString:
                              Uri.encodeComponent(jsonEncode(item)),
                        ))),
                ],
              ));
            } else {
              return Text("データが存在しません");
            }
          },
        ),
      ),
    );
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

Future<String> getDriverJsonString() {
  return rootBundle.loadString('driver.json');
}
