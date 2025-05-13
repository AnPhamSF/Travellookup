import 'package:travellookup/core/utils/responsive_size.dart';
import 'package:travellookup/view/forgot_password/controller/forgot_password_controller.dart';
import 'package:travellookup/widgets/button.dart';
import 'package:travellookup/widgets/text_field.dart';
import 'package:travellookup/widgets/title_text.dart';
import 'package:travellookup/widgets/top_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    ForgotPasswordController controller = Get.find();
    String title = "Quên\nMật khẩu?";
    String imgPath = "assets/images/forgot.png";
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
                onTap: () => Get.back(),
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
                  size: Responsive.horizontalSize(360 * 0.8),
                ),
                TitleText(title: title),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                SizedBox(
                  width: width * 0.8,
                  child: Text(
                    "Đừng lo lắng vì điều đó xảy ra!. Vui lòng nhập địa chỉ email được liên kết với tài khoản của bạn.",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
                  height: Responsive.verticalSize(30),
                ),
                GetBuilder<ForgotPasswordController>(builder: (cont) {
                  return MyButton(
                    showCircularBar: cont.isLoading.value,
                    onTap: () => cont.reset(),
                    text: "Đặt lại mật khẩu",
                  );
                }),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
