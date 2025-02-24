import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/profile_login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = ref.watch(userProvider.notifier);
    return prov.token == null
        ? const ProfileLoginScreen()
        : Center(
            child: Text(ref.read(userProvider)!.firstName),
          );
  }
}
