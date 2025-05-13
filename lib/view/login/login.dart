import 'package:provider/provider.dart';
import 'package:travellookup/blocs/internet_bloc.dart';
import 'package:travellookup/blocs/sign_in_bloc.dart';
import 'package:travellookup/core/constants/colors.dart';
import 'package:travellookup/core/utils/next_screen.dart';
import 'package:travellookup/core/utils/responsive_size.dart';
import 'package:travellookup/pages/done.dart';
import 'package:travellookup/router/app_routes.dart';
import 'package:travellookup/widgets/text_field.dart';
import 'package:travellookup/widgets/button.dart';
import 'package:travellookup/widgets/title_text.dart';
import 'package:travellookup/widgets/top_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/outlined_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool googleSignInStarted = false;
  bool verify = true;
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  handleEmailSignIn() async {
    setState(() {
      isLoading = true;
    });
    final sb = context.read<SignInBloc>();
    final ib = context.read<InternetBloc>();

    String email = emailController.text;
    String password = passwordController.text;

    await ib.checkInternet();
    if (ib.hasInternet == false) {
      Get.snackbar("Error", 'Check your internet connection!');
    } else {
      final user = await sb.signInWithEmail(email, password);
      if (user == null) {
        Get.snackbar("Error", 'Something is wrong. Please try again.');
      } 
      else if(!sb.isEmailVerified && verify){
        Get.snackbar("Error", 'Please verify your email first.');
      }
      else {
        sb.checkUserExists().then((value) {
          if (value == true) {
            sb
                .getUserDatafromFirebase(sb.uid)
                .then((value) => sb.saveDataToSP())
                .then((value) => sb.guestSignout())
                .then((value) => sb.setSignIn());
            afterSignIn();
          }
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  afterSignIn() {
    nextScreen(context, DonePage());
  }

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    String title = "Đăng nhập";
    String imgPath = "assets/images/login.png";
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopImage(
              imgPath: imgPath,
              size: Responsive.horizontalSize(360 * 0.67),
            ),
            TitleText(title: title),
            SizedBox(
              height: Responsive.verticalSize(15),
            ),
            MyTextField(
              controller: emailController,
              hintText: "email",
              keyboardType: TextInputType.emailAddress,
              width: width * 0.8,
              icon: const Icon(FontAwesomeIcons.at, size: 17),
            ),
            SizedBox(
              height: Responsive.verticalSize(20),
            ),
            MyTextField(
              controller: passwordController,
              hintText: "password",
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              width: width * 0.8,
              icon: const Icon(Icons.lock_outline_rounded, size: 19),
              suffixText: "Quên?",
              onSuffixTap: () => Get.toNamed(AppRoutes.forgot),
            ),
            SizedBox(
              height: Responsive.verticalSize(30),
            ),
            //Login button
            MyButton(
              showCircularBar: isLoading,
              onTap: () => handleEmailSignIn(),
              text: "Đăng nhập",
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Responsive.verticalSize(20),
                  bottom: Responsive.verticalSize(20)),
              child: Center(
                child: Text(
                  "Hoặc, đăng nhập với...",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => handleGoogleSignIn(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: googleSignInStarted == false
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyOutlinedButton(
                            onTap: () => handleGoogleSignIn(),
                            child: Image.asset(
                              "assets/images/google.png",
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Google',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white),
                    ),
            ),
            SizedBox(
              height: Responsive.verticalSize(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Không có tài khoản? ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.signup),
                  child: Text(
                    "Đăng ký",
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
    );
  }
}
