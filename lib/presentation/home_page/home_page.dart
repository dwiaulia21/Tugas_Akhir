import 'package:awull_s_application3/widgets/app_bar/custom_app_bar.dart';
import 'package:awull_s_application3/widgets/app_bar/appbar_subtitle.dart';
import 'package:awull_s_application3/presentation/home_page/cek_gejala_screen.dart';
import 'package:awull_s_application3/widgets/app_bar/appbar_trailing_image.dart';
import 'widgets/categories_item_widget.dart';
import 'package:awull_s_application3/widgets/custom_elevated_button.dart';
import 'widgets/home_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart'; // ignore_for_file: must_be_immutable

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgDiare,
              height: 200.v,
              width: 280.h,
              radius: BorderRadius.circular(10.h),
              alignment: Alignment.center,
            ),
            SizedBox(height: 20.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "Diare adalah kondisi buang air besar yang cair dan sering. Ini bisa disebabkan oleh infeksi, makanan terkontaminasi, atau kondisi medis lainnya. Gejalanya termasuk perut kram, kembung, dan mual. Penting untuk minum banyak cairan dan berkonsultasi dengan dokter jika diare berlangsung lama atau parah.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 30.v),
            CustomElevatedButton(
  height: 50.v,
  width: 90.h,
  text: "Cek Disini!",
  buttonStyle: CustomButtonStyles.fillWhiteA,
  buttonTextStyle: CustomTextStyles.labelLargePrimary,
  onPressed: () {
    print("Navigating to GejalaPage");
    Navigator.pushNamed(context, AppRoutes.gejalaScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 200.v,
      title: AppbarSubtitle(
        text: "Hallo!",
        margin: EdgeInsets.only(left: 30.h),
      ),
    );
  }
}