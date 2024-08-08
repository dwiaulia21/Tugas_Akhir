import 'package:awull_s_application3/presentation/home_page/home_page.dart';
import 'package:awull_s_application3/presentation/message_history_tab_container_page/message_history_tab_container_page.dart';
import 'package:awull_s_application3/presentation/profile_page/profile_page.dart';
import 'package:awull_s_application3/presentation/home_page/cek_gejala_screen.dart'; // Import halaman Cek Gejala
import 'package:awull_s_application3/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart';

// ignore_for_file: must_be_immutable
class HomeContainerScreen extends StatelessWidget {
  HomeContainerScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        body: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.homePage,
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, ani, ani1) => getCurrentPage(routeSetting.name!),
            transitionDuration: Duration(seconds: 0),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        Navigator.pushNamed(
            navigatorKey.currentContext!, getCurrentRoute(type));
      },
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homePage;
      case BottomBarEnum.Message:
        return AppRoutes.messageHistoryTabContainerPage;
      case BottomBarEnum.Lockgray500:
        return AppRoutes.profilePage;
      case BottomBarEnum.CekGejalaScreen: // Tambahkan rute untuk "Cek Disini"
        return AppRoutes.gejalaScreen;
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homePage:
        return HomePage();
      case AppRoutes.messageHistoryTabContainerPage:
        return MessageHistoryTabContainerPage(userAnswers: {}, hasilDiagnosa: {}, solusiDiagnosa: {});
      case AppRoutes.profilePage:
        return ProfilePage();
      case AppRoutes.gejalaScreen: // Tambahkan halaman Cek Gejala
        return CekGejalaScreen();
      default:
        return DefaultWidget();
    }
  }
}
