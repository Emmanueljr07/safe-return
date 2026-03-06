import 'package:flutter/material.dart';
import 'package:karu/data/alerts_list.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/screens/my_reported_cases/widgets/case_card.dart';

class MyReportedCases extends StatefulWidget {
  const MyReportedCases({super.key});

  @override
  State<MyReportedCases> createState() => _MyReportedCasesState();
}

class _MyReportedCasesState extends State<MyReportedCases> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 80 + MediaQuery.of(context).padding.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
          child: Column(children: [..._buildAlertCards(alerts, isSmallScreen)]),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      leading: BackButton(),
      title: const Text(
        'My Reported Cases',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  List<Widget> _buildAlertCards(List<AlertItem> alerts, bool isSmallScreen) {
    return alerts.map((alert) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: buildCaseCard(alert, isSmallScreen, context),
      );
    }).toList();
  }
}
