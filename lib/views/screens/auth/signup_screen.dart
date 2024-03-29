import 'dart:ui';

import 'package:attendify/views/widgets/dark_button.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

import '../../../controllers/auth_controller.dart';
import '../../widgets/text_input_field.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Attendify",
                    style: TextStyle(
                        fontSize: 35,
                        color: kBlackColor,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _nameController,
                      icon: Icons.abc,
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _usernameController,
                      icon: Icons.person,
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _passwordController,
                      icon: Icons.lock,
                      labelText: 'Password',
                      isObsecure: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : DarkButton(
                          onPressed: () => onBoardUser(context),
                          text: "Signup",
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: kRedColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onBoardUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text.trim();
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    DisplayToast disp = DisplayToast();

    if (name.isEmpty) {
      disp.toast("Name can't be empty");
      setState(() {
        _isLoading = false;
      });
    } else if (username.isEmpty) {
      disp.toast("PRN can't be empty");
      setState(() {
        _isLoading = false;
      });
    } else if (email.isEmpty) {
      disp.toast("Email can't be empty");
      setState(() {
        _isLoading = false;
      });
    } else if (password.isEmpty) {
      disp.toast("Password can't be empty");
      setState(() {
        _isLoading = false;
      });
    } else {
      String result = await _authController.registerUser(
        _nameController.text,
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        context,
      );

      if (result.isNotEmpty && result == "Success") {
        disp.toast("Account Created Successfully");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        disp.toast("Result");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
