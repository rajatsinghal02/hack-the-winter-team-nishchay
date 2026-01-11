import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'mission_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final String pilotId;

  const ExploreScreen({super.key, required this.pilotId});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedFilter = "All"; // Default filter
  String _totalTime = "--";
  String _maxDepth = "--";

  Future<void> _fetchPilotStats() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pilots')
          .where('pilotId', isEqualTo: widget.pilotId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        if (mounted) {
          setState(() {
            _totalTime = data['total_time']?.toString() ?? "--";
            _maxDepth = data['max_depth']?.toString() ?? "--";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching pilot stats: $e");
    }
  }

  Stream<QuerySnapshot>? _missionsStream;

  @override
  void initState() {
    super.initState();
    _fetchPilotStats();
    _setupMissionsStream();
  }

  void _setupMissionsStream() {
    _missionsStream = FirebaseFirestore.instance
        .collection('missions')
        .where('pilotId', isEqualTo: widget.pilotId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  List<Map<String, dynamic>> _filterMissions(
    List<Map<String, dynamic>> missions,
  ) {
    if (_selectedFilter == "All") return missions;
    if (_selectedFilter == "Recent") {
      // Example: Only from last 30 days or just return first 5
      return missions.take(5).toList();
    }
    if (_selectedFilter == "Completed") {
      return missions.where((m) => m["status"] == "COMPLETE").toList();
    }
    if (_selectedFilter == "Review") {
      return missions.where((m) => m["status"] == "REVIEW").toList();
    }
    return missions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF050916),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "MISSION LOGS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          decoration:
                              TextDecoration.none, // Fix for no Scaffold
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Recent Dives & Analytics",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(pilotId: widget.pilotId),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        color: Color(0xFFD2F63F),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // STATS ROW (Wrapped in Row correctly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard(Icons.access_time, "TOTAL TIME", _totalTime),
                  const SizedBox(width: 15),
                  _buildStatCard(Icons.arrow_downward, "MAX DEPTH", _maxDepth),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // SECTION TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "DIVES",
                style: TextStyle(
                  color: Color(0xFFD2F63F),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // FILTER CHIPS (Horizontal Scroll to prevent overflow)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip("All"),
                  const SizedBox(width: 10),
                  _buildFilterChip("Recent"),
                  const SizedBox(width: 10),
                  _buildFilterChip("Completed"),
                  const SizedBox(width: 10),
                  _buildFilterChip("Review"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // LIST VIEW
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _missionsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // Check for index error specifically
                    final errorStr = snapshot.error.toString();
                    if (errorStr.contains('failed-precondition') ||
                        errorStr.contains('index')) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: SelectableText(
                          "Missing Index! View logs to create it.\n\n$errorStr",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD2F63F),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No missions found",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final missions = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    data['id'] = doc.id; // Inject Document ID
                    return data;
                  }).toList();

                  final filtered = _filterMissions(missions);

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildMissionCard(filtered[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD2F63F)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFD2F63F) : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFD2F63F), size: 24),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    // Format Date from Timestamp
    String dateStr = "";
    if (mission['date'] is Timestamp) {
      final dt = (mission['date'] as Timestamp).toDate();
      // Simple format: DEC 24, 2025 - you might want intl package for better formatting
      const months = [
        "JAN",
        "FEB",
        "MAR",
        "APR",
        "MAY",
        "JUN",
        "JUL",
        "AUG",
        "SEP",
        "OCT",
        "NOV",
        "DEC",
      ];
      dateStr = "${months[dt.month - 1]} ${dt.day}, ${dt.year}";
    } else {
      dateStr = mission['date'].toString();
    }

    // Safety checks for fields
    final imageUrl = mission['imageUrl'] ?? "";
    final status = mission['status'] ?? "UNKNOWN";
    final location = mission['location'] ?? "Unknown Location";
    final depth = mission['depth']?.toString() ?? "--";
    final duration = mission['duration']?.toString() ?? "--";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MissionDetailScreen(mission: mission),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0B101E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: Colors.white10,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: status == "COMPLETE"
                            ? Colors.green
                            : Colors.amber,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == "COMPLETE"
                            ? Colors.greenAccent
                            : Colors.amberAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // DETAILS ROW - FIXED OVERFLOW
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Wrapped Text in Expanded to prevent overflow
                      Expanded(
                        child: Text(
                          mission['mission_name'] ??
                              mission['name'] ??
                              "Mission Details",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Add dots if too long
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.water, size: 16, color: Colors.white54),
                      const SizedBox(width: 5),
                      Text(
                        "${depth}m",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.timer, size: 16, color: Colors.white54),
                      const SizedBox(width: 5),
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Location after duration
                      const Icon(Icons.place, size: 16, color: Colors.white54),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            decoration: TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2F63F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
