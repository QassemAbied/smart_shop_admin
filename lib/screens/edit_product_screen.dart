import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_store_admin/screens/home_screen.dart';
import 'package:new_store_admin/screens/search/search_screen.dart';
import 'package:new_store_admin/service/my_app_method.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/product_provider.dart';
import '../widget/auth/auth_dialog.dart';
import '../widget/text_widget.dart';
import '../widget/title_text_widget.dart';
import 'loading_screen.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    super.key,
    required this.productId,
    required this.category,
    required this.name,
    required this.price,
    required this.qty,
    required this.description,
    required this.image,
  });
  final String productId, category, name, price, qty, description, image;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  List<String> dropMenu = [
    'Watch',
    'Shoes',
    'Mobiles',
    'pc',
    'Fashion',
    'Elec',
    'Cosmetics',
    'Book',
  ];
  String? selectValue;

  TextEditingController productTitleController = TextEditingController();
  final FocusNode productTitleFocusNode = FocusNode();
  TextEditingController productPriceController = TextEditingController();
  final FocusNode productPriceFocusNode = FocusNode();
  TextEditingController productQtyController = TextEditingController();
  final FocusNode productQtyFocusNode = FocusNode();
  TextEditingController productDescriptionController = TextEditingController();
  final FocusNode productDescriptionFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    productTitleController.dispose();
    productTitleFocusNode.dispose();
    productPriceController.dispose();
    productPriceFocusNode.dispose();
    productQtyController.dispose();
    productQtyFocusNode.dispose();
    productDescriptionController.dispose();
    productDescriptionFocusNode.dispose();
    super.dispose();
  }

  XFile? image;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Future uploadImageProduct(dynamic _image) async {
    final _uuid = Uuid().v4();
    Reference ref = storage.ref().child('imageProduct').child(_uuid + 'png');
    UploadTask uploadTask = ref.putFile(File(image!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downLoad = await taskSnapshot.ref.getDownloadURL();
    return downLoad;
  }

  uploadProductToFirebase() async {
    final valid = formKey.currentState!.validate();
    if (valid) {
      setState(() {
        isLoading = true;
      });
      //String imageUrl=await uploadImageProduct(image);
      try {
        await fireStore.collection('product').doc(widget.productId).update({
          'productId': widget.productId,
          // 'productImage':widget.image ?? imageUrl,
          'productName': productTitleController.text,
          'productCategory': selectValue,
          'productPrice': productPriceController.text,
          'productQty': productQtyController.text,
          'productDescription': productDescriptionController.text,
          'createAt': Timestamp.now(),
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => InspectAllProduct()));
        await MethodApp.ToastBar(text: 'Modified successfully');
      } on FirebaseException catch (error) {
        showAlertDialogRegister(
          context: context,
          text: 'have you error',
          contentText: '${error.code}',
        );
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        showAlertDialogRegister(
          context: context,
          text: 'have you error',
          contentText: '$error',
        );
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  clearForm() {
    productTitleController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    productQtyController.clear();
    selectValue = null;

    image = null;
  }

  @override
  void initState() {
    setState(() {
      productTitleController.text = widget.name;
      productPriceController.text = widget.price;
      productQtyController.text = widget.qty;
      productDescriptionController.text = widget.description;
      selectValue = widget.category;
      //image= widget.image ;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManagerScreen(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const TitleTextWidget(
            text: 'Upload New Product',
            color: Colors.black,
          ),
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child:
                Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                          height: 140,
                          width: 120,
                          color: Colors.amber,
                          child: Image(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        imagePicker();
                      },
                      child: const TitleTextWidget(
                          text: 'Select Author Image', color: Colors.red)),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 250,
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          value: selectValue,
                          hint: TitleTextWidget(
                            text: widget.category,
                            color: Colors.black,
                          ),
                          items: dropMenu
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: TitleTextWidget(
                                text: value,
                                color: Colors.black,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectValue = value;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: productTitleController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      label: const TextWidget(
                        text: 'Title Product',
                        maxLines: 1,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: productPriceController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: const TextWidget(
                              text: 'Price Product',
                              maxLines: 1,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: productQtyController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: const TextWidget(
                              text: 'Quantity Product',
                              maxLines: 1,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: productDescriptionController,
                    cursorColor: Colors.black,
                    maxLines: 3,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      label: const TextWidget(
                        text: 'Description Product',
                        maxLines: 1,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(100, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        label: const TitleTextWidget(
                          text: 'Delete',
                          color: Colors.white,
                        ),
                        icon: const Icon(Icons.clear),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          minimumSize: const Size(180, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          uploadProductToFirebase();
                        },
                        label: const TitleTextWidget(
                          text: 'Upload',
                          color: Colors.black,
                        ),
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
}
