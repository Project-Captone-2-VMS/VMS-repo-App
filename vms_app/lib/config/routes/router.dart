import 'package:go_router/go_router.dart';
import 'package:vms_app/features/entry/screens/main_navigation.dart';
import 'package:vms_app/features/entry/screens/splash_screen.dart';
import 'package:vms_app/features/home/presentation/ui/screens/home_screen.dart';
import 'package:vms_app/features/job/presentation/ui/screens/job_detail_screen.dart';
import 'package:vms_app/features/job/presentation/ui/screens/my_jobs_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainNavigation()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/my-jobs',
      builder: (context, state) => const MyJobsScreen(),
    ),
    GoRoute(
      path: '/job-detail',
      builder: (context, state) => const JobDetailScreen(),
    ),
  ],
);
