import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/views/adopter/default/adopters_back_header.dart';

class AdoptersHelp extends StatefulWidget {
  const AdoptersHelp({super.key});

  @override
  _AdoptersHelpState createState() => _AdoptersHelpState();
}

class _AdoptersHelpState extends State<AdoptersHelp> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How to adopt a pet?',
      'answer':
          'To adopt a pet, you need to visit our adoption center and fill out the necessary forms.'
    },
    {
      'question': 'What are the adoption fees?',
      'answer':
          'Adoption fees vary depending on the type of pet. Please check our website for detailed information.'
    },
    // Add more FAQ items here
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
        _purposeController.clear();
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
  void dispose() {
    _feedbackController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
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
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the purpose of your feedback',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController,
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
