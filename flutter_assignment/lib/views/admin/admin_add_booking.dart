import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/viewmodels/admin/booking_management/admin_add_booking_viewmodel.dart';
import 'package:flutter_assignment/routes.dart'; // Adjust the path as necessary

class AdminAddAppointment extends StatefulWidget {
  final String sellerUid;
  final String adopterUid;
  final String petUid;

  const AdminAddAppointment(
      {super.key,
      required this.sellerUid,
      required this.adopterUid,
      required this.petUid});

  @override
  AdminAddAppointmentState createState() => AdminAddAppointmentState();
}

class AdminAddAppointmentState extends State<AdminAddAppointment> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AppointmentViewModel>(context, listen: false);
      viewModel.fetchPetDetails(widget.petUid);
      viewModel.fetchSellerDetails(widget.sellerUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 47, 131, 240),
        title: const Text('Add Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AppointmentViewModel>(
          builder: (context, appointmentViewModel, child) {
            return SingleChildScrollView(
              child: Form(
                key: appointmentViewModel.formKeyInstance,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: widget.sellerUid,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Seller UID',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // if (appointmentViewModel.sellerDetails != null)
                    //   TextFormField(
                    //     initialValue: appointmentViewModel.sellerDetails?.phoneNumber ?? '',
                    //     readOnly: true,
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'Seller Phone Number',
                    //     ),
                    //   ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.adopterUid,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adopter UID',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.petUid,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pet UID',
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (appointmentViewModel.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (appointmentViewModel.petDetails != null) ...[
                      ExpansionTile(
                        title: const Text("View More Details about pet"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: appointmentViewModel
                                                    .petDetails!.imageUrl !=
                                                null &&
                                            appointmentViewModel.petDetails!
                                                .imageUrl!.isNotEmpty
                                        ? Image.network(
                                            appointmentViewModel
                                                .petDetails!.imageUrl!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/default_profile.png', // Default image asset path
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue:
                                      appointmentViewModel.petDetails!.petName,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pet Name',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue:
                                      appointmentViewModel.petDetails!.species,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pet Species',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue:
                                      appointmentViewModel.petDetails!.location,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pet Location',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: appointmentViewModel
                                      .petDetails!.description,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pet Description',
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue:
                                      appointmentViewModel.petDetails!.fee,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pet Fee',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue:
                                      appointmentViewModel.petDetails!.purpose,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pet Purpose',
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else
                      const Text('No pet details available.'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: appointmentViewModel.dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Appointment Date",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an appointment date';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          appointmentViewModel.dateController.text =
                              formattedDate;
                        }
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: appointmentViewModel.timeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Appointment Time",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an appointment time';
                        }
                        return null;
                      },
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          String formattedTime = pickedTime.format(context);
                          appointmentViewModel.timeController.text =
                              formattedTime;
                        }
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: appointmentViewModel.notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: appointmentViewModel.isLoading
                              ? null
                              : () async {
                                  if (appointmentViewModel
                                      .formKeyInstance.currentState!
                                      .validate()) {
                                    try {
                                      await appointmentViewModel.submitBooking(
                                        widget.sellerUid,
                                        widget.adopterUid,
                                        appointmentViewModel.petDetails!,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Booking added successfully!')),
                                      );
                                      Navigator.pushReplacementNamed(context,
                                          AppRoutes.adminAppoManagement);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to add appointment: $e')),
                                      );
                                    }
                                  }
                                },
                          child: appointmentViewModel.isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text('ADD'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
