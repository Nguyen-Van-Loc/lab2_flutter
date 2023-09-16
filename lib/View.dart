import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab2a/validate.dart';
import 'dart:io';
import 'Model/image.dart';
import 'main.dart';

class MyView extends State<MyApp> {
  File? imageFile;
  int columId = 0;
  String title = "", describe = "";
  List<ImageView> list = [];
  String titleErr = "", describeErr = "";

  void addImage(ImageView imageView) {
    setState(() {
      columId++;
      list.add(imageView);
    });
  }

  void deleteImage(int id) {
    setState(() {
      list.removeWhere((element) => element.id == id);
    });
    Navigator.of(context).pop();
  }

  Future<void> ShowDelete(BuildContext context, ImageView imageView) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                "Thông báo",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
              ),
              content: Text(
                "Bạn có chắc chắn muốn xóa ${imageView.title} không ?",
                style: const TextStyle(fontSize: 18),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Hủy"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        deleteImage(imageView.id);
                      },
                      child: const Text("Xác nhận"),
                    )
                  ],
                ),
              ]);
        });
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogWithValidation(
          onImageAdded: (String title, String description, File image) {
            final ImageView imageView =
                ImageView(columId, image, title, description);
            addImage(imageView);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 5),
                onTap: () {},
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 130, height: 100, child: Image.file(item.image)),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Tên ảnh: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "CrimsonText-SemiBoldItalic"),
                              ),
                              Text(item.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "CrimsonText-SemiBoldItalic"))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Mô tả: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily:
                                          "CrimsonText-SemiBoldItalic")),
                              SizedBox(
                                width: 120,
                                child: Text(item.text,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: "CrimsonText-SemiBoldItalic",
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ShowDelete(context, item);
                      },
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
              ),
            );
          }),
      Positioned(
        bottom: 15,
        left: 0,
        right: 0,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FloatingActionButton(
            onPressed: () {
              _showDialog();
              // ShowDialog(context);
            },
            child: const Icon(Icons.add_photo_alternate),
          ),
        ]),
      ),
    ]);
  }
}

class DialogWithValidation extends StatefulWidget {
  final Function(String, String, File) onImageAdded;

  DialogWithValidation({required this.onImageAdded});

  @override
  _DialogWithValidationState createState() => _DialogWithValidationState();
}

class _DialogWithValidationState extends State<DialogWithValidation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? image;
  String errorTextTitle = "";
  String errorTextDescription = "";

  void check1() {
    setState(() {
      errorTextTitle = validateTitle(titleController.text);
    });
  }

  void check2() {
    setState(() {
      errorTextDescription = validateDescribe(descriptionController.text);
    });
  }

  void onSave() {
    check1();
    if (errorTextTitle.isEmpty) {
      check2();
      if (errorTextDescription.isEmpty) {
        widget.onImageAdded(
            titleController.text, descriptionController.text, image!);
        Navigator.of(context).pop();
      }
    }
  }

  void _selectImage() async {
    final imagePicker = ImagePicker();
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm ảnh'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
              onTap: () {
                _selectImage();
              },
              child: SizedBox(
                width: 200,
                height: 100,
                child: image != null
                    ? Image.file(image!)
                    : const Icon(Icons.image, size: 50),
              )),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: titleController,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
                errorText: errorTextTitle.isNotEmpty ? errorTextTitle : null,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                labelText: "Tên hình ảnh",
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: descriptionController,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              errorText:
                  errorTextDescription.isNotEmpty ? errorTextDescription : null,
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              labelText: "Mô tả",
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text("Cancer")),
              ElevatedButton(
                  onPressed: () async {
                    if (image == null) {
                      EasyLoading.showError("Vui lòng chọn ảnh");
                    } else {
                      onSave();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("Submit"))
            ],
          )
        ],
      ),
    );
  }
}
