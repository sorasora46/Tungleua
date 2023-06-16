import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tungleua/models/product.dart';
import 'package:tungleua/services/product_service.dart';
import 'package:tungleua/styles/button_style.dart';
import 'package:tungleua/styles/text_form_style.dart';
import 'package:tungleua/widgets/rounded_image.dart';
import 'package:tungleua/widgets/show_dialog.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final editProductFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final ImagePicker imgPicker = ImagePicker();

  bool showClearName = false;
  bool showClearDescription = false;
  bool isEditable = false;
  bool isClickValidate = false;

  Product? product;
  String? imageBytes;
  File? image;

  void handleNameChange(value) {
    setState(() {
      showClearName = value.isNotEmpty;
    });
  }

  void handleDescriptionChange(value) {
    setState(() {
      showClearDescription = value.isNotEmpty;
    });
  }

  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your product name.';
    }
    return null;
  }

  String? descriptionValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your product description.';
    }
    return null;
  }

  String? priceValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your product price.';
    }
    return null;
  }

  void handleEditable() {
    setState(() {
      if (isEditable) {
        isEditable = false;
      } else {
        isEditable = true;
      }
    });
  }

  Future<void> handleImagePicker() async {
    try {
      final image = await imgPicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      setState(() {
        this.image = file;
        imageBytes = base64Encode(bytes);
      });
    } catch (e) {
      debugPrint('Image picker error: $e');
      showCustomSnackBar(context, "Error picking image", SnackBarVariant.error);
    }
  }

  void handleRemoveImage() {
    setState(() {
      image = null;
      imageBytes = null;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ProductService()
        .getProductById(widget.productId)
        .then((product) => setState(() {
              this.product = product;
              nameController.text = product!.title;
              descriptionController.text = product.description;
              priceController.text = product.price.toString();
              imageBytes = product.image;
            }));
  }

  Future<void> handleSave() async {
    setState(() {
      isClickValidate = true;
    });

    if (editProductFormKey.currentState!.validate() && imageBytes != null) {
      showCustomSnackBar(
          context, "Updating your Product . . .", SnackBarVariant.info);

      setState(() {
        isEditable = false;
      });

      // final Map<String, dynamic> updates = {
      //   'name': storeNameControlller.text,
      //   'contact': contactController.text,
      //   'time_open': timeOpenController.text,
      //   'time_close': timeCloseController.text,
      //   'latitude': locationController.text.split(',')[0].trim(),
      //   'longitude': locationController.text.split(',')[1].trim(),
      //   'description': descriptionController.text,
      //   'image': imageBytes!,
      // };

      // final isSuccess =
      //     await StoreService().updateStoreByStoreId(store!.id, updates);

      // if (isSuccess) {
      //   if (mounted) {
      //     showCustomSnackBar(
      //         context, "Update success!", SnackBarVariant.success);
      //   }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: <Widget>[
            IconButton(
              onPressed: handleEditable,
              icon: Icon(isEditable ? Icons.edit_off : Icons.edit),
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: editProductFormKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Product Name Field
                                const Text('Product Name'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  enabled: isEditable,
                                  keyboardType: TextInputType.name,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: nameController,
                                  validator: nameValidator,
                                  onChanged: handleNameChange,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: 'Product Name',
                                    suffixIcon: showClearName
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                nameController.clear();
                                                showClearName = false;
                                              });
                                            },
                                            child: const Icon(Icons.clear,
                                                size: 18),
                                          )
                                        : null,
                                    border: formBorder,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Product Detail Field
                                const Text('Product Description'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  enabled: isEditable,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: descriptionController,
                                  validator: descriptionValidator,
                                  onChanged: handleDescriptionChange,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: 'Description',
                                    suffixIcon: showClearDescription
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                descriptionController.clear();
                                                showClearDescription = false;
                                              });
                                            },
                                            child: const Icon(Icons.clear,
                                                size: 18),
                                          )
                                        : null,
                                    border: formBorder,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Product Price Field
                                const Text('Price'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  enabled: isEditable,
                                  onTap: () {},
                                  keyboardType: TextInputType.text,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: priceController,
                                  validator: priceValidator,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: 'Price',
                                    border: formBorder,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text(
                                            'Upload a photo of your Product'),
                                        const SizedBox(height: 10),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(children: <Widget>[
                                            GestureDetector(
                                                onTap: isEditable
                                                    ? handleImagePicker
                                                    : null,
                                                child: DottedBorder(
                                                    color: isClickValidate &&
                                                            imageBytes == null
                                                        ? Colors.red
                                                        : Colors.black,
                                                    borderType:
                                                        BorderType.RRect,
                                                    radius:
                                                        const Radius.circular(
                                                            20),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child:
                                                            SizedBox.fromSize(
                                                                size: const Size
                                                                        .fromRadius(
                                                                    38), // Image radius
                                                                child: Center(
                                                                    child: Icon(
                                                                  Icons
                                                                      .cloud_download,
                                                                  color: isClickValidate &&
                                                                          imageBytes ==
                                                                              null
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black,
                                                                )))))),
                                            if (imageBytes != null)
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: RoundedImage(
                                                      image: base64Decode(
                                                          imageBytes!),
                                                      removeImage: isEditable
                                                          ? handleRemoveImage
                                                          : null))
                                          ]),
                                        ),
                                        const SizedBox(height: 10),
                                        isClickValidate && imageBytes == null
                                            ? const Text(
                                                'Please upload a picture of your Store.',
                                                style: TextStyle(
                                                    color: Colors.red))
                                            : Container(),
                                      ]),
                                ),

                                const Spacer(),

                                // Cancel or Confirm Button
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Cancel Button
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 30),
                                        height: 45,
                                        child: OutlinedButton(
                                            style: roundedOutlineButton,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel')),
                                      ),

                                      const SizedBox(width: 10),

                                      // Save Button
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 30),
                                        height: 45,
                                        child: FilledButton(
                                            style: filledButton,
                                            onPressed:
                                                isEditable ? handleSave : null,
                                            child: const Text('Save')),
                                      ),
                                    ]),
                              ]),
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ));
  }
}