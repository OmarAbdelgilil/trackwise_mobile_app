import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_wise_mobile_app/core/api/api_error_handler.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/viewmodel/friend_requests_view_model.dart';
import 'package:track_wise_mobile_app/main.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

void showFriendRequestsDialog(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        final viewModel = getIt<FriendRequestsViewModel>();
        return BlocProvider(
            create: (context) => viewModel..getScores(),
            child: BlocListener<FriendRequestsViewModel, FriendsStates>(
              listener: (context, state) {
                if (state is FriendAccRejSuccess) {
                  scaffoldMessengerKey.currentState?.clearSnackBars();
                  scaffoldMessengerKey.currentState
                      ?.showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is FriendAccRejError) {
                  scaffoldMessengerKey.currentState?.clearSnackBars();
                  scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
                      content: Text((state.message as DioHttpException)
                          .exception!
                          .response!
                          .data["message"])));
                }
              },
              child: AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  content: SizedBox(
                    height: 200.h,
                    width: 300.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: BlocBuilder<FriendRequestsViewModel,
                              FriendsStates>(
                            builder: (context, state) {
                              if (state is ScoresLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (viewModel.requests.isNotEmpty) {
                                return SizedBox(
                                  height: 180,
                                  child: ListView(
                                    children: [
                                      for (int i = 0;
                                          i < viewModel.requests.length;
                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: buildLeaderboardTile(
                                              i + 1,
                                              viewModel.requests[i],
                                              viewModel,
                                              ""),
                                        ),
                                    ],
                                  ),
                                );
                              }

                              return const Text("No friends requests for now");
                            },
                          ),
                        )
                      ],
                    ),
                  )),
            ));
      });
}

Widget buildLeaderboardTile(
  int rank,
  FriendUser user,
  FriendRequestsViewModel viewModel,
  String buttonText, {
  bool highlight = false,
}) {
  return Container(
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.black,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: SvgPicture.asset(
              "assets/svgs/profile_icon.svg",
              width: 30.w,
              height: 30.h,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            flex: 3,
            child: Text(
              "${user.firstName} ${user.lastName}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: highlight ? Colors.blue : Colors.white,
                fontSize: 16,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.acceptFriendRequest(user);
            },
            icon: const Icon(
              Icons.check,
              color: ColorsManager.lightGreen,
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.rejectFriendRequest(user);
            },
            icon: const Icon(
              Icons.close,
              color: ColorsManager.red,
            ),
          ),
        ],
      ),
    ),
  );
}
