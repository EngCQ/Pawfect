import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/feedback_model.dart';

class FeedbackViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<FeedbackModel> feedbacks = [];
  bool isLoading = false;

  void setSearchQuery(String query) {
    searchQuery = query.toLowerCase();
    notifyListeners();
  }

  Future<void> fetchFeedbacks() async {
    try {
      setLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('feedback').get();
      feedbacks = snapshot.docs.map((doc) => FeedbackModel.fromFirestore(doc)).toList();
      for (var feedback in feedbacks) {
        await feedback.fetchUserData();
      }
      print('Fetched ${feedbacks.length} feedback items.'); // Debug print
    } catch (e) {
      print('Error fetching feedbacks: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await FirebaseFirestore.instance.collection('feedback').doc(feedbackId).delete();
      feedbacks.removeWhere((feedback) => feedback.feedbackId == feedbackId);
      notifyListeners();
    } catch (e) {
      print('Error deleting feedback: $e');
    }
  }

  List<FeedbackModel> get filteredFeedbacks {
    return feedbacks.where((feedback) {
      return feedback.feedbackId.toLowerCase().contains(searchQuery) ||
             feedback.feedback.toLowerCase().contains(searchQuery);
    }).toList();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
