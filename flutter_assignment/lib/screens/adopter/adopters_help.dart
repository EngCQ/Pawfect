import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_back_header.dart';

class AdoptersHelp extends StatefulWidget {
  const AdoptersHelp({super.key});

  @override
  _AdoptersHelpState createState() => _AdoptersHelpState();
}

class _AdoptersHelpState extends State<AdoptersHelp> {
  final TextEditingController _feedbackController = TextEditingController();
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
      await FirebaseFirestore.instance.collection('feedback').add({
        'uid': user.uid,
        'feedback': _feedbackController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback sent!'),
      ));
      _feedbackController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You need to be logged in to send feedback.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "How Can We Help You?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "FAQ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _faqItems.length,
              itemBuilder: (context, index) {
                return FAQItem(
                  question: _faqItems[index]['question']!,
                  answer: _faqItems[index]['answer']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _sendFeedback,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(widget.question),
            trailing: IconButton(
              icon: Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.answer),
            ),
        ],
      ),
    );
  }
}
