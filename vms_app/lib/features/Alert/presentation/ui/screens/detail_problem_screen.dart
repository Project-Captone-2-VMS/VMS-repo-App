import 'package:flutter/material.dart';
import '../widgets/map_section.dart';
import '../widgets/form_field_item.dart';
import '../widgets/action_buttons.dart';

class DetailProblemScreen extends StatelessWidget {
  const DetailProblemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Problem',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MapSection(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What issue do you meet?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  FormFieldItem(
                    value: '537',
                    icon: Icons.location_on_outlined,
                    onEdit: () {
                      // Handle edit action
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  FormFieldItem(
                    value: 'Paper Street',
                    icon: Icons.location_on_outlined,
                    onEdit: () {
                      // Handle edit action
                    },
                  ),
                ],
              ),
            ),
            const ActionButtons(),
          ],
        ),
      ),
    );
  }
}
