import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vms_app/features/auth/presentation/ui/widgets/custom_button.dart';
import 'package:vms_app/features/auth/presentation/ui/widgets/custom_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final bloc = sl<AuthCubit>();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  void _signUp() {
    if (_lastName.text.isNotEmpty &&
        _firstName.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _phoneNumber.text.isNotEmpty &&
        _username.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _confirmpassword.text.isNotEmpty) {
      if (_password.text != _confirmpassword.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      final formData = {
        'lastName': _lastName.text,
        'firstName': _firstName.text,
        'email': _email.text,
        'phoneNumber': _phoneNumber.text,
        'username': _username.text,
        'password': _password.text,
      };

      bloc.signup(formData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  void dispose() {
    _lastName.dispose();
    _firstName.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is AuthStateSuccessSignUp) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.success)));
            context.push('/sign-in');
          }

          if (state is AuthStateError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Error with SIGN UP')));
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          bloc: bloc,
          builder: (context, state) {
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isDesktop = constraints.maxWidth > 1200;
                  bool isTablet =
                      constraints.maxWidth > 600 &&
                      constraints.maxWidth <= 1200;
                  double maxWidth =
                      isDesktop ? 600 : constraints.maxWidth * 0.9;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop || isTablet ? 32.0 : 24.0,
                            vertical: isDesktop ? 40.0 : 20.0,
                          ),
                          child: _buildMobileTabletLayout(context, isTablet),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileTabletLayout(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: isTablet ? 40 : 60),
        Text(
          'Sign up',
          style: TextStyle(
            fontSize: isTablet ? 36 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/logo_truck.png',
          width: isTablet ? 100 : 80,
          height: isTablet ? 100 : 80,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 40),
        _buildForm(context),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                hintText: 'Last name',
                prefixIcon: Icons.person_outline,
                isPassword: false,
                controller: _lastName,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomInputField(
                hintText: 'First name',
                prefixIcon: Icons.person_outline,
                isPassword: false,
                controller: _firstName,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomInputField(
          hintText: 'abc@email.com',
          prefixIcon: Icons.mail_outline,
          isPassword: false,
          controller: _email,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          hintText: 'Phone number',
          prefixIcon: Icons.phone,
          isPassword: false,
          controller: _phoneNumber,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          hintText: 'Username',
          prefixIcon: Icons.person,
          isPassword: false,
          controller: _username,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: _password,
        ),
        const SizedBox(height: 20),
        CustomInputField(
          hintText: 'Confirm Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: _confirmpassword,
        ),
        const SizedBox(height: 20),
        CustomButton(text: 'SIGN UP', onPressed: _signUp),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(
                  color: Color(0xFF007BFF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
