import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/adopter/default/adopters_back_header.dart';

class AdoptersHelp extends StatelessWidget {
  const AdoptersHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackHeader(),
        body: Column(
          children: [Text("How Can we Help you"), Text("FAQ"), ListView()],
        ));
  }
}
