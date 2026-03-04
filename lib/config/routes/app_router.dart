import 'package:contraktor/features/artisan/presentation/screens/artisans_screen.dart';
import 'package:contraktor/features/splash_screen.dart';
import 'package:go_router/go_router.dart';

// import '../../features/auth/presentation/pages/forgot_password_page.dart';

// Home
// import '../../features/home/presentation/pages/home_page.dart';

// Profile
// import '../../features/profile/presentation/pages/profile_page.dart';
// import '../../features/profile/presentation/pages/edit_profile_page.dart';

// Messages
// import '../../features/messages/presentation/pages/messages_page.dart';
// import '../../features/messages/presentation/pages/chat_page.dart';

// Jobs
// import '../../features/jobs/presentation/pages/jobs_page.dart';
// import '../../features/jobs/presentation/pages/job_details_page.dart';
// import '../../features/jobs/presentation/pages/create_job_page.dart';

// Wallet
// import '../../features/wallet/presentation/pages/wallet_page.dart';
// import '../../features/wallet/presentation/pages/transaction_history_page.dart';

// Settings
// import '../../features/settings/presentation/pages/settings_page.dart';

// Search
// import '../../features/search/presentation/pages/search_page.dart';

class AppRouter {
  // ========== ROUTE NAMES ==========
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String clientWelcome = '/clientWelcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String appNav = '/app-nav';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main App
  static const String clientHomepage = '/client-homepage';
  static const String home = '/home';
  static const String search = '/search';
  static const String messages = '/messages';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Jobs
  static const String jobs = '/jobs';
  static const String jobDetails = '/job-details';
  static const String createJob = '/create-job';
  static const String editJob = '/edit-job';
  static const String proposals = '/proposals';

  // Wallet
  static const String wallet = '/wallet';
  static const String transactionHistory = '/transaction-history';
  static const String addFunds = '/add-funds';
  static const String withdrawFunds = '/withdraw-funds';

