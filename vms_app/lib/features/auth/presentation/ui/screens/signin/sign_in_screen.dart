import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vms_app/features/auth/presentation/ui/widgets/custom_button.dart';
import 'package:vms_app/features/auth/presentation/ui/widgets/custom_input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final bloc = sl<AuthCubit>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void _login() {
    if (_username.text.isNotEmpty && _password.text.isNotEmpty) {
      final formData = {'username': _username.text, 'password': _password.text};
      bloc.signin(formData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is AuthStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthStateSuccess) {
            final result = state.loginSuccess;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (result.roles.first == 'ADMIN') {
                context.push('/history', extra: result.token);
              } else {
                context.push('/my-jobs', extra: result.token);
              }
            });
          }

          if (state is AuthStateError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error with SIGN IN')),
              );
            });
          }

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Xác định loại thiết bị dựa trên chiều rộng
                bool isDesktop = constraints.maxWidth > 1200;
                bool isTablet =
                    constraints.maxWidth > 600 && constraints.maxWidth <= 1200;
                double maxWidth = isDesktop ? 600 : constraints.maxWidth * 0.9;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop || isTablet ? 32.0 : 24.0,
                          vertical: isDesktop ? 40.0 : 20.0,
                        ),
                        child:
                            isDesktop
                                ? _buildDesktopLayout(context)
                                : _buildMobileTabletLayout(context, isTablet),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Layout cho Desktop
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần hình ảnh bên trái
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_truck.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Phần form đăng nhập bên phải
        Expanded(child: _buildForm(context)),
      ],
    );
  }

  // Layout cho Mobile và Tablet
  Widget _buildMobileTabletLayout(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: isTablet ? 40 : 60),
        Text(
          'Sign in',
          style: TextStyle(
            fontSize: isTablet ? 36 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/logo_truck.png',
          width: isTablet ? 200 : 150,
          height: isTablet ? 200 : 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 40),
        Text(
          'Good to see you again!',
          style: TextStyle(
            fontSize: isTablet ? 28 : 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        _buildForm(context),
      ],
    );
  }

  // Form đăng nhập chung
  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          hintText: 'abc@email.com',
          prefixIcon: Icons.mail_outline,
          isPassword: false,
          controller: _username,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          hintText: 'Your password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: _password,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              context.push('/forgot-password');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(text: 'SIGN IN', onPressed: _login),
        const SizedBox(height: 16),
        const Text(
          'OR',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: Colors.black12),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_google.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Login with Google',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Don\'t have an account? ',
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () {
                context.push('/sign-up');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Sign up',
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
