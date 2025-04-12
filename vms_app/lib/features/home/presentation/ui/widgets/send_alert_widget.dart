import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vms_app/config/theme/app_theme.dart';

class SendAlertWidget extends StatefulWidget {
  const SendAlertWidget({super.key});

  @override
  State<SendAlertWidget> createState() => _SendAlertWidgetState();
}

class _SendAlertWidgetState extends State<SendAlertWidget> {
  bool _isLongPressing = false;
  int _secondsRemaining = 3;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startLongPress() {
    setState(() {
      _isLongPressing = true;
      _secondsRemaining = 3;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isLongPressing) {
        setState(() {
          _secondsRemaining--;
        });
        if (_secondsRemaining <= 0) {
          _navigateToNextScreen();
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _endLongPress() {
    setState(() {
      _isLongPressing = false;
    });
    _timer.cancel();
  }

  void _navigateToNextScreen() {
    context.push('/problem-detail');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 200),
        Icon(Icons.warning_rounded, size: 64, color: AppTheme.primaryColor),
        SizedBox(height: 20),
        Text(
          'Send Alert',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        SizedBox(height: 14),
        Text(
          _isLongPressing
              ? 'Send problem after: $_secondsRemaining...'
              : 'Send issue with a single tap, hold it for 3 seconds.',
          style: GoogleFonts.poppins(fontSize: 16, color: AppTheme.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        GestureDetector(
          onLongPress: _startLongPress,
          onLongPressUp: _endLongPress,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              backgroundColor:
                  _isLongPressing
                      ? AppTheme.primaryColor.withOpacity(0.7)
                      : AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Please hold!',
              style: TextStyle(color: AppTheme.white),
            ),
          ),
        ),
      ],
    );
  }
}
