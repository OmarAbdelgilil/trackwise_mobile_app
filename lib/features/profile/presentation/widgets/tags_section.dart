import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/widgets/section_header.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: "Tags", buttonText: "Show all", onPressed: () {}),
        //tbd tags list
        const SizedBox(
          height: 10,
        ),
        //////////////
      ],
    );
  }
}
