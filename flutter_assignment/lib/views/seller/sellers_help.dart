import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/views/seller/sellers_back_header.dart';

class SellersHelp extends StatefulWidget {
  const SellersHelp({super.key});

  @override
  _SellersHelpState createState() => _SellersHelpState();
}

class _SellersHelpState extends State<SellersHelp> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController(); // Purpose Controller
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How to list a pet for sale?',
      'answer':
          'To list a pet for sale, visit our seller portal, complete the listing form, and upload any required documents.'
    },
    {
      'question': 'What are the seller fees?',
      'answer':
          'Seller fees vary depending on the type of listing. Please check our website for detailed information.'
    },
    {
      'question': 'How can I manage my listings?',
      'answer':
          'You can manage your listings through your seller dashboard where you can edit or remove your posts.'
    },
    // Add more FAQ items here as needed
  ];

  Future<void> _sendFeedback() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      if (_feedbackController.text.isNotEmpty && _purposeController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('feedback').add({
          'uid': user.uid,
          'feedback': _feedbackController.text,
          'purpose': _purposeController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Feedback sent!'),
        ));
        _feedbackController.clear();
        _purposeController.clear(); // Clear the purpose field
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter both purpose and feedback.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to be logged in to send feedback.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SellersBackHeader(), // Updated AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "How Can We Help You?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "FAQ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _faqItems.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(_faqItems[index]['question']!),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(_faqItems[index]['answer']!),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feedback',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _purposeController, // Purpose TextField
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the purpose of your feedback',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController, // Feedback TextField
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your feedback here',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendFeedback,
                        child: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
