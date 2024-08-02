import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Screen/home_screen.dart';
import 'package:frontend/Screen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "", phone = "", vehicleNumber = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future<void> registration() async {
    if (password.isNotEmpty && name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && vehicleNumber.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.129:4000/api/driver/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,
            'email': email,
            'phone': phone,
            'vehicleNumber': vehicleNumber,
            'password': password,
          }),
        );

        if (response.statusCode == 201) {
          // Assuming the response includes a token
          final responseBody = json.decode(response.body);
          final token = responseBody['token']; // Adjust based on your API response

          if (token != null) {
            await _storeToken(token);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Registered Successfully",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  'Token not received, please try again',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }
        } else {
          final errorMessage = json.decode(response.body)['message'] ?? 'An error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                errorMessage,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Something went wrong",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/car.PNG",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    buildInputField(
                      controller: namecontroller,
                      hintText: "Name",
                      validatorMessage: 'Please Enter Name',
                    ),
                    const SizedBox(height: 30.0),
                    buildInputField(
                      controller: mailcontroller,
                      hintText: "Email",
                      validatorMessage: 'Please Enter Email',
                    ),
                    const SizedBox(height: 30.0),
                    buildInputField(
                      controller: phonecontroller,
                      hintText: "Phone",
                      validatorMessage: 'Please Enter Phone Number',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 30.0),
                    buildInputField(
                      controller: vehicleNumberController,
                      hintText: "Vehicle Number",
                      validatorMessage: 'Please Enter Vehicle Number',
                    ),
                    const SizedBox(height: 30.0),
                    buildInputField(
                      controller: passwordcontroller,
                      hintText: "Password",
                      validatorMessage: 'Please Enter Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = mailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                            phone = phonecontroller.text;
                            vehicleNumber = vehicleNumberController.text;
                          });
                          registration();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF273671),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            const Text(
              "or LogIn with",
              style: TextStyle(
                color: Color(0xFF273671),
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/google.png",
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 30.0),
                Image.asset(
                  "images/apple1.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Color(0xFF8c8e98),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    );
                  },
                  child: const Text(
                    "LogIn",
                    style: TextStyle(
                      color: Color(0xFF273671),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
  required TextEditingController controller,
  required String hintText,
  required String validatorMessage,
  bool obscureText = false,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
    decoration: BoxDecoration(
      color: const Color(0xFFedf0f8),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (hintText == "Phone") {
          // Check if the phone number is 10 digits long
          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            return 'Please enter a valid 10-digit phone number';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFb2b7bf),
          fontSize: 18.0,
        ),
      ),
    ),
  );
}

}
