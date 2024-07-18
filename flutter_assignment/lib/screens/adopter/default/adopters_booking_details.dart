import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_back_header.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_design.dart';

class AdoptersBookingDetails extends StatelessWidget {
  final String postName;
  final String postImage;
  final String postPetName;
  final String postType;
  final String postDescription;
  final String date;
  final String time;
  final String phoneNumber;
  final String notes;

  const AdoptersBookingDetails({
    Key? key,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postType,
    required this.postDescription,
    required this.date,
    required this.time,
    required this.phoneNumber,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 330,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(postImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: $postName',
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Design.descriptionDetailTopPadding,
                      bottom: 10,
                    ),
                    child: Text(
                      'Type: $postType',
                      style: TextStyle(
                        fontSize: Design.descriptionTitleSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Pet's Name: $postPetName",
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Design.descriptionDetailTopPadding,
                    ),
                    child: Text(
                      'Description: ',
                      style: TextStyle(
                        fontSize: Design.descriptionTitleSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    postDescription,
                    style: TextStyle(
                      fontSize: Design.descriptionDetailSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Date: $date',
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Time: $time',
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Phone: $phoneNumber',
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Notes: $notes',
                    style: TextStyle(
                      fontSize: Design.descriptionTitleSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
