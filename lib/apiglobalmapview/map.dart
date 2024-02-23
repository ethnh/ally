import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'dart:math';
import './worldCities.dart';
import './cities.dart';

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      // Use the recommended flutter_map_cancellable_tile_provider package to
      // support the cancellation of loading tiles.
      tileProvider: CancellableNetworkTileProvider(),
    );

class InteractiveCityMapPage extends StatefulWidget {
  const InteractiveCityMapPage({super.key});
  @override
  _InteractiveCityMapPageState createState() => _InteractiveCityMapPageState();
}

class _InteractiveCityMapPageState extends State<InteractiveCityMapPage> {
  final LayerHitNotifier<City> _hitNotifier = ValueNotifier(null);
  List<City>? _prevHitValues;
  List<Polygon<City>>? _hoverGons;
  late final _polygons =
      Map.fromEntries(_buildCityPolygons().map((e) => MapEntry(e.hitValue, e)));

  List<Polygon<City>> _buildCityPolygons() {
    return cities.map((city) {
      final radius =
          city.staticRadius ?? city.maxRadius ?? 0.3;
      List<LatLng> points = createCircularPolygon(
          city.coordinates, radius, 36);
      return Polygon<City>(
        points: points,
        borderColor: Colors.blue,
        borderStrokeWidth: 3.0,
        color: Colors.blue.withOpacity(0.5),
        hitValue: city,
      );
    }).toList();
  }

  List<LatLng> createCircularPolygon(LatLng center, double radius, int points) {
    List<LatLng> polygonPoints = [];
    for (int i = 0; i < points; i++) {
      double angle = (360 / points) * i;
      double radians = angle * (pi / 180);
      double latitude = center.latitude + radius * cos(radians);
      double longitude = center.longitude + radius * sin(radians);
      polygonPoints.add(LatLng(latitude, longitude));
    }
    return polygonPoints;
  }

  void _showCityDialog(String cityName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("City Information"),
          content: Text("You clicked on $cityName"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openTouchedGonsModal(
    String eventType,
    List<City> tappedLines,
    LatLng coords,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tapped Polygon(s)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '$eventType at point: (${coords.latitude.toStringAsFixed(6)}, ${coords.longitude.toStringAsFixed(6)})',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final tappedLineData = tappedLines[index];
                  return ListTile(
                    leading: index == 0
                        ? const Icon(Icons.vertical_align_top)
                        : index == tappedLines.length - 1
                            ? const Icon(Icons.vertical_align_bottom)
                            : const SizedBox.shrink(),
                    title: Text(tappedLineData.name),
                    subtitle: Text(tappedLineData.coordinates.toString()),
                    dense: true,
                  );
                },
                itemCount: tappedLines.length,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive City Map'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(51.5, -0.09),
          initialZoom: 5,
        ),
        children: [
          openStreetMapTileLayer,
          MouseRegion(
            hitTestBehavior: HitTestBehavior.deferToChild,
            cursor: SystemMouseCursors.click,
            onHover: (_) {
              final hitValues = _hitNotifier.value?.hitValues.toList();
              if (hitValues == null) return;

              if (listEquals(hitValues, _prevHitValues)) return;
              _prevHitValues = hitValues;

              final hoverLines = hitValues.map((v) {
                final original = _polygons[v]!;

                return Polygon<City>(
                  points: original.points,
                  holePointsList: original.holePointsList,
                  color: Colors.transparent,
                  borderStrokeWidth: 15,
                  borderColor: Colors.green,
                  disableHolesBorder: original.disableHolesBorder,
                );
              }).toList();
              setState(() => _hoverGons = hoverLines);
            },
            onExit: (_) {
              _prevHitValues = null;
              setState(() => _hoverGons = null);
            },
            child: GestureDetector(
              onTap: () => _openTouchedGonsModal(
                'Tapped',
                _hitNotifier.value!.hitValues,
                _hitNotifier.value!.coordinate,
              ),
              onLongPress: () => _openTouchedGonsModal(
                'Long pressed',
                _hitNotifier.value!.hitValues,
                _hitNotifier.value!.coordinate,
              ),
              onSecondaryTap: () => _openTouchedGonsModal(
                'Secondary tapped',
                _hitNotifier.value!.hitValues,
                _hitNotifier.value!.coordinate,
              ),
              child: PolygonLayer(
                hitNotifier: _hitNotifier,
                simplificationTolerance: 0,
                polygons: [..._buildCityPolygons(), ...?_hoverGons],
              ),
            ),
          ),
//              PolygonLayer(
//                simplificationTolerance: 0,
//                useAltRendering: true,
//                polygons: [
//                  Polygon(
//                    points: const [
//                      LatLng(50, -18),
//                      LatLng(50, -14),
//                      LatLng(51.5, -12.5),
//                      LatLng(54, -14),
//                      LatLng(54, -18),
//                    ],
//                    holePointsList: [
//                      const [
//                        LatLng(52, -17),
//                        LatLng(52, -16),
//                        LatLng(51.5, -15.5),
//                        LatLng(51, -16),
//                        LatLng(51, -17),
//                      ],
//                      const [
//                        LatLng(53.5, -17),
//                        LatLng(53.5, -16),
//                        LatLng(53, -15),
//                        LatLng(52.25, -15),
//                        LatLng(52.25, -16),
//                        LatLng(52.75, -17),
//                      ],
//                    ],
//                    borderStrokeWidth: 4,
//                    borderColor: Colors.black,
//                    color: Colors.green,
//                  ),
//                  Polygon(
//                    points: const [
//                      LatLng(50, -18),
//                      LatLng(53, -16),
//                      LatLng(51.5, -12.5),
//                      LatLng(54, -14),
//                      LatLng(54, -18),
//                    ]
//                        .map((latlng) =>
//                            LatLng(latlng.latitude - 6, latlng.longitude))
//                        .toList(),
//                    holePointsList: [
//                      const [
//                        LatLng(52, -17),
//                        LatLng(52, -16),
//                        LatLng(51.5, -15.5),
//                        LatLng(51, -16),
//                        LatLng(51, -17),
//                      ],
//                      const [
//                        LatLng(53.5, -17),
//                        LatLng(53.5, -16),
//                        LatLng(53, -15),
//                        LatLng(52.25, -15),
//                        LatLng(52.25, -16),
//                        LatLng(52.75, -17),
//                      ],
//                    ]
//                        .map(
//                          (latlngs) => latlngs
//                              .map((latlng) =>
//                                  LatLng(latlng.latitude - 6, latlng.longitude))
//                              .toList(),
//                        )
//                        .toList(),
//                    borderStrokeWidth: 4,
//                    borderColor: Colors.black,
//                    color: Colors.green,
//                  ),
//                ],
//              ),
        ],
      ),
    );
  }
}
