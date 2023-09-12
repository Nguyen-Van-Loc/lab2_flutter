import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:lab2a/Theme/provider_theme.dart';
import 'Model/image.dart';
import 'main.dart';

class MyView extends State<MyApp> {
  File? imageFile;
  int columId = 1;
  String title = "",
      describe = "";
  List<ImageView> list = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  final check = GlobalKey<FormState>();

  Future<void> selectImage(BuildContext context) async {
    final status = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (status == null) return;
    setState(() {
      imageFile = File(status.path);
    });
    Navigator.of(context).pop();
    ShowDialog(context);
  }
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
  void reset() {
    imageFile = null;
    titleController.clear();
    describeController.clear();
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

  Future<Future> ShowDialog(BuildContext context) async {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Form(
                key: check,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () {
                          selectImage(context);
                        },
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: imageFile != null
                              ? Image.file(imageFile!)
                              : const Icon(Icons.image, size: 50),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Tên hình ảnh không được để trống";
                        }
                        return null;
                      },
                      onChanged: (value) => title = value,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          labelText: "Tên hình ảnh",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: describeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mô tả không được để trống";
                        }
                        return null;
                      },
                      onChanged: (value) => describe = value,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          labelText: "Mô tả",
                          border: OutlineInputBorder()),
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
                              if (check.currentState!.validate()) {
                                if (imageFile==null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Vui lòng chọn ảnh',style: TextStyle(color: Colors.white),),
                                    ),
                                  );
                                }else{
                                  ImageView ima = ImageView(columId, imageFile!, title, describe);
                                  addImage(ima);
                                  reset();
                                  Navigator.of(context).pop();
                                }

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
              ),
            );
          });
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
              ShowDialog(context);
            },
            child: const Icon(Icons.add_photo_alternate),
          ),
        ]),
      ),
    ]);
  }
}
