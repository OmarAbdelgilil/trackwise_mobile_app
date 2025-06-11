import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_wise_mobile_app/core/api/api_error_handler.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/friends/domain/entities/friend_user.dart';
import 'package:track_wise_mobile_app/features/friends/presentation/viewmodel/add_friends_screen_view_model.dart';
import 'package:track_wise_mobile_app/main.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

void showFriendsSearchDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      final viewmodel = getIt<AddFriendsScreenViewModel>();
      final TextEditingController controller = TextEditingController();
      Timer? debounce;
      void onSearchChanged(String query) {
        if (debounce?.isActive ?? false) debounce!.cancel();
        debounce = Timer(const Duration(seconds: 1), () {
          if (query.isNotEmpty) {
            viewmodel.searchUserByEmail(query);
          }
        });
      }

      return BlocProvider(
        create: (context) => viewmodel,
        child: BlocListener<AddFriendsScreenViewModel, FriendsState>(
          listener: (context, state) {
            if (state is FriendRequesSuccess) {
              scaffoldMessengerKey.currentState?.clearSnackBars();
              scaffoldMessengerKey.currentState
                  ?.showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is FriendsRequesError) {
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
              height: 200,
              width: 300.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Enter friends Email",
                      prefixIcon: const Icon(
                        Icons.search_sharp,
                        color: Color.fromARGB(255, 50, 49, 52),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      filled: true,
                      fillColor: ColorsManager.darkGrey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(width: 0)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 0),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: BlocBuilder<AddFriendsScreenViewModel, FriendsState>(
                      builder: (context, state) {
                        if (state is FriendsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is FriendsLoaded) {
                          return SizedBox(
                            height: 126,
                            child: ListView.builder(
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: buildLeaderboardTile(
                                      state.users[index],
                                      1,
                                      viewmodel,
                                      context,
                                      "add"),
                                );
                              },
                            ),
                          );
                        }
                        if (state is FriendsError) {
                          if((state.message as DioHttpException).exception!.response == null)
                          {
                            return const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Somthing went wrong please try again'),
                            );
                          }
                          return Text((state.message as DioHttpException)
                              .exception!
                              .response!
                              .data['message']);
                        }
                        return const Text("Enter friend email");
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildLeaderboardTile(
  FriendUser user,
  int rank,
  AddFriendsScreenViewModel viewModel,
  BuildContext context,
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
          IconButton(onPressed: () {
            viewModel.sendFriendRequest(user);
            Navigator.of(context).pop();
          }, icon: BlocBuilder<AddFriendsScreenViewModel, FriendsState>(
            builder: (context, state) {
              if (state is FriendRequestLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Icon(
                Icons.person_add_alt_1_outlined,
                color: ColorsManager.lightGreen,
              );
            },
          )),
        ],
      ),
    ),
  );
}
