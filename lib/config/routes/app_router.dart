import 'package:contraktor/features/admin/presentation/screens/admin_insights.dart';
import 'package:contraktor/features/artisan/presentation/screens/artisan_profile_screen.dart';
import 'package:contraktor/features/artisan/presentation/screens/artisans_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/home';
  static const String artisanProfile = '/artisan-profile/:id';
  static const String admin = '/admin';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const ArtisansScreen(),
      ),
      GoRoute(
        path: artisanProfile,
        name: 'artisan-profile',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ArtisanProfileScreen(artisanId: id);
        },
      ),
      GoRoute(
        path: admin,
        name: 'admin',
        builder: (context, state) => const AdminInsights(),
      ),
    ],
  );
}