  // Profile & Settings
  static const String accountSettings = '/account-settings';
  static const String security = '/security';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String about = '/about';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    // errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const ArtisansScreen(),
      ),
    ],
    //     GoRoute(
    //       path: onboarding,
    //       name: 'onboarding',
    //       builder: (context, state) => const Onboardingpage(),
    //     ),

    //     GoRoute(
    //       path: welcome,
    //       name: 'welcome',
    //       builder: (context, state) => const Welcomescreen(),
    //     ),

    //     // ========== AUTHENTICATION ==========
    //     GoRoute(
    //       path: clientWelcome,
    //       name: 'clientWelcome',
    //       builder: (context, state) => const ClientWelcome(),
    //     ),

    //     GoRoute(
    //       path: login,
    //       name: 'login',
    //       builder: (context, state) => const Login(),
    //     ),

    //     GoRoute(
    //       path: register,
    //       name: 'register',
    //       builder: (context, state) => const Register(),
    //     ),

    //     GoRoute(
    //       path: clientHomepage,
    //       name: 'client-homepage',
    //       builder: (context, state) => const ClientHomepage(),
    //     ),

    //     GoRoute(
    //       path: appNav,
    //       name: 'app-nav',
    //       builder: (context, state) => const AppNav(),
    //     ),

    //     // GoRoute(
    //     //   path: forgotPassword,
    //     //   name: 'forgotPassword',
    //     //   builder: (context, state) => const ForgotPasswordPage(),
    //     // ),

    //     // GoRoute(
    //     //   path: resetPassword,
    //     //   name: 'resetPassword',
    //     //   builder: (context, state) {
    //     //     final token = state.uri.queryParameters['token'] ?? '';
    //     //     return ResetPasswordPage(token: token);
    //     //   },
    //     // ),

    //     // ========== HOME (with bottom nav) ==========
    //     // GoRoute(
    //     //   path: home,
    //     //   name: 'home',
    //     //   builder: (context, state) => const HomePage(),
    //     // ),

    //     // // ========== SEARCH ==========
    //     // GoRoute(
    //     //   path: search,
    //     //   name: 'search',
    //     //   builder: (context, state) {
    //     //     final query = state.uri.queryParameters['query'] ?? '';
    //     //     return SearchPage(initialQuery: query);
    //     //   },
    //     // ),

    //     // // ========== MESSAGES ==========
    //     // GoRoute(
    //     //   path: messages,
    //     //   name: 'messages',
    //     //   builder: (context, state) => const MessagesPage(),
    //     //   routes: [
    //     //     GoRoute(
    //     //       path: 'chat/:chatId',
    //     //       name: 'chat',
    //     //       builder: (context, state) {
    //     //         final chatId = state.pathParameters['chatId']!;
    //     //         final userName = state.uri.queryParameters['userName'] ?? 'User';
    //     //         return ChatPage(chatId: chatId, userName: userName);
    //     //       },
    //     //     ),
    //     //   ],
    //     // ),

    //     // // ========== JOBS ==========
    //     // GoRoute(
    //     //   path: jobs,
    //     //   name: 'jobs',
    //     //   builder: (context, state) => const JobsPage(),
    //     //   routes: [
    //     //     GoRoute(
    //     //       path: 'details/:jobId',
    //     //       name: 'jobDetails',
    //     //       builder: (context, state) {
    //     //         final jobId = state.pathParameters['jobId']!;
    //     //         return JobDetailsPage(jobId: jobId);
    //     //       },
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'create',
    //     //       name: 'createJob',
    //     //       builder: (context, state) => const CreateJobPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'edit/:jobId',
    //     //       name: 'editJob',
    //     //       builder: (context, state) {
    //     //         final jobId = state.pathParameters['jobId']!;
    //     //         return EditJobPage(jobId: jobId);
    //     //       },
    //     //     ),
    //     //     GoRoute(
    //     //       path: ':jobId/proposals',
    //     //       name: 'proposals',
    //     //       builder: (context, state) {
    //     //         final jobId = state.pathParameters['jobId']!;
    //     //         return ProposalsPage(jobId: jobId);
    //     //       },
    //     //     ),
    //     //   ],
    //     // ),

    //     // // ========== WALLET ==========
    //     // GoRoute(
    //     //   path: wallet,
    //     //   name: 'wallet',
    //     //   builder: (context, state) => const WalletPage(),
    //     //   routes: [
    //     //     GoRoute(
    //     //       path: 'history',
    //     //       name: 'transactionHistory',
    //     //       builder: (context, state) => const TransactionHistoryPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'add-funds',
    //     //       name: 'addFunds',
    //     //       builder: (context, state) => const AddFundsPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'withdraw',
    //     //       name: 'withdrawFunds',
    //     //       builder: (context, state) => const WithdrawFundsPage(),
    //     //     ),
    //     //   ],
    //     // ),

    //     // // ========== PROFILE ==========
    //     // GoRoute(
    //     //   path: profile,
    //     //   name: 'profile',
    //     //   builder: (context, state) {
    //     //     final userId = state.uri.queryParameters['userId'];
    //     //     return ProfilePage(userId: userId);
    //     //   },
    //     //   routes: [
    //     //     GoRoute(
    //     //       path: 'edit',
    //     //       name: 'editProfile',
    //     //       builder: (context, state) => const EditProfilePage(),
    //     //     ),
    //     //   ],
    //     // ),

    //     // ========== SETTINGS ==========
    //     // GoRoute(
    //     //   path: settings,
    //     //   name: 'settings',
    //     //   builder: (context, state) => const SettingsPage(),
    //     //   routes: [
    //     //     GoRoute(
    //     //       path: 'account',
    //     //       name: 'accountSettings',
    //     //       builder: (context, state) => const AccountSettingsPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'security',
    //     //       name: 'security',
    //     //       builder: (context, state) => const SecurityPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'notifications',
    //     //       name: 'notifications',
    //     //       builder: (context, state) => const NotificationSettingsPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'support',
    //     //       name: 'support',
    //     //       builder: (context, state) => const SupportPage(),
    //     //     ),
    //     //     GoRoute(
    //     //       path: 'about',
    //     //       name: 'about',
    //     //       builder: (context, state) => const AboutPage(),
    //     //     ),
    //     //   ],
    //     // ),
    //   ],

    //   // ========== REDIRECT LOGIC (Optional - for auth) ==========
    //   // redirect: (context, state) {
    //   //   final isLoggedIn = false; // Replace with actual auth check
    //   //   final isOnboarded = true; // Replace with actual onboarding check
    //   //
    //   //   final isGoingToAuth = state.matchedLocation == login ||
    //   //                         state.matchedLocation == register;
    //   //   final isGoingToOnboarding = state.matchedLocation == onboarding;
    //   //
    //   //   // If not logged in and not going to auth pages, redirect to login
    //   //   if (!isLoggedIn && !isGoingToAuth && !isGoingToOnboarding) {
    //   //     return login;
    //   //   }
    //   //
    //   //   // If not onboarded and logged in, redirect to onboarding
    //   //   if (isLoggedIn && !isOnboarded && !isGoingToOnboarding) {
    //   //     return onboarding;
    //   //   }
    //   //
    //   //   // If logged in and going to auth pages, redirect to home
    //   //   if (isLoggedIn && isGoingToAuth) {
    //   //     return home;
    //   //   }
    //   //
    //   //   return null; // No redirect needed
    //   // },
  );
}
