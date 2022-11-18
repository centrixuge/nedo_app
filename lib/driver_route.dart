import 'package:flutter/material.dart';
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
            child: Image.network(
              getStaticImageWithMarker(
                  latitude: 35.55,
                  longitude: 134.44,
                  width: MediaQuery.of(context).size.width.toInt(),
                  height: 150,
                  zoom: 13),
            )),
      ),
    );
  }
}

String getStaticImageWithMarker(
    {required double longitude,
    required double latitude,
    required int width,
    required int height,
    int zoom = 16}) {
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
          "coordinates": [longitude, latitude]
        }
      }
    ]
  };

  var mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];

  return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
      'geojson(${Uri.encodeComponent(jsonEncode(geoJson))})'
      '/$longitude,$latitude,$zoom'
      '/${width}x$height?access_token=$mapboxPublicToken';
}
