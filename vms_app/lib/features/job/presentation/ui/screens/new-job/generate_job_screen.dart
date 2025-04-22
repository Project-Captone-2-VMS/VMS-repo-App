// import 'package:flutter/material.dart';
// import 'package:vms_app/features/job/data/models/job_model.dart';
// import 'package:vms_app/features/job/presentation/ui/widgets/custom_text_field.dart';
// import 'basic_details_screen.dart';

// class GenerateJobScreen extends StatefulWidget {
//   final JobData? jobData;

//   const GenerateJobScreen({super.key, this.jobData});

//   @override
//   State<GenerateJobScreen> createState() => _GenerateJobScreenState();
// }

// class _GenerateJobScreenState extends State<GenerateJobScreen> {
//   late JobData _jobData;
//   final _dateController = TextEditingController();
//   final _taskController = TextEditingController();
//   final _pickupLocationController = TextEditingController();
//   final _deliveryLocationController = TextEditingController();
//   final _truckTypeController = TextEditingController();
//   final _tripCostController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _jobData = widget.jobData ?? JobData();

//     // Initialize controllers with existing data if available
//     _dateController.text = _jobData.date ?? '';
//     _taskController.text = _jobData.task ?? '';
//     _pickupLocationController.text = _jobData.pickupLocation ?? '';
//     _deliveryLocationController.text = _jobData.deliveryLocation ?? '';
//     _truckTypeController.text = _jobData.truckType ?? '';
//     _tripCostController.text = _jobData.tripCost ?? '';
//   }

//   @override
//   void dispose() {
//     _dateController.dispose();
//     _taskController.dispose();
//     _pickupLocationController.dispose();
//     _deliveryLocationController.dispose();
//     _truckTypeController.dispose();
//     _tripCostController.dispose();
//     super.dispose();
//   }

//   void _saveAndContinue() {
//     // Save data to model
//     _jobData.date = _dateController.text;
//     _jobData.task = _taskController.text;
//     _jobData.pickupLocation = _pickupLocationController.text;
//     _jobData.deliveryLocation = _deliveryLocationController.text;
//     _jobData.truckType = _truckTypeController.text;
//     _jobData.tripCost = _tripCostController.text;

//     // Navigate to next screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BasicDetailsScreen(jobData: _jobData),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Generate New Job'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//             const Text(
//               'Date',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             CustomTextField(
//               controller: _dateController,
//               hintText: 'Set Job Date in Calendar',
//               prefixIcon: Icons.calendar_today,
//               onTap: () async {
//                 // Show date picker
//                 final DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     _dateController.text =
//                         "${picked.day}/${picked.month}/${picked.year}";
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             const Text(
//               'Task',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             CustomTextField(
//               controller: _taskController,
//               hintText: 'Type of Task',
//               prefixIcon: Icons.task,
//             ),
//             const SizedBox(height: 16),

//             const Text(
//               'Pickup Location',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             CustomTextField(
//               controller: _pickupLocationController,
//               hintText: 'Pickup Location',
//               prefixIcon: Icons.location_on,
//             ),
//             const SizedBox(height: 16),

//             const Text(
//               'Delivery Location',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             CustomTextField(
//               controller: _deliveryLocationController,
//               hintText: 'Delivery Location',
//               prefixIcon: Icons.location_on,
//             ),
//             const SizedBox(height: 16),

//             const Text(
//               'Truck Type',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             CustomTextField(
//               controller: _truckTypeController,
//               hintText: 'Truck Type',
//               prefixIcon: Icons.local_shipping,
//             ),
//             const SizedBox(height: 16),

//             const Text(
//               'Trip cost',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             CustomTextField(
//               controller: _tripCostController,
//               hintText: 'Truck Type',
//               prefixIcon: Icons.attach_money,
//             ),
//             const SizedBox(height: 24),

//             const Text(
//               'Now Fill The Basic Details For Job',
//               style: TextStyle(color: Colors.white, fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveAndContinue,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFF6B1A),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Continue', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
