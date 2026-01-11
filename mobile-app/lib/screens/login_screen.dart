import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pilotIdController = TextEditingController();
  final List<TextEditingController> _passcodeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _passcodeFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    _pilotIdController.dispose();
    for (var controller in _passcodeControllers) {
      controller.dispose();
    }
    for (var node in _passcodeFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final pilotId = _pilotIdController.text.trim();
      final passcode = _passcodeControllers.map((c) => c.text).join();

      if (passcode.length != 4) {
        _showErrorKey('Please enter a complete 4-digit passcode');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // query for the pilot ID
        final querySnapshot = await FirebaseFirestore.instance
            .collection('pilots')
            .where('pilotId', isEqualTo: pilotId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          if (mounted) _showErrorKey('You have not registered as pilot');
          return;
        }

        final pilotDoc = querySnapshot.docs.first;
        final Map<String, dynamic> data = pilotDoc.data();
        final dynamic val = data['passcode'];
        final String savedPasscode = val.toString();

        if (savedPasscode == passcode) {
          if (mounted) {
            // Save to Persistent Storage
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_pilot_id', pilotId);

            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainScreen(pilotId: pilotId),
                ),
                (route) => false,
              );
            }
          }
        } else {
          if (mounted) _showErrorKey('Invalid passcode');
        }
      } catch (e) {
        if (mounted) _showErrorKey('Connection error: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showErrorKey(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoHeight = size.height * 0.15;

    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  // Logo
                  Center(
                    child: SizedBox(
                      height: logoHeight,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Welcome Text
                  const Text(
                    "Welcome Back,\nPilot",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your credentials to access the controller",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 50),

                  // Pilot ID Field
                  const Text(
                    "PILOT ID",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pilotIdController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      hintText: "Ex. MAVERICK-01",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD2F63F),
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white54,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilot ID is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Passcode Heading
                  const Text(
                    "PASSCODE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4-Digit Passcode Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: (size.width - 48 - 40) / 4, // Calculate width
                        child: TextFormField(
                          controller: _passcodeControllers[index],
                          focusNode: _passcodeFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFFD2F63F),
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              _passcodeFocusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              // Optional: handle backspace to go back
                            }
                            if (index == 3 && value.isNotEmpty) {
                              // Maybe auto-submit or just close keyboard
                              FocusScope.of(context).unfocus(); // unfocus
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const Spacer(flex: 3),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD2F63F),
                        foregroundColor: const Color(0xFF050916),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF050916),
                              ),
                            )
                          : const Text("INITIALIZE CONNECTION"),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
