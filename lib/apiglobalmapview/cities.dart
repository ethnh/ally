import 'package:latlong2/latlong.dart';

class City {
  final String name;
  final LatLng coordinates;
  final int?
      population; // Used to increase the radius of the circle drawn around the city TBD
  final double?
      maxRadius; // Used to limit the radius of the circle drawn around the city, as adjusted by population? TBD
  final int?
      polygonPoints; // Used to limit the number of points in the polygon drawn around the city, for cities affected by and adjusted to the maxRadius TBD
  final double?
      staticRadius; // Used to set a static radius for the city, if desired
  City(this.name, this.coordinates,
      {this.staticRadius, this.population, this.maxRadius, this.polygonPoints});
}
