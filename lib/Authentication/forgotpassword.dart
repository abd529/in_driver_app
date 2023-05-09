import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/utils/mycolors.dart';
import 'login.dart';
import '/widgets/mybutton.dart';
import '/widgets/textformfield.dart';


class ForgitPassword extends StatefulWidget {
  const ForgitPassword({super.key});

  @override
  State<ForgitPassword> createState() => _ForgitPasswordState();
}

class _ForgitPasswordState extends State<ForgitPassword> {
  final TextEditingController _email = TextEditingController();
  //key for handling Auth
  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  void _showetoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Image(
                      fit: BoxFit.cover,
                      height: 400,
                      width: 400,
                      image: AssetImage('assets/logo.png')),
                ),
                const Text(
                  "Reset Your Password",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                    validator: (value) {
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    textEditingController: _email,
                    hintText: "Enter Your Email",
                    textInputType: TextInputType.visiblePassword),
                const SizedBox(
                  height: 30,
                ),
                MyCustomButton(
                    title: "Save",
                    borderrad: 25,
                    onaction: () {
                      if (formGlobalKey.currentState!.validate()) {
                       // FirebaseAuthMethod().resetPassword(_email.text);
                       // Get.to(() => LoginPage());
                        _showetoast("Details Send to your email");
                      } else
                        _showetoast("Please a valid email address");
                    },
                    color1: red,
                    color2: red,
                    width: MediaQuery.of(context).size.width - 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
