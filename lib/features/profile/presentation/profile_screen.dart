import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/logout_dialog.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/profile_login_screen.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/widgets/profile_details_section.dart';
import 'package:track_wise_mobile_app/features/profile/presentation/widgets/tags_section.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prov = ref.watch(userProvider);
    final viewModel = ref.read(profileProvider.notifier);
    return prov == null
        ? const ProfileLoginScreen()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svgs/profile_icon.svg",
                          width: 150.w,
                          height: 150.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${prov.firstName} ${prov.lastName}',
                            style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  const TagsSection(),
                  ProfileDetailsSection(
                      email: prov.email, phone: prov.phone.toString()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: const Divider(
                      color: ColorsManager.lightgrey,
                    ),
                  ),
                  InkWell(
                    onTap: () => showLogoutDialog(context, viewModel.logout),
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
