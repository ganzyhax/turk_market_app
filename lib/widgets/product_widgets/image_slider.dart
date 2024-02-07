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
      height: 350,
      child: PageView.builder(
        itemCount: images.length, // Use images.length here
        onPageChanged: onChange,
        controller:
            PageController(initialPage: currentImage), // Add PageController
        itemBuilder: (context, index) {
          return PhotoView(
            backgroundDecoration: BoxDecoration(
              color: Colors.transparent, // Set a transparent background color
            ),
            minScale: PhotoViewComputedScale.contained,
            imageProvider: NetworkImage(
              images[index],
            ),
          ); // Use index to access images
        },
      ),
    );
  }
}
