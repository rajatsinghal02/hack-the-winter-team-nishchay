import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String pilotId;

  const ProfileScreen({super.key, required this.pilotId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _name;
  String? _phone;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPilotData();
  }

  Future<void> _fetchPilotData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pilots')
          .where('pilotId', isEqualTo: widget.pilotId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          _name = data['Name']?.toString() ?? 'N/A';
          _phone = data['Phone']?.toString() ?? 'N/A';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Pilot not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD2F63F)),
            )
          : _error != null
          ? Center(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD2F63F).withValues(alpha: 0.1),
                      border: Border.all(
                        color: const Color(0xFFD2F63F),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFFD2F63F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Info Cards
                  _buildInfoCard("PILOT ID", widget.pilotId, Icons.badge),
                  const SizedBox(height: 16),
                  _buildInfoCard("NAME", _name ?? '-', Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildInfoCard("PHONE", _phone ?? '-', Icons.phone),

                  const SizedBox(height: 40),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Clear session
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('user_pilot_id');

                        if (context.mounted) {
                          // Navigate to Login Screen (clearing history)
                          // Note: Using a direct route here since routes might not be defined in MaterialApp
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/', (route) => false);
                          // Or if '/' is not defined as Onboarding/Login, we should push replacement
                          // But usually clearing stack and going to Onboarding is safest.
                          // Actually, let's manually push OnboardingScreen or LoginScreen.
                          // The user asked to "show login screen".
                          // But main.dart logic resets to Onboarding if null.
                          // Let's go to LoginScreen directly for "professional" feel?
                          // Or Onboarding? The user said "show login screen to logoin".
                          // Let's import LoginScreen and push it.
                          // Actually, main.dart logic uses OnboardingScreen as default home.
                          // Let's restart the app effectively by going to Onboarding.
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                        foregroundColor: Colors.redAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Colors.redAccent,
                            width: 1,
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      child: const Text("LOGOUT"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 24),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
