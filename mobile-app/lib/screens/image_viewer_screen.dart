import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Interactive Viewer for Zoom & Pan
          InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: 0.5,
            maxScale: 4.0,''
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.white54, size: 50),
                      SizedBox(height: 10),
                      Text(
                        "Image not available",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Close Button
          Positioned(
            top: 40, // Adjust for status bar if needed, or use SafeArea
            right: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
