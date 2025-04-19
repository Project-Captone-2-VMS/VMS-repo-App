import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:vms_app/features/job/data/models/job_data_model.dart';
import 'package:vms_app/features/job/presentation/ui/widgets/custom_text_field.dart';
import 'preview_screen.dart';

class TruckInfoScreen extends StatefulWidget {
  final JobData jobData;

  const TruckInfoScreen({super.key, required this.jobData});

  @override
  State<TruckInfoScreen> createState() => _TruckInfoScreenState();
}

class _TruckInfoScreenState extends State<TruckInfoScreen> {
  File? _truckImage;
  final _vehicleNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _registeringAuthorityController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _vehicleAgeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if available
    _vehicleNumberController.text = widget.jobData.vehicleNumber ?? '';
    _ownerNameController.text = widget.jobData.ownerName ?? '';
    _registeringAuthorityController.text =
        widget.jobData.registeringAuthority ?? '';
    _vehicleTypeController.text = widget.jobData.vehicleType ?? '';
    _fuelTypeController.text = widget.jobData.fuelType ?? '';
    _vehicleAgeController.text = widget.jobData.vehicleAge ?? '';
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _ownerNameController.dispose();
    _registeringAuthorityController.dispose();
    _vehicleTypeController.dispose();
    _fuelTypeController.dispose();
    _vehicleAgeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _truckImage = File(image.path);
        widget.jobData.truckImage = image.path;
      });
    }
  }

  void _saveAndPreview() {
    // Save data to model
    widget.jobData.vehicleNumber = _vehicleNumberController.text;
    widget.jobData.ownerName = _ownerNameController.text;
    widget.jobData.registeringAuthority = _registeringAuthorityController.text;
    widget.jobData.vehicleType = _vehicleTypeController.text;
    widget.jobData.fuelType = _fuelTypeController.text;
    widget.jobData.vehicleAge = _vehicleAgeController.text;

    // Navigate to preview screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(jobData: widget.jobData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Info'),
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
              'Upload Truck Image',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _truckImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_truckImage!, fit: BoxFit.cover),
                        )
                        : const Center(
                          child: Text(
                            'Upload Truck Image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Vehicle Number',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _vehicleNumberController,
              hintText: 'Enter Vehicle number',
              prefixIcon: Icons.directions_car,
            ),
            const SizedBox(height: 16),

            const Text(
              'Owner Name',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _ownerNameController,
              hintText: 'Owner Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),

            const Text(
              'Registering authority',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _registeringAuthorityController,
              hintText: 'Registering authority',
              prefixIcon: Icons.verified_user,
            ),
            const SizedBox(height: 16),

            const Text(
              'Vehicle Type',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _vehicleTypeController,
              hintText: 'Vehicle type',
              prefixIcon: Icons.local_shipping,
            ),
            const SizedBox(height: 16),

            const Text(
              'Fuel Type',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _fuelTypeController,
              hintText: 'Fuel Type',
              prefixIcon: Icons.local_gas_station,
            ),
            const SizedBox(height: 16),

            const Text(
              'Vehicle Age',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _vehicleAgeController,
              hintText: 'Age of Vehicle',
              prefixIcon: Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndPreview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Preview', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
