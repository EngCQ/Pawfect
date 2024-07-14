import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/components/home_post.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_default_header.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_navigation_bar.dart';

class AdoptersHome extends StatelessWidget {
  AdoptersHome({super.key});

  //list of all post details
  final List<String> postName = [
    'post 1',
    'post 2',
    'post 3',
  ];

  final List<String> postImage = [
    'lib/pet_adopters/images/bell.png',
    'lib/pet_adopters/images/pets.jpeg',
    'lib/pet_adopters/images/pets.jpeg',
  ];

  final List<String> postPetName = [
    'Teddy',
    'Jakie',
    'Joy',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: ListView.builder(
          itemCount: postImage.length,
          itemBuilder: (context, index) {
            return HomePost(
              postName: postName[index],
              postImage: postImage[index],
            );
          }),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
