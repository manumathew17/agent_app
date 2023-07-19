import 'package:go_router/go_router.dart';
import 'package:lively_studio/screens/dashboard_screen.dart';
import 'package:lively_studio/screens/login_screen.dart';
import 'package:lively_studio/screens/spash_screen.dart';


final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashBoardScreen(),
    ),
  ],
);
