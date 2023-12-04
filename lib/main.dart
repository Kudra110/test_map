import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

// https://api.mapbox.com/styles/v1/hallaje/clp4cyyyh01ji01qy2patddj9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGFsbGFqZSIsImEiOiJjbHAxMzJrcWYwaGdyMmtzNDE1eHhvNjZzIn0.zn-2Si-6QffTLNaqKKXUgw

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  LatLng? currentPos;
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: const LatLng(32.0208896, 44.351488),
          onTap: (tabPos, pos) {
            debugPrint('tabPos: $tabPos, pos: $pos');
            setState(() {
              currentPos = pos;
            }
            
            
            );
            mapController.move(pos, mapController.camera.zoom);
          },
        ),
        children: [
          TileLayer(
            tileProvider: NetworkTileProvider(),
            urlTemplate:
                'https://api.mapbox.com/styles/v1/hallaje/clp4cyyyh01ji01qy2patddj9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGFsbGFqZSIsImEiOiJjbHAxMzJrcWYwaGdyMmtzNDE1eHhvNjZzIn0.zn-2Si-6QffTLNaqKKXUgw',
          ),
          if (currentPos != null)
            MarkerLayer(markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: currentPos!,
                child: const Icon(Icons.location_on_sharp,size: 39,color: Colors.red,),
              )
            ]),
          CurrentLocationLayer(
            followOnLocationUpdate: FollowOnLocationUpdate.never,
            turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                
              ),
              markerSize: Size(20,20),
              markerDirection: MarkerDirection.heading,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

 
}
