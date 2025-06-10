import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/core/themes/theme.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/friends_login_screen.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/viewmodel/friends_screen_view_model.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/widgets/friend_requests_dialog.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/widgets/friends_search_dialog.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = ref.watch(userProvider);
    final state = ref.watch(friendsViewModelProvider);
    final viewModel = ref.read(friendsViewModelProvider.notifier);
    if (prov == null) {
      return const FriendsLoginScreen();
    }

    if (state is ScoresLoaded) {
      return SingleChildScrollView(
        child: Column(
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
                          child: buildProfile(
                              "assets/svgs/third.svg", viewModel.third, 80, 85),
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
                      onPressed: () async {
                        await viewModel.openCalender(context);
                      },
                      icon: const Icon(Icons.calendar_month)),
                  IconButton(
                      onPressed: () {
                        viewModel.getScores(refresh: true);
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

            SizedBox(
              height: 280,
              child: ListView.builder(
                itemCount: state.scores.scoresList.length,
                itemBuilder: (context, index) {
                  final user = state.scores.scoresList[index];
                  return GestureDetector(
                    onLongPressStart: (details) {
                      if (user.me) {
                        return;
                      }
                      final tapPosition = details.globalPosition;
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          tapPosition.dx,
                          tapPosition.dy,
                          tapPosition.dx,
                          tapPosition.dy,
                        ),
                        items: [
                          const PopupMenuItem(
                            value: 'unfriend',
                            child: Text('Unfriend'),
                          ),
                        ],
                      ).then((value) {
                        if (value == 'unfriend') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Unfriend ${user.name}?'),
                              content: Text(
                                  'Are you sure you want to unfriend ${user.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    viewModel.unFriend(user.email);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Unfriend',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    },
                    child: buildLeaderboardTile(
                      index + 1,
                      user.name,
                      user.steps,
                      user.usage,
                      user.score,
                      user.me,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    if (state is ScoresLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const SizedBox(
      height: 0,
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
