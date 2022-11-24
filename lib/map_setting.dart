import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;


FlutterMap selectMap(List nodeJson, Function onPressed) {
  final mapboxPublicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];
  final mapboxUserID = dotenv.env['MAPBOX_USER_ID'];
  final mapboxStyleID = dotenv.env['MAPBOX_STYLE_ID'];

  return FlutterMap(
      options: MapOptions(
        center: latLng.LatLng(36.552541, 140.058133),
        zoom: 15.0,
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
                        onPressed(item["name"]);
                      })),
          ],
        )
      ]);
}
