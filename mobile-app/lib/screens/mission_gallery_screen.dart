import 'package:flutter/material.dart';
import 'image_viewer_screen.dart';

class MissionGalleryScreen extends StatelessWidget {
  final List<String> imageUrls;
  final String missionName;

  const MissionGalleryScreen({
    super.key,
    required this.imageUrls,
    this.missionName = "Mission Gallery",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050916),
        title: Text(
          missionName,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: imageUrls.isEmpty
          ? const Center(
              child: Text(
                "No images captured.",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0, // Square images
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final url = imageUrls[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageViewerScreen(imageUrl: url),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.white10),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
