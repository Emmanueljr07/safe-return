import 'package:flutter/material.dart';
import 'package:karu/data/alerts_list.dart';
// import 'package:karu/models/alert_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:karu/screens/dashboard/widgets/alert_card.dart';
import 'package:karu/screens/dashboard/widgets/build_case_card.dart';
import 'package:karu/screens/dashboard/widgets/floating_action_btn.dart';
// import 'package:karu/screens/dashboard/widgets/map_section.dart';
// import 'package:karu/screens/dashboard/widgets/section_header.dart';
// import 'package:karu/provider/user_alerts.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  // late Future<void> _fetchAlertsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _fetchAlertsFuture = ref.read(userAlertsProvider.notifier).fetchAlerts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Section
            // buildMapSection(screenHeight),

            // Search Bar
            _buildSearchBar(isSmallScreen),

            // Cases Grid
            Expanded(child: _buildCasesGrid(screenWidth, isSmallScreen)),

            // Active Alerts Section
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: isSmallScreen ? 16 : 20,
            //   ),
            //   child: Column(
            //     children: [
            //       buildSectionHeader(),
            //       const SizedBox(height: 16),
            //       // _alertsFutureBuilder(isSmallScreen),
            //       // ..._buildAlertCards(userAlerts, isSmallScreen),
            //       ..._buildAlertCards(alerts, isSmallScreen),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: buildFloatingActionButton(() {
        // Handle FAB tap
        context.go('/report_missing');
      }),
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

  Widget _buildSearchBar(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by name or location',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  // List<Widget> _buildAlertCards(List<AlertItem> alerts, bool isSmallScreen) {
  //   return alerts.map((alert) {
  //     return Padding(
  //       padding: const EdgeInsets.only(bottom: 16),
  //       child: buildAlertCard(alert, isSmallScreen, context),
  //     );
  //   }).toList();
  // }

  // Widget _alertsFutureBuilder(bool isSmallScreen) {
  //   return FutureBuilder(
  //     future: _fetchAlertsFuture,
  //     builder: (context, snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return const Center(child: CircularProgressIndicator());
  //         case ConnectionState.done:
  //           final userAlerts = ref.watch(userAlertsProvider);
  //           if (userAlerts.isEmpty) {
  //             return const Center(
  //               child: Text(
  //                 'No active alerts nearby.',
  //                 style: TextStyle(fontSize: 16, color: Colors.grey),
  //               ),
  //             );
  //           }
  //           return Column(
  //             children: _buildAlertCards(userAlerts, isSmallScreen),
  //           );
  //         // return _buildAlertsList(userAlerts);
  //         default:
  //           return const Center(
  //             child: Text(
  //               'Failed to load alerts.',
  //               style: TextStyle(fontSize: 16, color: Colors.red),
  //             ),
  //           );
  //       }
  //     },
  //   );
  // }

  Widget _buildCasesGrid(double screenWidth, bool isSmallScreen) {
    // Calculate number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isSmallScreen ? 12 : 16,
        mainAxisSpacing: isSmallScreen ? 12 : 16,
        childAspectRatio: 0.7,
      ),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return buildCaseCard(alerts[index], context);
      },
    );
  }
}
