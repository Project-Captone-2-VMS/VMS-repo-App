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
  Timer? _timer; // Sử dụng nullable Timer để tránh lỗi khi chưa khởi tạo

  @override
  void dispose() {
    _timer?.cancel(); // Chỉ hủy nếu _timer tồn tại
    super.dispose();
  }

  void _startLongPress() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // Hủy timer cũ nếu đang chạy
    }

    setState(() {
      _isLongPressing = true;
      _secondsRemaining = 3;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isLongPressing) {
        timer.cancel();
        return;
      }

      if (mounted) {
        // Kiểm tra nếu widget vẫn còn trong cây
        setState(() {
          _secondsRemaining--;
        });
      }

      if (_secondsRemaining <= 0) {
        _navigateToNextScreen();
        timer.cancel();
        if (mounted) {
          // Kiểm tra nếu widget vẫn còn trong cây
          setState(() {
            _isLongPressing = false;
          });
        }
      }
    });
  }

  void _endLongPress() {
    setState(() {
      _isLongPressing = false;
      _secondsRemaining = 3;
    });
    _timer?.cancel(); // Hủy timer nếu tồn tại
  }

  void _navigateToNextScreen() {
    context.push('/problem-detail');
  }

  void _handleTap() {
    // Xử lý khi nhấn ngắn (tap)
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 200),
        Icon(Icons.warning_rounded, size: 64, color: AppTheme.primaryColor),
        const SizedBox(height: 20),
        Text(
          'Send Alert',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _isLongPressing
              ? 'Send problem after: $_secondsRemaining...'
              : 'Send issue with a single tap, hold it for 3 seconds.',
          style: GoogleFonts.poppins(fontSize: 16, color: AppTheme.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onLongPress: _startLongPress,
          onLongPressUp: _endLongPress,
          child: ElevatedButton(
            onPressed: _handleTap, // Xử lý nhấn ngắn
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
              _isLongPressing
                  ? 'Hold for $_secondsRemaining...'
                  : 'Please hold!',
              style: TextStyle(color: AppTheme.white),
            ),
          ),
        ),
      ],
    );
  }
}
