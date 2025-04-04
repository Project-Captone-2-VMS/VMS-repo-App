enum TripStatus { late, completed }

class Trip {
  final String id;
  final String route;
  final int items;
  final int points;
  final int distance;
  final DateTime date;
  final TripStatus status;

  Trip({
    required this.id,
    required this.route,
    required this.items,
    required this.points,
    required this.distance,
    required this.date,
    required this.status,
  });
}
