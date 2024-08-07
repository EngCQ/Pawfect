import 'package:flutter/material.dart';
import 'package:flutter_assignment/viewmodels/admin/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter_assignment/widgets/drawer_admin.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthentication>(context);
    final userDetails = userAuth.userDetails ?? {};
    final userEmail = userDetails['email'] ?? 'User';

    final adminDashboardViewModel = Provider.of<AdminDashboardViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Dashboard'),
        actions: [
          Row(
            children: [
              Text(
                userEmail,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const DrawerAdmin(currentRoute: '/adminDashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<Map<String, int>>(
              stream: adminDashboardViewModel.getTotalAdoptersAndSellers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DashboardCard(
                    title: 'Total Users:',
                    data: 'Loading...',
                    chart: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const DashboardCard(
                    title: 'Total Users:',
                    data: 'Error',
                    chart: Icon(Icons.error, color: Colors.red),
                  );
                }

                final data = snapshot.data ?? {'Adopters': 0, 'Sellers': 0};
                final totalUsers = data['Adopters']! + data['Sellers']!;

                return DashboardCard(
                  title: 'Total Users: $totalUsers',
                  //data: 'Total: ',
                  chart: Column(
                    children: [
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.center,
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: data['Adopters']!.toDouble(),
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                  BarChartRodData(
                                    toY: data['Sellers']!.toDouble(),
                                    color: Colors.orange,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.blue, size: 10),
                              SizedBox(width: 4),
                              Text('Adopters', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.orange, size: 10),
                              SizedBox(width: 4),
                              Text('Sellers', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ), data: '',
                );
              },
            ),
            StreamBuilder<Map<String, int>>(
              stream: adminDashboardViewModel.getTotalAdoptionAndLostPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DashboardCard(
                    title: 'Total Pets:',
                    data: 'Loading...',
                    chart: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const DashboardCard(
                    title: 'Total Pets:',
                    data: 'Error',
                    chart: Icon(Icons.error, color: Colors.red),
                  );
                }

                final data = snapshot.data ?? {'Adoption': 0, 'Lost': 0};
                final totalPets = data['Adoption']! + data['Lost']!;

                return DashboardCard(
                  title: 'Total Pets: $totalPets',
                  //data: 'Total: ',
                  chart: Column(
                    children: [
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.center,
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: data['Adoption']!.toDouble(),
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                  BarChartRodData(
                                    toY: data['Lost']!.toDouble(),
                                    color: Colors.orange,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.blue, size: 10),
                              SizedBox(width: 4),
                              Text('Adoption', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.orange, size: 10),
                              SizedBox(width: 4),
                              Text('Lost', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ), data: '',
                );
              },
            ),
            
            StreamBuilder<int>(
              stream: adminDashboardViewModel.getTotalAppointments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DashboardCard(
                    title: 'Total Appointments:',
                    data: 'Loading...',
                    chart: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const DashboardCard(
                    title: 'Total Appointments:',
                    data: 'Error',
                    chart: Icon(Icons.error, color: Colors.red),
                  );
                }
                final totalAppointments = snapshot.data ?? 0;
                return DashboardCard(
                  title: 'Total Appointments: $totalAppointments',
                  data: '',
                  chart: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: snapshot.data!.toDouble(),
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            StreamBuilder<int>(
              stream: adminDashboardViewModel.getTotalFeedbacks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DashboardCard(
                    title: 'Total Feedbacks: ',
                    data: 'Loading...',
                    chart: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const DashboardCard(
                    title: 'Total Feedbacks:',
                    data: 'Error',
                    chart: Icon(Icons.error, color: Colors.red),
                  );
                }
                final totalFeedbacks = snapshot.data ?? 0;
                return DashboardCard(
                  title: 'Total Feedbacks: $totalFeedbacks',
                  data: '',
                  chart: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: snapshot.data!.toDouble(),
                          title: snapshot.data.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _generatePdfReport(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0583CB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'CREATE REPORT',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdfReport(BuildContext context) async {
    final pdf = pw.Document();

    final adminDashboardViewModel = Provider.of<AdminDashboardViewModel>(context, listen: false);

    final totalUsers = await adminDashboardViewModel.getTotalUsers().first;
    final totalPetsAdded = await adminDashboardViewModel.getTotalPetsAdded().first;
    final totalAppointments = await adminDashboardViewModel.getTotalAppointments().first;
    final totalFeedbacks = await adminDashboardViewModel.getTotalFeedbacks().first;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Admin Dashboard Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Total Users: $totalUsers', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Total Pets Added: $totalPetsAdded', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Total Appointments: $totalAppointments', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Total Feedbacks: $totalFeedbacks', style: const pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF report generated successfully!'),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final String data;

  const DashboardCard({
    super.key,
    required this.title,
    required this.chart,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white, // Set background color based on the theme
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black, // Set text color based on the theme
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black, // Set text color based on the theme
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }
}
