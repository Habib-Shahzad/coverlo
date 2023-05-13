import 'dart:typed_data';
import 'package:coverlo/constants.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:image/image.dart' as img;

Uint8List? imageBytesResize(List<int>? imageBytes) {
  if (imageBytes == null) return null;
  Uint8List bytes = Uint8List.fromList(imageBytes);
  img.Image? image = img.decodeImage(bytes);
  if (image == null) return null;
  int width = image.width;
  int height = image.height;

  if (width > 1000 || height > 1000) {
    double scale = width > height ? 1000 / width : 1000 / height;
    int newWidth = (width * scale).floor();
    int newHeight = (height * scale).floor();
    img.Image resizedImage =
        img.copyResize(image, width: newWidth, height: newHeight);

    bytes = Uint8List.fromList(img.encodePng(resizedImage));
  }
  return bytes;
}

getImages(productValue) {
  if (productValue != null) {
    bool isCar = productValue! == privateCar || productValue! == thirdParty;

    if (isCar) {
      return [
        if (bytesCarFront != null)
          {
            "IMAGE_NAME": "car-front.jpg",
            "IMAGE_STRING": bytesToBase64(bytesCarFront)
          },
        if (bytesCarBack != null)
          {
            "IMAGE_NAME": "car-back.jpg",
            "IMAGE_STRING": bytesToBase64(bytesCarBack)
          },
        if (bytesCarLeft != null)
          {
            "IMAGE_NAME": "car-left.jpg",
            "IMAGE_STRING": bytesToBase64(bytesCarLeft)
          },
        if (bytesCarRight != null)
          {
            "IMAGE_NAME": "car-right.jpg",
            "IMAGE_STRING": bytesToBase64(bytesCarRight)
          },
        if (bytesCarHood != null)
          {
            "IMAGE_NAME": "car-hood.jpg",
            "IMAGE_STRING": bytesToBase64(bytesCarHood)
          },
        if (bytesCarBoot != null)
          {
            "IMAGE_NAME": "car-boot.jpg",
            "IMAGE_STRING": bytesToBase64(bytesCarBoot)
          },
      ];
    } else {
      return [
        if (bytesBikeFront != null)
          {
            "IMAGE_NAME": "bike-front.jpg",
            "IMAGE_STRING": bytesToBase64(bytesBikeFront)
          },
        if (bytesBikeBack != null)
          {
            "IMAGE_NAME": "bike-back.jpg",
            "IMAGE_STRING": bytesToBase64(bytesBikeBack)
          },
        if (bytesBikeLeft != null)
          {
            "IMAGE_NAME": "bike-left.jpg",
            "IMAGE_STRING": bytesToBase64(bytesBikeLeft)
          },
        if (bytesBikeRight != null)
          {
            "IMAGE_NAME": "bike-right.jpg",
            "IMAGE_STRING": bytesToBase64(bytesBikeRight)
          },
      ];
    }
  }
}
