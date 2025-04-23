import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

@JsonSerializable()
class RouteList {
  final List<Route> routes;

  RouteList({
    required this.routes,
  });

  factory RouteList.fromJson(Map<String, dynamic> json) => _$RouteListFromJson(json);

  Map<String, dynamic> toJson() => _$RouteListToJson(this);
}

@JsonSerializable()
class Route {
  final int routeId;
  final int totalDistance;
  final int totalTime;
  final String description;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String startLocationName;
  final String endLocationName;
  final bool status;
  final String routeDate;
  final String startTime;
  final String? endTime;
  final String? polyline;
  final List<Waypoint> waypoints;
  final List<Interconnection> interconnections;
  final Vehicle vehicle;
  final Driver driver;

  Route({
    required this.routeId,
    required this.totalDistance,
    required this.totalTime,
    required this.description,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.startLocationName,
    required this.endLocationName,
    required this.status,
    required this.routeDate,
    required this.startTime,
    this.endTime,
    this.polyline,
    required this.waypoints,
    required this.interconnections,
    required this.vehicle,
    required this.driver,
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

@JsonSerializable()
class Waypoint {
  final int waypointId;
  final double lat;
  final double lng;
  final int sequence;
  final String? estimatedArrival;
  final String? estimatedDeparture;
  final String locationName;

  Waypoint({
    required this.waypointId,
    required this.lat,
    required this.lng,
    required this.sequence,
    this.estimatedArrival,
    this.estimatedDeparture,
    required this.locationName,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) => _$WaypointFromJson(json);

  Map<String, dynamic> toJson() => _$WaypointToJson(this);
}

@JsonSerializable()
class Interconnection {
  final int interconnectionId;
  final String fromWaypoint;
  final String toWaypoint;
  final double distance;
  final double timeWaypoint;
  final double timeEstimate;
  final double timeActual;

  Interconnection({
    required this.interconnectionId,
    required this.fromWaypoint,
    required this.toWaypoint,
    required this.distance,
    required this.timeWaypoint,
    required this.timeEstimate,
    required this.timeActual,
  });

  factory Interconnection.fromJson(Map<String, dynamic> json) => _$InterconnectionFromJson(json);

  Map<String, dynamic> toJson() => _$InterconnectionToJson(this);
}

@JsonSerializable()
class Vehicle {
  final int vehicleId;
  final String licensePlate;
  final String type;
  final int capacity;
  final bool status;
  final String maintenanceSchedule;

  Vehicle({
    required this.vehicleId,
    required this.licensePlate,
    required this.type,
    required this.capacity,
    required this.status,
    required this.maintenanceSchedule,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}

@JsonSerializable()
class Driver {
  final int driverId;
  final String firstName;
  final String lastName;
  final String? licenseNumber;
  final String? workSchedule;
  final bool status;
  final String email;
  final String phoneNumber;
  
  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    this.licenseNumber,
    this.workSchedule,
    required this.status,
    required this.email,
    required this.phoneNumber,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}
