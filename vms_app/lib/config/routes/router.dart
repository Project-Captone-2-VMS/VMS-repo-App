import 'package:go_router/go_router.dart';
import 'package:vms_app/features/home/presentation/screens/home_screen.dart';
import 'package:vms_app/features/job/presentation/screens/job_detail_screen.dart';
import 'package:vms_app/features/job/presentation/screens/my_jobs_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TruckerHomeScreen()),
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
