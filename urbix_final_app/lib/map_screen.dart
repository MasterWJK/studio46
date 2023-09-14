import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'my_robot.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  LatLng shortenLineVertically(LatLng start, LatLng end, double shortenAmount) {
    double latDiff = end.latitude - start.latitude;
    double newLat = end.latitude - (latDiff * shortenAmount);

    return LatLng(newLat, end.longitude);
  }

  @override
  Widget build(BuildContext context) {
    // Define marker points for robots and green markers
    LatLng robot1 = LatLng(48.149379, 11.59037); // Marker 1
    LatLng robot2 = LatLng(48.1485, 11.587694); // Marker 2
    LatLng greenMarker1 = LatLng(48.1497, 11.587694); // Middle Marker
    LatLng greenMarker2 = LatLng(48.14830, 11.5905); // Marker 3
    // Define marker points for red and green markers
    LatLng redMarker1 = LatLng(48.145988, 11.58814); // South right from lake
    LatLng redMarker2 = LatLng(48.15053, 11.59015); // Rightop Marker

    // Shorten the lines vertically
    LatLng newGreenMarker1 = shortenLineVertically(robot1, greenMarker1, 0.1);
    LatLng newGreenMarker2 = shortenLineVertically(robot2, greenMarker2, 0.1);

    return FlutterMap(
      options: MapOptions(
        center: LatLng(48.14822, 11.588994), // Latlng (y, x)
        zoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              isDotted: true,
              points: [
                robot1,
                newGreenMarker2
              ], // Connects robot 1 and green marker 1
              strokeWidth: 4.0,
              color: Color(0xFF8aff8a),
            ),
            Polyline(
              isDotted: true,
              points: [
                robot2,
                newGreenMarker1
              ], // Connects robot 2 and green marker 2
              strokeWidth: 4.0,
              color: Color(0xFF8aff8a),
            ),
            // New Polylines between green and red markers
            Polyline(
              isDotted: true,
              points: [
                greenMarker2,
                redMarker1
              ], // Connects green marker 1 and red marker 1
              strokeWidth: 4.0,
              color: Color(0xFFff8a8a),
            ),
            Polyline(
                isDotted: true,
                points: [
                  greenMarker1,
                  redMarker2
                ], // Connects green marker 2 and red marker 2
                strokeWidth: 4.0,
                color: Color(0xFFff8a8a)),
          ],
        ),
        MarkerLayer(
          markers: [
            // Robot 1
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(48.149579, 11.59037), // Latlng (y, x)
              builder: (ctx) => GestureDetector(
                onTap: () {
                  print("object");
                  Navigator.push(
                      context,
                      CustomRoute(
                        destination: MyRobot(issueId: 1),
                        darken: false,
                      ));
                },
                child: Image.asset('assets/images/robot_for_map.png'),
              ),
            ),
            // Robot 2
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(48.1485, 11.587694), // Latlng (y, x)
              builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CustomRoute(
                        destination: MyRobot(issueId: 1),
                        darken: false,
                      ));
                },
                child: Image.asset('assets/images/robot_for_map.png'),
              ),
            ),
            // Middle Marker
            Marker(
              width: 60.0,
              height: 60.0,
              // Latlng (y, x)
              point: LatLng(48.1497, 11.587694),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CustomRoute(
                        destination: MyRobot(issueId: 1),
                        darken: false,
                      ));
                },
                child: const Icon(Icons.location_on, color: Colors.green),
              ),
            ),
            // South right from lake
            Marker(
              width: 60.0,
              height: 60.0,
              // Latlng (y, x)
              point: LatLng(48.145988, 11.58814),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  // Flag
                },
                child: const Icon(Icons.location_on, color: Colors.red),
              ),
            ),
            // Rightop Marker
            Marker(
              width: 60.0,
              height: 60.0,
              // Latlng (y, x)
              point: LatLng(48.15053, 11.59015),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  // Flag
                },
                child: const Icon(Icons.location_on, color: Colors.red),
              ),
            ),

            Marker(
              width: 60.0,
              height: 60.0,
              // Latlng (y, x)
              point: LatLng(48.14830, 11.5905),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  // Flag
                },
                child: Icon(Icons.location_on, color: Colors.green),
              ),
            ),

            // Marker 4 is me
            Marker(
              width: 20.0,
              height: 20.0,
              point: LatLng(48.1485779, 11.5893044),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  // This is me
                },
                child: Image.asset('assets/profile_icon.png'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomRoute extends PageRouteBuilder {
  final Widget destination;
  final bool darken;

  CustomRoute({required this.destination, this.darken = false})
      : super(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child,
            ) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return Stack(
                children: <Widget>[
                  /*FadeTransition(
                opacity: animation,
                child: child,
              ),*/
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                    ).animate(animation),
                    child: child,
                  )
                ],
              );
            },
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
            ) {
              return destination;
            });
}
