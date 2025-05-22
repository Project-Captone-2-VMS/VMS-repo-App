import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/home/home.dart';
import 'package:vms_app/features/profile/profile.dart';

class UpdateDriverInfoScreen extends StatefulWidget {
  const UpdateDriverInfoScreen({super.key});

  @override
  _UpdateDriverInfoScreenState createState() => _UpdateDriverInfoScreenState();
}

class _UpdateDriverInfoScreenState extends State<UpdateDriverInfoScreen> {
  final bloc = sl<ProfileCubit>();
  final _formKey = GlobalKey<FormState>();
  late Result data;
  String? token;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _workScheduleController = TextEditingController();

  final List<String> _statusOptions = ['Active', 'Inactive', 'On Leave'];
  String? _selectedStatus;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = GoRouterState.of(context).extra as Result;
  }

  Future<void> _getRoute() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    if (token == null) {
      _logger.e("Token Null");
      return;
    }

    bloc.getDriverById(data.id, token!);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final driverData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'license_number': _licenseController.text,
        'work_schedule': _workScheduleController.text,
      };

      bloc.updateDriverById(data.id, driverData, token!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Driver information updated successfully'),
        ),
      );

      print('Updated driver data: $driverData');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _workScheduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Update Driver Information',
          style: AppTextStyles.appbarText,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: BlocBuilder<ProfileCubit, ProfileState>(
                bloc: bloc,
                builder: (context, state) {
                  if (state is ProfileStateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileStateSuccess) {
                    final data = state.data;
                    _firstNameController.text = state.data['firstName'] ?? '';
                    _lastNameController.text = state.data['lastName'] ?? '';
                    _emailController.text = state.data['email'] ?? '';
                    _phoneController.text = state.data['phoneNumber'] ?? '';
                    _licenseController.text = state.data['licenseNumber'] ?? '';
                    _workScheduleController.text =
                        state.data['workSchedule'] ?? '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage:
                                      _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                          : null,
                                  child:
                                      _selectedImage == null
                                          ? Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.grey[600],
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap avatar to change photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Driver ID: ${data['driverId']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_pin),
                          ),
                          items:
                              _statusOptions.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select a status'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter first name'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter last name'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Professional Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _licenseController,
                          decoration: const InputDecoration(
                            labelText: 'License Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.card_membership),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter license number'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _workScheduleController,
                          decoration: const InputDecoration(
                            labelText: 'Work Schedule',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.schedule),
                            hintText: 'e.g., Mon-Fri, 9AM-5PM',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter work schedule'
                                      : null,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Update Driver Information',
                              style: AppTextStyles.button,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  } else if (state is ProfileStateError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
