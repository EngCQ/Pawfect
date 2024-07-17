import 'package:flutter/material.dart';

class HomePost extends StatelessWidget {
  final String postName;
  final String postImage;
  final String postPetName;
  final String postType;

  const HomePost({
    super.key,
    required this.postName,
    required this.postImage,
    required this.postPetName,
    required this.postType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(postImage), // Use NetworkImage for the image
            fit: BoxFit.fill,
          ),
          color: Colors.deepPurple,
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/post_details') {
                  Navigator.pushNamed(context, '/post_details');
                }
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  postName,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                padding: const EdgeInsets.all(10),
                color: Colors.blue.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        postPetName,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      postType,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
