import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'flight_screen.dart';

class MainScreen extends StatefulWidget {
  final String pilotId;

  const MainScreen({super.key, required this.pilotId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // The pages to switch between
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(), // Index 0
      ExploreScreen(pilotId: widget.pilotId), // Index 1
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. THE CONTENT (Switches without reloading the bottom bar)
          IndexedStack(index: _currentIndex, children: _pages),

          // 2. THE PERSISTENT BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF0B101E).withValues(alpha: 1.0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Dashboard Tab
                _buildNavItem(
                  Icons.dashboard_outlined,
                  "Dashboard",
                  _currentIndex == 0,
                  () {
                    setState(() => _currentIndex = 0);
                  },
                ),

                const SizedBox(width: 60), // Space for center button
                // Explore Tab
                _buildNavItem(
                  Icons.explore_outlined,
                  "Explore",
                  _currentIndex == 1,
                  () {
                    setState(() => _currentIndex = 1);
                  },
                ),
              ],
            ),
          ),

          // Floating Pilot Button (Still pushes a new screen because it's landscape)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                _showCreateMissionDialog(context);
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2F63F),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD2F63F).withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_esports,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensures the whole area is clickable
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white54, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateMissionDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController imageController =
        TextEditingController(); // Added for Image URL input

    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while loading
      builder: (context) {
        return StatefulBuilder(
          // Use StatefulBuilder to update loading state
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0B101E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Create Mission",
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mission Name Input
                    const Text(
                      "Mission Name",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter mission name",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF1A1F2E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image Input (Replacing Placeholder)
                    const Text(
                      "Mission Image URL",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: imageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter image URL (optional)",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF1A1F2E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location Input
                    const Text(
                      "Location",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: locationController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter location",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF1A1F2E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              locationController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Name and Location are required"),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final String missionName = nameController.text
                                .trim();
                            final String location = locationController.text
                                .trim();
                            String imageUrl = imageController.text.trim();
                            if (imageUrl.isEmpty) {
                              imageUrl =
                                  "https://picsum.photos/seed/rov_default/400/200"; // Default
                            }

                            final String missionId =
                                "Mission-${DateTime.now().millisecondsSinceEpoch}";

                            await FirebaseFirestore.instance
                                .collection('missions')
                                .add({
                                  "mission_id": missionId,
                                  "pilotId": widget.pilotId,
                                  "date": FieldValue.serverTimestamp(),
                                  "location": location,
                                  "mission_name":
                                      missionName, // Store name too if needed, schema didn't explicitly ask but fields imply it
                                  "imageUrl": imageUrl,
                                  "depth": "0",
                                  "duration": "0",
                                  "status": "RUNNING",
                                });

                            if (context.mounted) {
                              Navigator.pop(context); // Close dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FlightScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint("Error creating mission: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2F63F),
                    foregroundColor: Colors.black,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
