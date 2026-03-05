import 'package:flutter/material.dart';
import 'package:karu/data/alerts_list.dart';
import 'package:karu/models/alert_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karu/screens/dashboard/widgets/alert_card.dart';
import 'package:karu/screens/dashboard/widgets/floating_action_btn.dart';
import 'package:karu/screens/dashboard/widgets/map_section.dart';
import 'package:karu/screens/dashboard/widgets/section_header.dart';
import 'package:karu/screens/dashboard/widgets/navbar_item.dart';
import 'package:karu/provider/user_alerts.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;
  late Future<void> _fetchAlertsFuture;

  // final List<AlertItem> _alerts = [
  //   AlertItem(
  //     type: AlertType.missing,
  //     name: 'Sarah J.',
  //     age: 8,
  //     duration: '2 hours',
  //     description:
  //         'Last seen wearing a yellow raincoat near Central Park entrance.',
  //     imagePlaceholder: Colors.orange.shade100,
  //   ),
  //   AlertItem(
  //     type: AlertType.silverAlert,
  //     name: 'John Doe',
  //     age: 72,
  //     duration: '5 hours',
  //     description:
  //         'Confusion/Dementia. Last seen near Downtown Library wearing a plaid shirt.',
  //     imagePlaceholder: Colors.grey.shade800,
  //   ),
  // ];

  @override
  void initState() {
    super.initState();

    // _fetchAlertsFuture = ref.read(userAlertsProvider.notifier).fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 80 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map Section
                buildMapSection(screenHeight),

                const SizedBox(height: 24),

                // Active Alerts Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 20,
                  ),
                  child: Column(
                    children: [
                      buildSectionHeader(),
                      const SizedBox(height: 16),
                      // _alertsFutureBuilder(isSmallScreen),
                      // ..._buildAlertCards(userAlerts, isSmallScreen),
                      ..._buildAlertCards(alerts, isSmallScreen),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 50 + MediaQuery.of(context).padding.bottom,
            right: 20,
            child: buildFloatingActionButton(() {
              // Handle FAB tap
              context.go('/report_missing');
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.shield, color: Colors.blue.shade700, size: 28),
          ),
        ),
      ),
      title: const Text(
        'SafeReturn',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          iconSize: 28,
          onPressed: () {
            // Handle notifications
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 24),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAlertCards(List<AlertItem> alerts, bool isSmallScreen) {
    return alerts.map((alert) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: buildAlertCard(alert, isSmallScreen, context),
      );
    }).toList();
  }

  Widget _alertsFutureBuilder(bool isSmallScreen) {
    return FutureBuilder(
      future: _fetchAlertsFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final userAlerts = ref.watch(userAlertsProvider);
            if (userAlerts.isEmpty) {
              return const Center(
                child: Text(
                  'No active alerts nearby.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return Column(
              children: _buildAlertCards(userAlerts, isSmallScreen),
            );
          // return _buildAlertsList(userAlerts);
          default:
            return const Center(
              child: Text(
                'Failed to load alerts.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              navItem(
                icon: Icons.warning_amber,
                label: 'Alerts',
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              navItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              navItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isSelected: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
