import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karu/screens/dashboard/dashboard.dart';
import 'package:karu/screens/report_missing/report_missing_page.dart';
import 'package:karu/screens/live_status/live_qr_status.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'report_missing',
          builder: (BuildContext context, GoRouterState state) {
            return const ReportMissingPage();
          },
        ),
        // Live QR Status route
        GoRoute(
          path: 'livestatus/:id',
          builder: (BuildContext context, GoRouterState state) {
            return LiveQrStatus(alertId: state.pathParameters['id'] ?? '');
          },
        ),
      ],
    ),
  ],
);
