import 'package:awull_s_application3/widgets/custom_icon_button.dart';
import 'widgets/profilelistsection_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart'; // ignore_for_file: must_be_immutable

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [
                theme.colorScheme.secondaryContainer,
                theme.colorScheme.onError
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            decoration: AppDecoration.linear,
            child: Column(
              children: [
                SizedBox(height: 44.v),
                _buildProfileSection(context),
                SizedBox(height: 38.v),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 29.v,
                  ),
                  decoration: AppDecoration.white.copyWith(
                    borderRadius: BorderRadiusStyle.customBorderTL30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 5.v),
                      _buildMySaveSection(context),
                      SizedBox(height: 14.v),
                      SizedBox(height: 14.v),
                      SizedBox(height: 14.v),
                      _buildLogoutSection(context)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildProfileSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 82.v,
          width: 81.h,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgEllipse27,
                height: 80.adaptSize,
                width: 80.adaptSize,
                radius: BorderRadius.circular(
                  40.h,
                ),
                alignment: Alignment.center,
              ),
              CustomIconButton(
                height: 24.adaptSize,
                width: 24.adaptSize,
                padding: EdgeInsets.all(4.h),
                decoration: IconButtonStyleHelper.fillWhiteA,
                alignment: Alignment.bottomRight,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCamera,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 19.v),
        Text(
          "Dwi Aulia",
          style: CustomTextStyles.titleMediumWhiteA70018,
        )
      ],
    );
  }

  /// Section Widget
Widget _buildMySaveSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Edit Name',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      TextFormField(
        decoration: InputDecoration(
          hintText: 'Enter new name',
        ),
      ),
      SizedBox(height: 20),
      Text(
        'Edit Email',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      TextFormField(
        decoration: InputDecoration(
          hintText: 'Enter new Email',
        ),
      ),
      SizedBox(height: 20),
      Text(
        'Change Password',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Enter new password',
        ),
      ),
      
    ],
  );
}

  /// Section Widget
  Widget _buildLogoutSection(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/login_screen');
    },
    child: SizedBox(
      height: 48.v,
      width: 335.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 48.v,
              width: 43.h,
              decoration: BoxDecoration(
                color: appTheme.red50,
                borderRadius: BorderRadius.circular(
                  24.h,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 9.h,
                top: 10.v,
                bottom: 10.v,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgIcRoundLogout,
                    height: 26.v,
                    width: 24.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 28.h,
                      top: 6.v,
                    ),
                    child: Text(
                      "Logout",
                      style: CustomTextStyles.titleMediumRedA200,
                    ),
                  ),
                  Spacer(),
                  CustomImageView(
                    imagePath: ImageConstant.imgArrowRight,
                    height: 26.v,
                    width: 24.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}