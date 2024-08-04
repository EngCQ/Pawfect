import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_assignment/widgets/drawer_admin.dart';

class AdminBookingManagement extends StatefulWidget {
  const AdminBookingManagement({super.key});

  @override
  AdminBookingManagementState createState() => AdminBookingManagementState();
}

class AdminBookingManagementState extends State<AdminBookingManagement> {
  bool isActiveBookingsSelected = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Bookings'),
        actions: const [
          Row(
            children: [
              Text(
                'Admin',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      drawer: const DrawerAdmin(currentRoute: '/adminBookingManagement'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToggleButtons(
                isSelected: [isActiveBookingsSelected, !isActiveBookingsSelected],
                onPressed: (index) {
                  setState(() {
                    isActiveBookingsSelected = index == 0;
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Active Bookings'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Completed Bookings'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total ${isActiveBookingsSelected ? 'Active Bookings' : 'Completed Bookings'}: 0', // Placeholder text
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.blue,
                              value: 0, // Placeholder value
                              title: 'Active',
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.orange,
                              value: 0, // Placeholder value
                              title: 'Completed',
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigator.push to the Add Booking screen
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('ADD'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by booking ID or status',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: 0, // Placeholder count
                  itemBuilder: (context, index) {
                    // Placeholder data
                    final bookingId = 'ID';
                    final bookingStatus = 'Status';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(
                            bookingId.substring(0, 2).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('Booking $bookingId'), // Placeholder text
                        subtitle: Text('Status: $bookingStatus'), // Placeholder text
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navigator.push to the Edit Booking screen
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
