import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class FlightScreen extends StatefulWidget {
  final Map<String, dynamic>? mission;
  const FlightScreen({super.key, this.mission});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  // --- UI VARIABLES ---
  bool _isHeaderOpen = true;
  bool _lightsOn = false;
  bool _sensorsActive = false;
  double _tankFillLevel = 0.45;
  Timer? _sensorTimer;

  // Thruster States: 1 (Fwd/CW), 0 (Neutral), -1 (Bwd/CCW)
  int _leftThruster = 0;
  int _rightThruster = 0;
  int _topThruster = 0;

  @override
  void initState() {
    super.initState();
    // 1. Force Landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  // --- UI HELPERS ---
  void _completeMission() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF152228),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text(
            "End Mission",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Powering down systems...",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Mission Status:",
                style: TextStyle(
                  color: Color(0xFFD2F63F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusBtn(
                      "REVIEW",
                      Colors.amber,
                      () => _updateStatusAndClose("REVIEW"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatusBtn(
                      "COMPLETE",
                      Colors.green,
                      () => _updateStatusAndClose("COMPLETE"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatusAndClose(String status) async {
    // Show Loading
    Navigator.pop(context); // Close selection dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFD2F63F)),
      ),
    );

    try {
      if (widget.mission != null && widget.mission!['id'] != null) {
        await FirebaseFirestore.instance
            .collection('missions')
            .doc(widget.mission!['id'])
            .update({'status': status});
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }

    if (mounted) {
      Navigator.pop(context); // Close loading
      Navigator.pop(context); // Close FlightScreen
    }
  }

  void _toggleSensors() {
    setState(() => _sensorsActive = !_sensorsActive);
    if (_sensorsActive) {
      _sensorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (mounted) {
          setState(() => _tankFillLevel = (_tankFillLevel + 0.01) % 1.0);
        }
      });
    } else {
      _sensorTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      body: Stack(
        children: [
          // 1. VIDEO FEED LAYER (Placeholder)
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/800/600', // Placeholder image
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD2F63F)),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          color: Colors.white54,
                          size: 48,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Camera Feed Unavailable",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. DARK GRADIENT
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // 3. UI CONTROLS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // --- HEADER ---
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isHeaderOpen ? 60 : 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildHeader(),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => _isHeaderOpen = !_isHeaderOpen),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Icon(
                        _isHeaderOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFFD2F63F),
                        size: 20,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // --- CONTROLS ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Replaced Joystick with Thruster Switches
                      _buildThrusterControls(),
                      _buildRightControls(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---
  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          if (widget.mission != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD2F63F).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFD2F63F).withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                widget.mission!['mission_name'] ??
                    widget.mission!['name'] ??
                    "MISSION",
                style: const TextStyle(
                  color: Color(0xFFD2F63F),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
          _buildSensorItem(Icons.water, "DEPTH", "14.5 m"),
          const SizedBox(width: 15),
          _buildSensorItem(Icons.thermostat, "TEMP", "12°C"),
          const SizedBox(width: 15),
          _buildSensorItem(Icons.explore, "HEAD", "240° SW"),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: const Row(
              children: [
                Icon(Icons.battery_full, color: Colors.green, size: 16),
                SizedBox(width: 5),
                Text(
                  "85%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: _completeMission,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.redAccent),
              ),
              child: const Icon(
                Icons.power_settings_new,
                color: Colors.redAccent,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorItem(IconData icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFD2F63F), size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Courier',
          ),
        ),
      ],
    );
  }

  Widget _buildThrusterControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildThrusterSwitch(
            label: "LEFT",
            value: _leftThruster,
            onChanged: (val) => setState(() => _leftThruster = val),
          ),
          const SizedBox(width: 20),
          _buildThrusterSwitch(
            label: "TOP",
            value: _topThruster,
            onChanged: (val) => setState(() => _topThruster = val),
          ),
          const SizedBox(width: 20),
          _buildThrusterSwitch(
            label: "RIGHT",
            value: _rightThruster,
            onChanged: (val) => setState(() => _rightThruster = val),
          ),
        ],
      ),
    );
  }

  Widget _buildThrusterSwitch({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    // value: 1 = Forward/Clockwise, 0 = Neutral, -1 = Backup/Anti-Clockwise
    Color activeColor = const Color(0xFFD2F63F);
    bool isActive = value != 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onVerticalDragUpdate: (details) {
            // Simple drag logic
            if (details.delta.dy < -1) {
              if (value != 1) onChanged(1);
            } else if (details.delta.dy > 1) {
              if (value != -1) onChanged(-1);
            }
          },
          onTapUp: (details) {
            // Cycle state on tap? Or maybe set to 0 if active?
            // Let's make tap toggle between neutral and forward, or just cycle 0 -> 1 -> -1 -> 0
            if (value == 0) {
              onChanged(1);
            } else if (value == 1) {
              onChanged(-1);
            } else {
              onChanged(0);
            }
          },
          child: Container(
            width: 40,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? activeColor : Colors.white24,
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // Track Markings
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(width: 20, height: 2, color: Colors.white10),
                      Container(width: 20, height: 2, color: Colors.white10),
                      Container(width: 20, height: 2, color: Colors.white10),
                    ],
                  ),
                ),
                // The Switch Handle
                AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  alignment: value == 1
                      ? Alignment.topCenter
                      : value == -1
                      ? Alignment.bottomCenter
                      : Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isActive ? activeColor : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      value == 1
                          ? Icons.keyboard_arrow_up
                          : value == -1
                          ? Icons.keyboard_arrow_down
                          : Icons.remove,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value == 1
              ? "CW"
              : value == -1
              ? "ACW"
              : "OFF",
          style: TextStyle(
            color: value == 1
                ? activeColor
                : value == -1
                ? Colors.redAccent
                : Colors.white30,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRightControls() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            const Text(
              "TANK",
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
            const SizedBox(height: 5),
            Container(
              height: 150,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 150 * _tankFillLevel,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "${(_tankFillLevel * 100).toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            _buildBtn(
              "LIGHTS",
              _lightsOn ? Icons.lightbulb : Icons.lightbulb_outline,
              _lightsOn,
              Colors.yellow,
              () => setState(() => _lightsOn = !_lightsOn),
            ),
            const SizedBox(height: 15),
            _buildBtn(
              "SENSORS",
              _sensorsActive ? Icons.sensors : Icons.sensors_off,
              _sensorsActive,
              Colors.cyanAccent,
              _toggleSensors,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBtn(
    String label,
    IconData icon,
    bool active,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: active ? color.withValues(alpha: 0.2) : Colors.white10,
              shape: BoxShape.circle,
              border: Border.all(color: active ? color : Colors.white24),
            ),
            child: Icon(icon, color: active ? color : Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 8),
          ),
        ],
      ),
    );
  }
}
