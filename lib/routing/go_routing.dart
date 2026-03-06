import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karu/screens/my_reported_cases/my_reported_cases.dart';
import 'package:karu/screens/report_missing/report_missing_page.dart';
import 'package:karu/screens/live_status/live_qr_status.dart';
import 'package:karu/screens/tabs.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TabsScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'report_missing',
          builder: (BuildContext context, GoRouterState state) {
            return const ReportMissingPage();
          },
        ),
        // My reported cases route
        GoRoute(
          path: 'my_reported_cases',
          builder: (BuildContext context, GoRouterState state) {
            return const MyReportedCases();
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
