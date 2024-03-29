import 'package:attendify/views/screens/auth/signup_screen.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../widgets/dark_button.dart';
import '../../widgets/text_input_field.dart';
import '../home/home_traveller_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 25,
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
                  height: 30,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : DarkButton(
                        onPressed: () => getUserIn(context),
                  text: "Login",
                      ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: const Text(
                        "Register",
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
        ],
      ),
    );
  }

  Future<void> getUserIn(BuildContext context) async {
    // Set _isLoading to true when login process starts
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    DisplayToast disp = DisplayToast();

    if (email.isEmpty) {
      disp.toast("Email can't be empty");
      // Set _isLoading to false when login process finishes with an error
      setState(() {
        _isLoading = false;
      });
    } else if (password.isEmpty) {
      disp.toast("Password can't be empty");
      setState(() {
        _isLoading = false;
      });
    } else {
      String result = await _authController.signinUser(
          _emailController.text, _passwordController.text, context);

      if (result == "Success") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeTravellerScreen();
        }));
      } else {
        disp.toast(result);
        // Set _isLoading to false when login process finishes with an error
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
