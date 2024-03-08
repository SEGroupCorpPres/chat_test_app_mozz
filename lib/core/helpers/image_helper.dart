import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    final XFile? file = await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
    if (file != null) return [file];
    return [];
  }

  Future<XFile?> pickVideo({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    final XFile? file = await _imagePicker.pickVideo(source: source);
    return file;
  }

  Future<CroppedFile?> crop({required XFile file, CropStyle cropStyle = CropStyle.rectangle}) async => await _imageCropper.cropImage(
        sourcePath: file.path,
        cropStyle: cropStyle,
        compressQuality: 100,
        uiSettings: [
          IOSUiSettings(),
          AndroidUiSettings(),
        ],
      );
}
