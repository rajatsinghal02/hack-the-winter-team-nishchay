import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isConnected = false;

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "CAMERA SPECS",
      "data": [
        {"title": "1/1.8 inch", "subtitle": "SENSOR"},
        {"title": "4K/60 fps", "subtitle": "VIDEO"},
        {"title": "155 °", "subtitle": "SUPER-WIDE FOV"},
        {"title": "CINELIKE", "subtitle": "COLOR MODE"},
      ],
    },
    {
      "title": "SENSORS SPECS",
      "data": [
        {"title": "IMU 6-Axis", "subtitle": "GYROSCOPE"},
        {"title": "+/- 0.1m", "subtitle": "DEPTH ACCURACY"},
        {"title": "Compass", "subtitle": "HEADING"},
        {"title": "Barometer", "subtitle": "PRESSURE"},
      ],
    },
    {
      "title": "BATTERY MONITOR",
      "data": [
        {"title": "85%", "subtitle": "REMAINING"},
        {"title": "14.8 V", "subtitle": "VOLTAGE"},
        {"title": "42 °C", "subtitle": "TEMP"},
        {"title": "2h 15m", "subtitle": "FLIGHT TIME"},
      ],
    },
  ];

  void _showConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF152228),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Connect to ROV",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Color(0xFFD2F63F),
                ),
                title: Text(
                  "Step 1",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                subtitle: Text(
                  "Turn on your ROV/Drone",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Divider(color: Colors.white24),
              const ListTile(
                leading: Icon(Icons.wifi, color: Color(0xFFD2F63F)),
                title: Text(
                  "Step 2",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                subtitle: Text(
                  "Connect phone to 'ROV_Network'",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2F63F),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _isConnected = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Connected"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    "INITIALIZE CONNECTION",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _tabs[_selectedIndex]["data"] as List;
    final size = MediaQuery.of(context).size;

    // NO SCAFFOLD HERE - Just the content container
    return Container(
      color: const Color(0xFF050916),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120, top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: size.height * 0.32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 20,
                        width: size.width * 0.8,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Positioned(
                        right: 60,
                        bottom: 100,
                        child: Icon(
                          Icons.circle_outlined,
                          color: Colors.white54,
                          size: 12,
                        ),
                      ),
                      const Positioned(
                        left: 60,
                        top: 80,
                        child: Icon(
                          Icons.circle_outlined,
                          color: Colors.white54,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Jaltejas 2.0",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: _isConnected ? null : _showConnectionDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _isConnected
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _isConnected
                                ? Colors.green
                                : const Color(0xFFD2F63F),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isConnected ? Icons.link : Icons.link_off,
                              color: _isConnected
                                  ? Colors.white
                                  : const Color(0xFFD2F63F),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isConnected ? "CONNECTED" : "CONNECT ROV",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: List.generate(
                    _tabs.length,
                    (index) => _buildTabItem(
                      _tabs[index]["title"],
                      index == _selectedIndex,
                      index,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            _buildSpecCard(
                              currentData[0]["title"],
                              currentData[0]["subtitle"],
                            ),
                            const SizedBox(width: 15),
                            _buildSpecCard(
                              currentData[1]["title"],
                              currentData[1]["subtitle"],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _buildSpecCard(
                              currentData[2]["title"],
                              currentData[2]["subtitle"],
                            ),
                            const SizedBox(width: 15),
                            _buildSpecCard(
                              currentData[3]["title"],
                              currentData[3]["subtitle"],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2F63F),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1C2C31),
                          width: 5,
                        ),
                      ),
                      child: Icon(
                        _selectedIndex == 0
                            ? Icons.camera_alt_outlined
                            : _selectedIndex == 1
                            ? Icons.sensors
                            : Icons.battery_charging_full,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, bool isSelected, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD2F63F) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecCard(String title, String subtitle) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFD2F63F),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
