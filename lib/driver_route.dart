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
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: FutureBuilder(
            future: getStaticImageWithMarker(
                width: MediaQuery.of(context).size.width.toInt(),
                height: 150,
                zoom: 13),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Image.network(snapshot.data!);
              } else {
                return Text("データが存在しません");
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<String> getStaticImageWithMarker(
    {required int width, required int height, int zoom = 16}) async {
  final mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];

  Map geoJson = {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": {
          "marker-color": '#ff0000',
          "marker-size": 'large',
        },
        "geometry": {
          "type": "Point",
          "coordinates": [135.4, 33.3]
        }
      }
    ]
  };

  final driverJson = Uri.encodeComponent(jsonEncode(geoJson));

  return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
      'geojson($driverJson)'
      '/auto'
      '/${width}x$height?access_token=$mapboxPublicToken';
}

Future<String> getDriverJson() {
  return rootBundle.loadString('driver.json');
}
