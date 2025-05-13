//import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:travellookup/blocs/internet_bloc.dart';
import 'package:travellookup/blocs/sign_in_bloc.dart';
import 'package:travellookup/core/constants/colors.dart';
import 'package:travellookup/core/utils/next_screen.dart';
import 'package:travellookup/core/utils/responsive_size.dart';
import 'package:travellookup/core/utils/snacbar.dart';
import 'package:travellookup/pages/done.dart';
import 'package:travellookup/router/app_routes.dart';
import 'package:travellookup/view/signup/controller/signup_controller.dart';
import 'package:travellookup/widgets/text_field.dart';
import 'package:travellookup/widgets/button.dart';
import 'package:travellookup/widgets/outlined_button.dart';
import 'package:travellookup/widgets/title_text.dart';
import 'package:travellookup/widgets/top_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool googleSignInStarted = false;
  handleGoogleSignIn() async {
    final sb = context.read<SignInBloc>();
    final ib = context.read<InternetBloc>();
    setState(() => googleSignInStarted = true);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      Get.snackbar("Error", 'check your internet connection!'.tr);
    } else {
      await sb.signInWithGoogle().then((_) {
        if (sb.hasError == true) {
          Get.snackbar("Error", 'something is wrong. please try again.'.tr);
          setState(() => googleSignInStarted = false);
        } else {
          sb.checkUserExists().then((value) {
            if (value == true) {
              sb.getUserDatafromFirebase(sb.uid).then((value) => sb
                  .saveDataToSP()
                  .then((value) => sb.guestSignout())
                  .then((value) => sb.setSignIn().then((value) {
                        setState(() => googleSignInStarted = false);
                        afterSignIn();
                      })));
            } else {
              sb.getJoiningDate().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value) => sb.saveDataToSP().then((value) => sb
                      .guestSignout()
                      .then((value) => sb.setSignIn().then((value) {
                            setState(() => googleSignInStarted = false);
                            afterSignIn();
                          })))));
            }
          });
        }
      });
    }
  }

  afterSignIn() {
    nextScreen(context, DonePage());
  }

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    String title = "Đăng ký";
    String imgPath = "assets/images/signup.png";
    final SignUpController controller = Get.find();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              leading: GestureDetector(
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.grey, size: 16),
                onTap: () => Navigator.of(context).pop(),
              ),
              backgroundColor:
                  Colors.transparent, //You can make this transparent
              elevation: 0.0, //No shadow
            ),
          ),
          SingleChildScrollView(
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopImage(
                  imgPath: imgPath,
                  size: Responsive.horizontalSize(360 * 0.55),
                ),
                TitleText(title: title),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  controller: controller.nameController,
                  hintText: "Tên",
                  keyboardType: TextInputType.name,
                  width: width * 0.8,
                  icon: const Icon(FontAwesomeIcons.user, size: 17),
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  controller: controller.emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  width: width * 0.8,
                  icon: const Icon(FontAwesomeIcons.at, size: 17),
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  hintText: "Password",
                  controller: controller.passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  width: width * 0.8,
                  icon: const Icon(Icons.lock_outline_rounded, size: 19),
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  hintText: "Nhập lại Password",
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  width: width * 0.8,
                  icon: const Icon(Icons.lock_outline_rounded, size: 19),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Responsive.verticalSize(15),
                      bottom: Responsive.verticalSize(15),
                      left: width * 0.1,
                      right: width * 0.1),
                  child: Text.rich(
                    TextSpan(
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: "Bằng cách đăng ký, bạn đồng ý với ",
                            style: GoogleFonts.poppins(),
                          ),
                          TextSpan(
                            text: "Điều khoản & Điều kiện ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, color: mainColor),
                          ),
                          TextSpan(
                            text: "và ",
                            style: GoogleFonts.poppins(),
                          ),
                          TextSpan(
                            text: "Chính sách quyền riêng tư.",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, color: mainColor),
                          ),
                        ]),
                  ),
                ),
                GetBuilder<SignUpController>(builder: (cont) {
                  return MyButton(
                    showCircularBar: cont.isLoading.value,
                    onTap: () {
                      if (cont.nameController.text.isEmpty) {
                        Get.snackbar("Error", "Name can't be empty".tr);
                      } else if (cont.emailController.text.isEmpty) {
                        Get.snackbar("Error", "Email can't be empty".tr);
                      } else if (cont.passwordController.text.isEmpty) {
                        Get.snackbar("Error", "Password can't be empty".tr);
                      } 
                      else if(!cont.emailController.text.contains('@')){
                        Get.snackbar("Error", "Invalid Email".tr);
                      }
                      else if (cont.confirmPasswordController.text.isEmpty) {
                        Get.snackbar(
                            "Error", "Confirm Password can't be empty".tr);
                      } else if (cont.passwordController.text !=
                          cont.confirmPasswordController.text) {
                        Get.snackbar("Error", "Password doesn't match".tr);
                      } else {
                        cont.register();
                      }
                    },
                    text: "Đăng ký",
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(
                      top: Responsive.verticalSize(15),
                      bottom: Responsive.verticalSize(15)),
                  child: Center(
                    child: Text(
                      "Hoặc đăng ký với...",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                MyOutlinedButton(
                    onTap: () => handleGoogleSignIn(),
                    child: Image.asset(
                      "assets/images/google.png",
                    )),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn đã có tài khoản? ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        "Đăng nhập",
                        style: GoogleFonts.poppins(color: mainColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
