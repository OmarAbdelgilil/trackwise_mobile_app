import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/features/Notifications/presentation/notification_screen_view_model.dart';
import 'package:track_wise_mobile_app/features/Notifications/presentation/widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: state is LoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state is SuccessState
                ? SizedBox(
                    child: NotificationTile(
                      appName: state.app.appName!,
                      packageName: state.app.packageName!,
                    ),
                  )
                : state is ErrorState
                    ? const Center(
                        child: Text("Error loading notifications"),
                      )
                    : const Placeholder());
  }
}
