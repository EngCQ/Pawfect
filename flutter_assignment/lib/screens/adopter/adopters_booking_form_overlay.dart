import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptersBookingFormOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final String postName;
  final String postImage;
  final String postPetName;
  final String postType;
  final String postDescription;
  final String postSellerUid;
  final String userUid; // Ensure userUid is handled

  const AdoptersBookingFormOverlay({
    Key? key,
    required this.onClose,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postType,
    required this.postDescription,
    required this.postSellerUid,
    required this.userUid, // Initialize userUid in the constructor
  }) : super(key: key);

  @override
  _AdoptersBookingFormOverlayState createState() =>
      _AdoptersBookingFormOverlayState();
}

class _AdoptersBookingFormOverlayState
    extends State<AdoptersBookingFormOverlay> {
  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String? _validatePhoneNumber(String? value) {
    final RegExp regex = RegExp(r'^\d{9,10}$');
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateDate() {
    if (_selectedDate == null) {
      return 'Please select a date';
    }
    return null;
  }

  String? _validateTime() {
    if (_selectedTime == null) {
      return 'Please select a time';
    }
    return null;
  }

  String? _validateNotes(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some notes';
    }
    return null;
  }

  Future<void> _saveBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Reference to Firestore collection
        CollectionReference bookingsCollection =
            FirebaseFirestore.instance.collection('bookings');

        // Add document with booking details
        await bookingsCollection.add({
          'userUid': widget.userUid, // Use widget.userUid here
          'postSellerUid': widget.postSellerUid,
          'postName': widget.postName,
          'postImage': widget.postImage,
          'postPetName': widget.postPetName,
          'postType': widget.postType,
          'postDescription': widget.postDescription,
          'phoneNumber': _phoneNumber,
          'bookingDate': _selectedDate,
          'bookingTime': _selectedTime,
          'notes': _notesController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        widget.onClose(); // Close the overlay after saving

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking successful'),
          ),
        );
      } catch (e) {
        print('Error saving booking: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save booking: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Form',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validatePhoneNumber,
                      onSaved: (value) => _phoneNumber = value,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: _selectedDate == null
                                  ? 'Select Date'
                                  : 'Date: ${_selectedDate!.toLocal()}'
                                      .split(' ')[0],
                              border: OutlineInputBorder(),
                            ),
                            validator: (_) => _validateDate(),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: _selectedTime == null
                                  ? 'Select Time'
                                  : 'Time: ${_selectedTime!.format(context)}',
                              border: OutlineInputBorder(),
                            ),
                            validator: (_) => _validateTime(),
                            onTap: () => _selectTime(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Notes (optional)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateNotes,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveBooking,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
