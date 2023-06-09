import 'dart:typed_data';

import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({Key? key, required this.image, this.removeImage})
      : super(key: key);
  final Uint8List image;
  final void Function()? removeImage;

  @override
  Widget build(BuildContext context) {
    final showRemove = removeImage != null;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.fromSize(
            size: const Size.fromRadius(38),
            child: Image.memory(image, fit: BoxFit.cover),
          ),
        ),
        showRemove
            ? Positioned(
                top: -8,
                right: -8,
                child: ElevatedButton(
                  onPressed: () => removeImage != null ? removeImage!() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: removeImage != null
                        ? Colors.red
                        : Colors.grey, // Set background color to red
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(
                        4), // Adjust the padding to make the button smaller
                    minimumSize:
                        const Size(24, 24), // Set a minimum size for the button
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size:
                        16, // Adjust the size of the icon to fit the smaller button
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
