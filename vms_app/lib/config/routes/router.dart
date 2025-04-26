import 'package:go_router/go_router.dart';
import 'package:vms_app/features/Alert/presentation/ui/screens/detail_problem_screen.dart';
import 'package:vms_app/features/auth/presentation/ui/screens/register/sign_up_screen.dart';
import 'package:vms_app/features/auth/presentation/ui/screens/signin/sign_in_screen.dart';
import 'package:vms_app/features/entry/screens/main_navigation.dart';
import 'package:vms_app/features/entry/screens/splash_screen.dart';
import 'package:vms_app/features/history/presentation/ui/screens/history_screen.dart';
import 'package:vms_app/features/home/presentation/ui/screens/home_screen.dart';
import 'package:vms_app/features/job/data/models/job_model.dart' as job_model;
import 'package:vms_app/features/job/presentation/ui/screens/edit-route/route_editor_screen.dart';
// import 'package:vms_app/features/home/presentation/ui/screens/home_screen.dart';
import 'package:vms_app/features/job/presentation/ui/screens/job_detail_screen.dart';
import 'package:vms_app/features/job/presentation/ui/screens/my_jobs_screen.dart';
import 'package:vms_app/features/job/presentation/ui/screens/route-navigation/navigation_route_screen.dart';
import 'package:vms_app/features/location/ui/screens/location_screen.dart';
import 'package:vms_app/features/notification/presentation/ui/screens/notification_screen.dart';
import 'package:vms_app/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:vms_app/features/profile/presentation/ui/screens/update_driver_info_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainNavigation()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(path: '/sign-up', builder: (context, state) => SignUpScreen()),
    GoRoute(
      path: '/my-jobs',
      builder: (context, state) => const MyJobsScreen(),
    ),
    GoRoute(
      path: '/job-detail',
      builder: (context, state) => const JobDetailScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(path: '/location', builder: (context, state) => LocationScreen()),
    GoRoute(
      path: '/problem-detail',
      builder: (context, state) => DetailProblemScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationsPage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
    GoRoute(
      path: '/update-profile',
      builder: (context, state) => UpdateDriverInfoScreen(),
    ),
    GoRoute(
      path: '/route-editor',
      builder: (context, state) => RouteEditorScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => TruckerHomeScreen()),
    GoRoute(
      path: '/navigation-screen',
      builder: (context, state) {
        final jobDetail = state.extra as job_model.Route?;
        return NavigationScreen(jobDetail: jobDetail);
      },
    ),
  ],
);
