import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart'; // Import MaterialApp

class ImageSlider extends StatelessWidget {
  final Function(int) onChange;
  final int currentImage;
  final List images; // Change images type to List<String>

  const ImageSlider({
    Key? key, // Corrected key declaration
    required this.onChange,
    required this.images,
    required this.currentImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    images.removeAt(0);
    return SizedBox(
      height: 500,
      child: PageView.builder(
        itemCount: images.length, // Use images.length here
        onPageChanged: onChange,
        controller:
            PageController(initialPage: currentImage), // Add PageController
        itemBuilder: (context, index) {
          return InteractiveViewer(
              panEnabled: true,
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ));
          // Use index to access images
        },
      ),
    );
  }
}
