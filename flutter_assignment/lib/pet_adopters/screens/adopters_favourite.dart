import 'package:flutter/material.dart';
import 'package:flutter_assignment/pet_adopters/components/home_post.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_default_header.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_design.dart';
import 'package:flutter_assignment/pet_adopters/default/adopters_navigation_bar.dart';

class AdoptersFavourite extends StatelessWidget {
  AdoptersFavourite({super.key});

  // List of all post details
  final List<String> favouritePostName = [
    // 'post 1',
    // 'post 2',
    // 'post 3',
  ];

  final List<String> favouritePostImage = [
    'lib/pet_adopters/images/pets.jpeg',
    'lib/pet_adopters/images/pets.jpeg',
    'lib/pet_adopters/images/pets.jpeg',
  ];

  final List<String> favouritePostPetName = [
    'Teddy',
    'Jakie',
    'Joy',
  ];

  final List<String> favouritePostType = [
    'Missing Pet',
    'Pet Adoption',
    'Pet Adoption',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultHeader(),
      body: favouritePostName.isEmpty
          ? Center(
              child: Text(
                "No Favourite Post",
                style: TextStyle(fontSize: Design.emptyPageSize),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your Favourite Post Here',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: favouritePostImage.length,
                      itemBuilder: (context, index) {
                        return HomePost(
                          postName: favouritePostName[index],
                          postImage: favouritePostImage[index],
                          postPetName: favouritePostPetName[index],
                          postType: favouritePostType[index],
                        );
                      }),
                ),
              ],
            ),
      bottomNavigationBar: const AdoptersNavigationBar(),
    );
  }
}
