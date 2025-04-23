// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteList _$RouteListFromJson(Map<String, dynamic> json) => RouteList(
  routes:
      (json['routes'] as List<dynamic>)
          .map((e) => Route.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$RouteListToJson(RouteList instance) => <String, dynamic>{
  'routes': instance.routes,
};

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
  routeId: (json['routeId'] as num).toInt(),
  totalDistance: (json['totalDistance'] as num).toInt(),
  totalTime: (json['totalTime'] as num).toInt(),
  description: json['description'] as String,
  startLat: (json['startLat'] as num).toDouble(),
  startLng: (json['startLng'] as num).toDouble(),
  endLat: (json['endLat'] as num).toDouble(),
  endLng: (json['endLng'] as num).toDouble(),
  startLocationName: json['startLocationName'] as String,
  endLocationName: json['endLocationName'] as String,
  status: json['status'] as bool,
  routeDate: json['routeDate'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String?,
  polyline: json['polyline'] as String?,
  waypoints:
      (json['waypoints'] as List<dynamic>)
          .map((e) => Waypoint.fromJson(e as Map<String, dynamic>))
          .toList(),
  interconnections:
      (json['interconnections'] as List<dynamic>)
          .map((e) => Interconnection.fromJson(e as Map<String, dynamic>))
          .toList(),
  vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
  'routeId': instance.routeId,
  'totalDistance': instance.totalDistance,
  'totalTime': instance.totalTime,
  'description': instance.description,
  'startLat': instance.startLat,
  'startLng': instance.startLng,
  'endLat': instance.endLat,
  'endLng': instance.endLng,
  'startLocationName': instance.startLocationName,
  'endLocationName': instance.endLocationName,
  'status': instance.status,
  'routeDate': instance.routeDate,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'polyline': instance.polyline,
  'waypoints': instance.waypoints,
  'interconnections': instance.interconnections,
  'vehicle': instance.vehicle,
  'driver': instance.driver,
};

Waypoint _$WaypointFromJson(Map<String, dynamic> json) => Waypoint(
  waypointId: (json['waypointId'] as num).toInt(),
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  sequence: (json['sequence'] as num).toInt(),
  estimatedArrival: json['estimatedArrival'] as String?,
  estimatedDeparture: json['estimatedDeparture'] as String?,
  locationName: json['locationName'] as String,
);

Map<String, dynamic> _$WaypointToJson(Waypoint instance) => <String, dynamic>{
  'waypointId': instance.waypointId,
  'lat': instance.lat,
  'lng': instance.lng,
  'sequence': instance.sequence,
  'estimatedArrival': instance.estimatedArrival,
  'estimatedDeparture': instance.estimatedDeparture,
  'locationName': instance.locationName,
};

Interconnection _$InterconnectionFromJson(Map<String, dynamic> json) =>
    Interconnection(
      interconnectionId: (json['interconnectionId'] as num).toInt(),
      fromWaypoint: json['fromWaypoint'] as String,
      toWaypoint: json['toWaypoint'] as String,
      distance: (json['distance'] as num).toDouble(),
      timeWaypoint: (json['timeWaypoint'] as num).toDouble(),
      timeEstimate: (json['timeEstimate'] as num).toDouble(),
      timeActual: (json['timeActual'] as num).toDouble(),
    );

Map<String, dynamic> _$InterconnectionToJson(Interconnection instance) =>
    <String, dynamic>{
      'interconnectionId': instance.interconnectionId,
      'fromWaypoint': instance.fromWaypoint,
      'toWaypoint': instance.toWaypoint,
      'distance': instance.distance,
      'timeWaypoint': instance.timeWaypoint,
      'timeEstimate': instance.timeEstimate,
      'timeActual': instance.timeActual,
    };

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
  vehicleId: (json['vehicleId'] as num).toInt(),
  licensePlate: json['licensePlate'] as String,
  type: json['type'] as String,
  capacity: (json['capacity'] as num).toInt(),
  status: json['status'] as bool,
  maintenanceSchedule: json['maintenanceSchedule'] as String,
);

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'vehicleId': instance.vehicleId,
  'licensePlate': instance.licensePlate,
  'type': instance.type,
  'capacity': instance.capacity,
  'status': instance.status,
  'maintenanceSchedule': instance.maintenanceSchedule,
};

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
  driverId: (json['driverId'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  licenseNumber: json['licenseNumber'] as String?,
  workSchedule: json['workSchedule'] as String?,
  status: json['status'] as bool,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
);

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
  'driverId': instance.driverId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'licenseNumber': instance.licenseNumber,
  'workSchedule': instance.workSchedule,
  'status': instance.status,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
};
