import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VehicleImageComponent extends StatelessWidget {
  final String? imageName;
  final String? imageAssetPath;
  final XFile? imageValue;
  final Function()? setImage;
  final Function()? removeImage;
  final bool imageLoading;

  const VehicleImageComponent({
    Key? key,
    required this.imageName,
    required this.imageValue,
    required this.setImage,
    required this.removeImage,
    required this.imageAssetPath,
    required this.imageLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: imageValue == null
                      ? AssetImage(imageAssetPath!)
                      : FileImage(File(imageValue!.path)) as ImageProvider),
            ),
          ),
        ),
        imageValue == null
            ? const SizedBox()
            : Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: removeImage,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
        imageValue == null
            ? imageLoading
                ? Positioned.fill(
                    child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ))
                : Positioned.fill(
                    child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 40.0,
                                color: Colors.black,
                              ),
                              onPressed: setImage,
                            )),
                        Text(
                          imageName!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              backgroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ))
            : const SizedBox(),
      ],
    );
  }
}
