import 'package:flutter/material.dart';
import 'package:vms_app/features/job/data/models/job_data_model.dart';
import 'package:vms_app/features/job/presentation/ui/widgets/custom_text_field.dart';
import 'truck_info_screen.dart';

class BasicDetailsScreen extends StatefulWidget {
  final JobData jobData;

  const BasicDetailsScreen({super.key, required this.jobData});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final _totalTripCostController = TextEditingController();
  final _startingLocationController = TextEditingController();
  final _endingLocationController = TextEditingController();
  final _routePickupLocationController = TextEditingController();
  final _cargoTypeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _itemWeightController = TextEditingController();
  final _shiftScheduleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if available
    _totalTripCostController.text = widget.jobData.totalTripCost ?? '';
    _startingLocationController.text = widget.jobData.startingLocation ?? '';
    _endingLocationController.text = widget.jobData.endingLocation ?? '';
    _routePickupLocationController.text =
        widget.jobData.routePickupLocation ?? '';
    _cargoTypeController.text = widget.jobData.cargoType ?? '';
    _quantityController.text = widget.jobData.quantity ?? '';
    _itemWeightController.text = widget.jobData.itemWeight ?? '';
    _shiftScheduleController.text = widget.jobData.shiftSchedule ?? '';
  }

  @override
  void dispose() {
    _totalTripCostController.dispose();
    _startingLocationController.dispose();
    _endingLocationController.dispose();
    _routePickupLocationController.dispose();
    _cargoTypeController.dispose();
    _quantityController.dispose();
    _itemWeightController.dispose();
    _shiftScheduleController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    // Save data to model
    widget.jobData.totalTripCost = _totalTripCostController.text;
    widget.jobData.startingLocation = _startingLocationController.text;
    widget.jobData.endingLocation = _endingLocationController.text;
    widget.jobData.routePickupLocation = _routePickupLocationController.text;
    widget.jobData.cargoType = _cargoTypeController.text;
    widget.jobData.quantity = _quantityController.text;
    widget.jobData.itemWeight = _itemWeightController.text;
    widget.jobData.shiftSchedule = _shiftScheduleController.text;

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TruckInfoScreen(jobData: widget.jobData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Trip Cost',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _totalTripCostController,
              hintText: 'Enter Trip cost',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            const Text(
              'Trip Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Starting',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _startingLocationController,
                        hintText: 'City/Location',
                        prefixIcon: Icons.location_city,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ending',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _endingLocationController,
                        hintText: 'City/Location',
                        prefixIcon: Icons.location_city,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Route Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _routePickupLocationController,
              hintText: 'Pickup Location',
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: 16),

            const Text(
              'Load Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cargo Type',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _cargoTypeController,
                        hintText: 'Cargo Type',
                        prefixIcon: Icons.inventory,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _quantityController,
                        hintText: 'Quantity',
                        prefixIcon: Icons.numbers,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Item Weight',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _itemWeightController,
              hintText: 'Item Weight in Tons',
              prefixIcon: Icons.scale,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            const Text(
              'Shift Schedule',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _shiftScheduleController,
              hintText: 'Preference Shift',
              prefixIcon: Icons.schedule,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
