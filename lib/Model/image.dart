import 'dart:io';

class ImageView{
  int _id;
  File _image;
  String _title;
  String _text;

  ImageView(this._id, this._image, this._title, this._text);

  String get text => _text;

  set text(String value) {
    _text = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  File get image => _image;

  set image(File value) {
    _image = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}