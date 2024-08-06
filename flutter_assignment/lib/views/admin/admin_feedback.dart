import 'package:flutter/material.dart';
import 'package:flutter_assignment/views/admin/admin_viewFeedback.dart';
import 'package:provider/provider.dart';
import 'package:flutter_assignment/widgets/drawer_admin.dart';
import 'package:flutter_assignment/viewmodels/user_authentication.dart';
import 'package:flutter_assignment/viewmodels/admin/feedback_management/admin_feedback_viewmodel.dart';

class AdminFeedbackManagement extends StatefulWidget {
  const AdminFeedbackManagement({super.key});

  @override
  AdminFeedbackManagementState createState() => AdminFeedbackManagementState();
}

class AdminFeedbackManagementState extends State<AdminFeedbackManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedbackViewModel>(context, listen: false).fetchFeedbacks();
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String feedbackId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Feedback'),
          content: const Text('Are you sure you want to delete this feedback? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<FeedbackViewModel>(context, listen: false).deleteFeedback(feedbackId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuthentication>(context);
    final userEmail = userAuth.user?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0583CB),
        title: const Text('Feedback'),
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
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      drawer: const DrawerAdmin(currentRoute: '/adminFeedbackManagement'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<FeedbackViewModel>(
            builder: (context, feedbackViewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: feedbackViewModel.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by feedback ID or content',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                feedbackViewModel.setSearchQuery(feedbackViewModel.searchController.text);
                              },
                            ),
                          ),
                          onChanged: (value) {
                            feedbackViewModel.setSearchQuery(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (feedbackViewModel.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (feedbackViewModel.filteredFeedbacks.isEmpty)
                    const Center(child: Text('No feedback found.'))
                  else
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: feedbackViewModel.filteredFeedbacks.length,
                        itemBuilder: (context, index) {
                          final feedback = feedbackViewModel.filteredFeedbacks[index];
                          final feedbackId = feedback.feedbackId;
                          final content = feedback.feedback;
                          //final purpose = feedback.purpose;
                          final timestamp = feedback.timestamp.toDate();
                          final userEmail = feedback.userEmail;
                          //final userName = feedback.userName;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text('Feedback $feedbackId'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Content: $content'),
                                  //Text('Purpose: $purpose'),
                                  Text('Timestamp: $timestamp'),
                                  //if (userName != null) Text('User: $userName'),
                                  if (userEmail != null) Text('Email: $userEmail'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, feedbackId);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FeedbackDetailScreen(feedback: feedback),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
