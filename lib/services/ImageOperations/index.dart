import 'package:image_picker/image_picker.dart';

Future getImageRequest() async {
  var image = await ImagePicker.pickImage(
    source: ImageSource.gallery,
  );
  return image;
}
