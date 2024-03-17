import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  // Method to pick images
  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      // Pick multiple images
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    // Pick single image
    final XFile? file = await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
    if (file != null) {
      return [file];
    }
    return [];
  }

  // Method to pick videos
  Future<XFile?> pickVideo({
    ImageSource source = ImageSource.gallery,
  }) async {
    // Pick video
    final XFile? file = await _imagePicker.pickVideo(source: source);
    return file;
  }

  // Method to crop images
  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    // Crop image
    return await _imageCropper.cropImage(
      sourcePath: file.path,
      cropStyle: cropStyle,
      compressQuality: 100,
      uiSettings: [
        IOSUiSettings(),
        AndroidUiSettings(),
      ],
    );
  }
}
