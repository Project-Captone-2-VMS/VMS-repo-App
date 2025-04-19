class JobData {
  String? date;
  String? task;
  String? pickupLocation;
  String? deliveryLocation;
  String? truckType;
  String? tripCost;

  // Basic Details
  String? totalTripCost;
  String? startingLocation;
  String? endingLocation;
  String? routePickupLocation;
  String? cargoType;
  String? quantity;
  String? itemWeight;
  String? shiftSchedule;

  // Truck Info
  String? truckImage;
  String? vehicleNumber;
  String? ownerName;
  String? registeringAuthority;
  String? vehicleType;
  String? fuelType;
  String? vehicleAge;

  JobData({
    this.date,
    this.task,
    this.pickupLocation,
    this.deliveryLocation,
    this.truckType,
    this.tripCost,
    this.totalTripCost,
    this.startingLocation,
    this.endingLocation,
    this.routePickupLocation,
    this.cargoType,
    this.quantity,
    this.itemWeight,
    this.shiftSchedule,
    this.truckImage,
    this.vehicleNumber,
    this.ownerName,
    this.registeringAuthority,
    this.vehicleType,
    this.fuelType,
    this.vehicleAge,
  });
}
