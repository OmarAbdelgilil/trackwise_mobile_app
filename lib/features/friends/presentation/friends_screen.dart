import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/core/themes/theme.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/viewmodel/friends_screen_view_model.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/widgets/friend_requests_dialog.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/widgets/friends_search_dialog.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<FriendsScreenViewModel>();
    return BlocProvider(
      create: (context) => viewModel..getScores(),
      child: BlocBuilder<FriendsScreenViewModel, FriendsStates>(
        builder: (context, state) {
          if (state is ScoresLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30), // Top padding

                // **Top 3 Users Display**
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: containerColor(context),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // **Second Place**
                            Flexible(
                              child: buildProfile("assets/svgs/second.svg",
                                  viewModel.second, 80, 85),
                            ),

                            const SizedBox(width: 20),

                            // **First Place**
                            Flexible(
                              flex: 2,
                              child: Column(
                                children: [
                                  buildProfile("assets/svgs/first.svg",
                                      viewModel.first, 145, 150),
                                ],
                              ),
                            ),

                            const SizedBox(width: 20),

                            // **Third Place**
                            Flexible(
                              child: buildProfile("assets/svgs/third.svg",
                                  viewModel.third, 80, 85),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30), // Space below avatars

                // **Search Button Aligned to Right**
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            viewModel.getScores();
                          },
                          icon: const Icon(Icons.refresh)),
                      IconButton(
                        onPressed: () {
                          showFriendRequestsDialog(context);
                        },
                        icon: const Icon(
                          Icons.people,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showFriendsSearchDialog(context);
                        },
                        icon: const Icon(
                          Icons.search_sharp,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: state.scores.scoresList.length,
                    itemBuilder: (context, index) {
                      final user = state.scores.scoresList[index];
                      return buildLeaderboardTile(index + 1, user.name,
                          user.steps, user.usage, user.score, user.me);
                    },
                  ),
                ),
              ],
            );
          }
          if (state is ScoresLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Placeholder();
        },
      ),
    );
  }
}

// Widget for Profile Circles
Widget buildProfile(
    String imagePath, String name, double width, double height) {
  return Column(
    children: [
      SizedBox(
        width: width,
        height: height,
        child: ClipOval(
          child: SvgPicture.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(height: 5),
      SizedBox(
        width: width,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ],
  );
}

// Widget for Leaderboard List with Numbers
Widget buildLeaderboardTile(int rank, String name, int steps, double hours,
    double score, bool highlight) {
  return Card(
    color: ColorsManager.darkContainer,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              "$rank.",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          // Name
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                name,
                style: TextStyle(
                  color: highlight ? Colors.blue : Colors.white,
                  fontSize: 16,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          // Steps
          Expanded(
            flex: 2,
            child: Text(
              "$steps steps",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),

          // Hours
          SizedBox(
            width: 60,
            child: Text(
              "${hours.toStringAsFixed(2)} hr",
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),

          // Score (Fix: SizedBox instead of Expanded)
          SizedBox(
            width: 70,
            child: Text(
              "${score.toStringAsFixed(2)} pts",
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.amber, fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );
}
