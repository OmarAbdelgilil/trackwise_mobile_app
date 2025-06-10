import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/widgets/section_header.dart';

class TagsSection extends ConsumerWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = ref.watch(profileProvider);

    return Column(
      children: [
        SectionHeader(title: "Tags", buttonText: "", onPressed: () {}),
        if (prov is TagsLoaded &&
            prov.tags.tags != null &&
            prov.tags.tags!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: prov.tags.tags!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: InkWell(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              prov.tags.tags![index].name ?? 'No tag name'),
                          duration: const Duration(seconds: 2),
                        ),
                      ),
                      child: CircleAvatar(
                        maxRadius: 35,
                        child: Image(
                            image: NetworkImage(prov.tags.tags![index].image!)),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
        //tbd tags list
        const SizedBox(
          height: 10,
        ),
        //////////////
      ],
    );
  }
}
