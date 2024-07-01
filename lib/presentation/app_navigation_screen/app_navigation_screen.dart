import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: AppDecoration.white,
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Splash Screen",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Onboarding One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Onboarding Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Onboarding Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Onboarding Four",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Login",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up - Success - Dialog",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Reset Password - Email - Tab Container",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Reset Password - Verify Code",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create New Password",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home - Container",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Top Doctor",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Find Doctors",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Doctor Detail",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Booking Doctor",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Chat with Doctor",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Audio Call",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Video Call",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Articles",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Pharmacy",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Drugs Detail",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "My Cart",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Location",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: AppDecoration.white,
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.black900,
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.blueGray40001,
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: appTheme.black900,
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
  }) {
    return Container(
      decoration: AppDecoration.white,
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.black900,
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: appTheme.blueGray40001,
          ),
        ],
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
