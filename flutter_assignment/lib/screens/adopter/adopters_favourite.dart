import 'package:flutter/material.dart';
import 'components/home_post.dart';
import 'default/adopters_default_header.dart';
import 'default/adopters_design.dart';
import 'default/adopters_navigation_bar.dart';

class AdoptersFavourite extends StatelessWidget {
  AdoptersFavourite({super.key});

  // List of all post details
  final List<String> favouritePostName = [
    // 'post 1',
    // 'post 2',
    // 'post 3',
  ];

  final List<String> favouritePostImage = [
    'lib/images/pets.jpeg',
    'lib/images/pets.jpeg',
    'lib/images/pets.jpeg',
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
