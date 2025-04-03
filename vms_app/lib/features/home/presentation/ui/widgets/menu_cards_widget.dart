import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vms_app/config/theme/app_theme.dart';

class MenuCardsWidget extends StatelessWidget {
  const MenuCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 3,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 179, 178, 178),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                MenuCardItem(
                  icon: Icons.add_circle_outline,
                  iconColor: Colors.purple,
                  title: 'New Job',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                MenuCardItem(
                  icon: Icons.person_outline,
                  iconColor: Colors.orange,
                  title: 'Assign Driver',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                MenuCardItem(
                  icon: Icons.history,
                  iconColor: Colors.pink,
                  title: 'History',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                MenuCardItem(
                  icon: Icons.work_outline,
                  iconColor: Colors.red,
                  title: 'My Jobs',
                  onTap: () => context.push('/my-jobs'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                MenuCardItem(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: Colors.green,
                  title: 'Expenses',
                  onTap: () {},
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCardItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const MenuCardItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Click here for details and navigation options',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
