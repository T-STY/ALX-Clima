import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:alx_clima/screens/contact/contact_screen.dart';
import 'package:alx_clima/screens/dashboard/dashboard_screen.dart';
import 'package:alx_clima/screens/dashboard/equipment_detail_screen.dart';
import 'package:alx_clima/screens/dashboard/schedule_screen.dart';
import 'package:alx_clima/screens/future_services/future_services_screen.dart';
import 'package:alx_clima/screens/home/home_screen.dart';
import 'package:alx_clima/screens/profile/profile_screen.dart';
import 'package:alx_clima/screens/quote/equipment_select_screen.dart';
import 'package:alx_clima/screens/quote/installation_details_screen.dart';
import 'package:alx_clima/screens/quote/quote_summary_screen.dart';
import 'package:alx_clima/screens/quote/quote_type_screen.dart';
import 'package:alx_clima/screens/shell_screen.dart';
import 'package:alx_clima/screens/tips/care_tips_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // ── Shell Route with Bottom Navigation ──────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ShellScreen(navigationShell: navigationShell),
      branches: [
        // Tab 0: Inicio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 1: Cotizar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/quote',
              builder: (context, state) => const QuoteTypeScreen(),
            ),
          ],
        ),

        // Tab 2: Mi Equipo
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        // Tab 3: Más
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/services',
              builder: (context, state) => const FutureServicesScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Quote Flow (pushed on top of shell) ─────────────────────────
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/quote/equipment',
      builder: (context, state) => const EquipmentSelectScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/quote/installation',
      builder: (context, state) => const InstallationDetailsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/quote/summary',
      builder: (context, state) => const QuoteSummaryScreen(),
    ),

    // ── Dashboard Detail Routes ─────────────────────────────────────
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/dashboard/equipment/:id',
      builder: (context, state) => EquipmentDetailScreen(
        equipmentId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/dashboard/schedule',
      builder: (context, state) => const ScheduleScreen(),
    ),

    // ── Standalone Screens ──────────────────────────────────────────
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/tips',
      builder: (context, state) => const CareTipsScreen(),
    ),
  ],
);
