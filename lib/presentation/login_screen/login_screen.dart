import 'package:awull_s_application3/widgets/app_bar/custom_app_bar.dart';
import 'package:awull_s_application3/widgets/app_bar/appbar_leading_image.dart';
import 'package:awull_s_application3/widgets/app_bar/appbar_subtitle_two.dart';
import 'package:awull_s_application3/widgets/custom_text_form_field.dart';
import 'package:awull_s_application3/widgets/custom_elevated_button.dart';
import 'package:awull_s_application3/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.h,
                  vertical: 39.v,
                ),
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "Enter your email",
                      textInputType: TextInputType.emailAddress,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(24.h, 16.v, 16.h, 16.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgCheckmark,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 56.v,
                      ),
                      contentPadding: EdgeInsets.only(
                        top: 18.v,
                        right: 30.h,
                        bottom: 18.v,
                      ),
                    ),
                    SizedBox(height: 16.v),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(24.h, 16.v, 16.h, 16.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgLocation,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 56.v,
                      ),
                      suffix: Container(
                        margin: EdgeInsets.fromLTRB(30.h, 16.v, 24.h, 16.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgEye,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                      ),
                      suffixConstraints: BoxConstraints(
                        maxHeight: 56.v,
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10.v),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          onTapTxtForgotPassword(context);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: CustomTextStyles.titleSmallPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.v),
                    CustomElevatedButton(
                      text: "Login",
                      onPressed: () {
                        onTapLogin(context);
                      },
                    ),
                    SizedBox(height: 25.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 48.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.v),
                              child: Text(
                                "Don’t have an account?",
                                style: CustomTextStyles.bodyMediumGray600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onTapTxtSignUp(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  "Sign Up",
                                  style: CustomTextStyles
                                      .titleSmallPrimarySemiBold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 34.v),
                    SizedBox(height: 29.v),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 56.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgIconChevronLeft,
        margin: EdgeInsets.only(
          left: 32.h,
          top: 8.v,
          bottom: 8.v,
        ),
      ),
      centerTitle: true,
      title: AppbarSubtitleTwo(
        text: "Login",
      ),
    );
  }



  /// Navigates to the resetPasswordEmailTabContainerScreen when the action is triggered.
  onTapTxtForgotPassword(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.resetPasswordEmailTabContainerScreen);
  }

  onTapLogin(BuildContext context) {
    // TODO: implement Actions
  }

  /// Navigates to the signUpScreen when the action is triggered.
  onTapTxtSignUp(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signUpScreen);
  }
}
