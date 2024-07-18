import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingFormOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final String postName;
  final String postImage;
  final String postPetName;
  final String postType;
  final String postDescription;

  BookingFormOverlay({
    super.key,
    required this.onClose,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postType,
    required this.postDescription,
  });

  @override
  _BookingFormOverlayState createState() => _BookingFormOverlayState();
}

class _BookingFormOverlayState extends State<BookingFormOverlay> {
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
    final RegExp regex = RegExp(r'^\d{10}$');
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
        CollectionReference bookingsCollection =
            FirebaseFirestore.instance.collection('bookings');

        String? uid = FirebaseAuth.instance.currentUser?.uid;

        await bookingsCollection.add({
          'uid': uid,
          'postName': widget.postName,
          'postImage': widget.postImage,
          'postPetName': widget.postPetName,
          'postType': widget.postType,
          'postDescription': widget.postDescription,
          'phoneNumber': _phoneNumber,
          'date': _selectedDate,
          'time': _selectedTime?.format(context),
          'notes': _notesController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking successful'),
          ),
        );
        widget.onClose();
      } catch (e) {
        print('Error saving booking: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Booking Form',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(_selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${_selectedDate!.toLocal()}'
                            .split(' ')[0]),
                  ),
                  if (_selectedDate == null)
                    Text(
                      _validateDate() ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(_selectedTime == null
                        ? 'Select Time'
                        : 'Selected Time: ${_selectedTime!.format(context)}'),
                  ),
                  if (_selectedTime == null)
                    Text(
                      _validateTime() ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      _phoneNumber = value;
                    },
                    validator: _validatePhoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 5,
                    validator: _validateNotes,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _saveBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: widget.onClose,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
