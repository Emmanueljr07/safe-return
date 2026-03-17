import 'package:flutter/material.dart';
import 'package:karu/screens/dashboard/dashboard.dart';
import 'package:karu/widgets/btm_navbar_item.dart';
import 'package:karu/screens/my_reported_cases/my_reported_cases.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0; // For Bottom Navigation Section
  int pageIndex = 0; // For Pages Section

  late final pages = [
    const DashboardPage(),
    MyReportedCases(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
                onTap: () => setState(() {
                  _selectedIndex = 0;
                  pageIndex = 0;
                }),
              ),
              navItem(
                icon: Icons.warning_amber,
                label: 'Alerts',
                isSelected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                    pageIndex = 1;
                  });
                },
              ),
              navItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: _selectedIndex == 2,
                onTap: () => setState(() {
                  _selectedIndex = 2;
                  pageIndex = 2;
                }),
              ),
              navItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isSelected: _selectedIndex == 3,
                onTap: () => setState(() {
                  _selectedIndex = 3;
                  pageIndex = 3;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
