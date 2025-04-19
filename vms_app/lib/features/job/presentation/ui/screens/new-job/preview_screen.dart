import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vms_app/features/job/data/models/job_data_model.dart';

class PreviewScreen extends StatelessWidget {
  final JobData jobData;

  const PreviewScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Preview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildSection('Generate New Job', [
              _buildInfoRow('Date', jobData.date ?? 'Not specified'),
              _buildInfoRow('Task', jobData.task ?? 'Not specified'),
              _buildInfoRow(
                'Pickup Location',
                jobData.pickupLocation ?? 'Not specified',
              ),
              _buildInfoRow(
                'Delivery Location',
                jobData.deliveryLocation ?? 'Not specified',
              ),
              _buildInfoRow('Truck Type', jobData.truckType ?? 'Not specified'),
              _buildInfoRow('Trip Cost', jobData.tripCost ?? 'Not specified'),
            ]),

            const SizedBox(height: 24),

            _buildSection('Basic Details', [
              _buildInfoRow(
                'Total Trip Cost',
                jobData.totalTripCost ?? 'Not specified',
              ),
              _buildInfoRow(
                'Starting Location',
                jobData.startingLocation ?? 'Not specified',
              ),
              _buildInfoRow(
                'Ending Location',
                jobData.endingLocation ?? 'Not specified',
              ),
              _buildInfoRow(
                'Route Pickup Location',
                jobData.routePickupLocation ?? 'Not specified',
              ),
              _buildInfoRow('Cargo Type', jobData.cargoType ?? 'Not specified'),
              _buildInfoRow('Quantity', jobData.quantity ?? 'Not specified'),
              _buildInfoRow(
                'Item Weight',
                jobData.itemWeight ?? 'Not specified',
              ),
              _buildInfoRow(
                'Shift Schedule',
                jobData.shiftSchedule ?? 'Not specified',
              ),
            ]),

            const SizedBox(height: 24),

            _buildSection('Truck Info', [
              if (jobData.truckImage != null) ...[
                const Text(
                  'Truck Image:',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(jobData.truckImage!),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _buildInfoRow(
                'Vehicle Number',
                jobData.vehicleNumber ?? 'Not specified',
              ),
              _buildInfoRow('Owner Name', jobData.ownerName ?? 'Not specified'),
              _buildInfoRow(
                'Registering Authority',
                jobData.registeringAuthority ?? 'Not specified',
              ),
              _buildInfoRow(
                'Vehicle Type',
                jobData.vehicleType ?? 'Not specified',
              ),
              _buildInfoRow('Fuel Type', jobData.fuelType ?? 'Not specified'),
              _buildInfoRow(
                'Vehicle Age',
                jobData.vehicleAge ?? 'Not specified',
              ),
            ]),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Here you would typically submit the job data to your backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Job created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Navigate back to the first screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Submit Job', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
