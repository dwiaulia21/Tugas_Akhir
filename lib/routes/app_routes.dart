import 'package:awull_s_application3/presentation/home_page/home_page.dart';
import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_one_screen/onboarding_one_screen.dart';
import '../presentation/onboarding_two_screen/onboarding_two_screen.dart';
import '../presentation/onboarding_three_screen/onboarding_three_screen.dart';
import '../presentation/onboarding_four_screen/onboarding_four_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_page/cek_gejala_screen.dart';
import '../presentation/sign_up_screen/sign_up_screen.dart';
import '../presentation/reset_password_email_tab_container_screen/reset_password_email_tab_container_screen.dart';
import '../presentation/reset_password_verify_code_screen/reset_password_verify_code_screen.dart';
import '../presentation/create_new_password_screen/create_new_password_screen.dart';
import '../presentation/home_container_screen/home_container_screen.dart';
import '../presentation/pharmacy_screen/pharmacy_screen.dart';
import '../presentation/location_screen/location_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';

  static const String onboardingOneScreen = '/onboarding_one_screen';

  static const String onboardingTwoScreen = '/onboarding_two_screen';

  static const String onboardingThreeScreen = '/onboarding_three_screen';

  static const String onboardingFourScreen = '/onboarding_four_screen';

  static const String loginScreen = '/login_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String resetPasswordEmailPage = '/reset_password_email_page';

  static const String resetPasswordEmailTabContainerScreen =
      '/reset_password_email_tab_container_screen';

  static const String resetPasswordPhonePage = '/reset_password_phone_page';

  static const String resetPasswordVerifyCodeScreen =
      '/reset_password_verify_code_screen';

  static const String createNewPasswordScreen = '/create_new_password_screen';

  static const String homePage = '/home_page';

  static const String homeContainerScreen = '/home_container_screen';

  static const String gejalaScreen = '/cek_gejala_screen';

  static const String findDoctorsScreen = '/find_doctors_screen';

  static const String doctorDetailScreen = '/doctor_detail_screen';

  static const String bookingDoctorScreen = '/booking_doctor_screen';

  static const String chatWithDoctorScreen = '/chat_with_doctor_screen';

  static const String audioCallScreen = '/audio_call_screen';

  static const String videoCallScreen = '/video_call_screen';

  static const String messageHistoryPage = '/message_history_page';

  static const String messageHistoryTabContainerPage =
      '/message_history_tab_container_page';

  static const String articlesScreen = '/articles_screen';

  static const String pharmacyScreen = '/pharmacy_screen';

  static const String drugsDetailScreen = '/drugs_detail_screen';

  static const String myCartScreen = '/my_cart_screen';

  static const String locationScreen = '/location_screen';

  static const String profilePage = '/profile_page';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    homePage: (context) => HomePage(),
    onboardingOneScreen: (context) => OnboardingOneScreen(),
    onboardingTwoScreen: (context) => OnboardingTwoScreen(),
    onboardingThreeScreen: (context) => OnboardingThreeScreen(),
    onboardingFourScreen: (context) => OnboardingFourScreen(),
    loginScreen: (context) => LoginScreen(),
    signUpScreen: (context) => SignUpScreen(),
     gejalaScreen: (context) => CekGejalaScreen(),
    resetPasswordEmailTabContainerScreen: (context) =>
        ResetPasswordEmailTabContainerScreen(),
    resetPasswordVerifyCodeScreen: (context) => ResetPasswordVerifyCodeScreen(),
    createNewPasswordScreen: (context) => CreateNewPasswordScreen(),
    homeContainerScreen: (context) => HomeContainerScreen(),
    pharmacyScreen: (context) => PharmacyScreen(),
    locationScreen: (context) => LocationScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}