import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rov_controller/screens/mission_gallery_screen.dart';
import 'package:rov_controller/screens/flight_screen.dart';

class MissionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> mission;

  const MissionDetailScreen({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    // Format Date
    String dateStr = "";
    if (mission['date'] is Timestamp) {
      final dt = (mission['date'] as Timestamp).toDate();
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
      // Add time if needed:  at ${dt.hour}:${dt.minute}
    } else {
      dateStr = mission['date'].toString();
    }

    final imageUrl = mission['imageUrl'] ?? "";
    final status = mission['status'] ?? "UNKNOWN";
    final location = mission['location'] ?? "Unknown Location";
    final depth = mission['depth']?.toString() ?? "--";
    final duration = mission['duration']?.toString() ?? "--";
    final missionName =
        mission['mission_name'] ?? mission['name'] ?? "Mission Details";
    final missionId = mission['mission_id'] ?? "ID: --";

    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      body: CustomScrollView(
        slivers: [
          // 1. SLIVER APP BAR with Image
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF050916),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                missionName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white10,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white24,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient Overlay for readability
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC050916)],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge & ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: status == "COMPLETE"
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FlightScreen(mission: mission),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD2F63F).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFD2F63F).withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Icon(
                            Icons.sports_esports,
                            color: Color(0xFFD2F63F),
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        missionId,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          fontFamily: 'Courier', // Monospaced for ID
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Info Grid
                  const Text(
                    "MISSION STATISTICS",
                    style: TextStyle(
                      color: Color(0xFFD2F63F),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow(Icons.place, "Location", location),
                        const Divider(color: Colors.white10, height: 30),
                        _buildStatRow(Icons.calendar_today, "Date", dateStr),
                        const Divider(color: Colors.white10, height: 30),
                        _buildStatRow(
                          Icons.arrow_downward,
                          "Max Depth",
                          "${depth}m",
                        ),
                        const Divider(color: Colors.white10, height: 30),
                        _buildStatRow(Icons.timer, "Duration", duration),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Captured Images Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CAPTURED IMAGES",
                        style: TextStyle(
                          color: Color(0xFFD2F63F),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MissionGalleryScreen(
                                missionName: missionName,
                                imageUrls: List.generate(
                                  12,
                                  (index) =>
                                      "https://picsum.photos/200?random=$index",
                                ), // Mock Data
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "View All",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://picsum.photos/200",
                              ), // Placeholder
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Actions
                  const Text(
                    "ACTIONS",
                    style: TextStyle(
                      color: Color(0xFFD2F63F),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.download,
                          label: "Download Logs",
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.play_arrow,
                          label: "View Replay",
                          onTap: () {},
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 15),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFFD2F63F)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: isPrimary ? null : Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.black : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
