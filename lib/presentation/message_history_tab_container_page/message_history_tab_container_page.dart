import 'package:awull_s_application3/widgets/app_bar/custom_app_bar.dart';
import 'package:awull_s_application3/widgets/app_bar/appbar_title.dart';
import 'package:awull_s_application3/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart';

// ignore_for_file: must_be_immutable
class MessageHistoryTabContainerPage extends StatefulWidget {
  const MessageHistoryTabContainerPage({Key? key})
      : super(
          key: key,
        );

  @override
  MessageHistoryTabContainerPageState createState() =>
      MessageHistoryTabContainerPageState();
}

class MessageHistoryTabContainerPageState
    extends State<MessageHistoryTabContainerPage>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 15.v),
          child: Column(
            children: [
              SizedBox(
                height: 579.v,
                child: TabBarView(
                  controller: tabviewController, children: [],
                ),
              ),
            ], 
          ),
        ),
  
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 49.v,
      title: AppbarTitle(
        text: "History",
        margin: EdgeInsets.only(left: 21.h),
      ),
      actions: [
        Container(
          height: 33.v,
          width: 24.h,
          margin: EdgeInsets.symmetric(
            horizontal: 20.h,
            vertical: 8.v,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRewindOnprimary,
                height: 24.adaptSize,
                width: 24.adaptSize,
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(bottom: 9.v),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgComponent1,
                height: 16.v,
                width: 4.h,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(
                  left: 20.h,
                  top: 17.v,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  }

