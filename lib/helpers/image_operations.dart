import 'dart:typed_data';
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
