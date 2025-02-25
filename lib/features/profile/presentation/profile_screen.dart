import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/profile_login_screen.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/view_models/profile_view_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = ref.watch(userProvider);
    final viewModel = ref.read(profileProvider.notifier);
    return prov == null
        ? const ProfileLoginScreen()
        : Center(
            child: Column(
              children: [
                Text(
                  prov.firstName,
                  style: const TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      viewModel.logout();
                    },
                    child: const Text("logout"))
              ],
            ),
          );
  }
}
