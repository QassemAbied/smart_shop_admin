import 'package:flutter/material.dart';
import 'package:new_store_admin/screens/search/search_item_widget.dart';
import 'package:provider/provider.dart';
import '../../model/product_model.dart';
import '../../provider/product_provider.dart';
import '../../widget/text_widget.dart';
import '../../widget/title_text_widget.dart';
import '../edit_product_screen.dart';

class InspectAllProduct extends StatefulWidget {
  const InspectAllProduct({super.key});
  @override
  State<InspectAllProduct> createState() => _InspectAllProductState();
}

class _InspectAllProductState extends State<InspectAllProduct> {
  TextEditingController searchTextController = TextEditingController();

  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    searchTextController.dispose();
    searchTextFocusNode.dispose();
    super.dispose();
  }

  List<ProductModels> productSearchList = [];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const TitleTextWidget(
            text: 'Search',
            color: Colors.black,
          ),
          //title: AppNamedWidget(),

          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child:
                Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder<Object>(
            stream: productProvider.fetchProductStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: TextWidget(
                    text: 'your have error',
                    maxLines: 1,
                    sizeText: 18,
                    color: Colors.grey,
                  ),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: TextWidget(
                    text: 'no has been data',
                    maxLines: 1,
                    sizeText: 18,
                    color: Colors.grey,
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: searchTextController,
                        cursorColor: Colors.black,
                        onFieldSubmitted: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchTextController.clear();
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
                          label: const TextWidget(
                            text: 'Search',
                            maxLines: 1,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // if(searchTextController.text.isNotEmpty && productSearchList.isEmpty)...[],
                      GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.66,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                          ),
                          itemCount: productProvider.getProduct.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProductScreen(
                                              productId: productProvider
                                                  .getProduct[index].productId,
                                              category: productProvider
                                                  .getProduct[index]
                                                  .productCategory,
                                              name: productProvider
                                                  .getProduct[index]
                                                  .productName,
                                              price: productProvider
                                                  .getProduct[index]
                                                  .productPrice,
                                              qty: productProvider
                                                  .getProduct[index].quantity,
                                              description: productProvider
                                                  .getProduct[index]
                                                  .description,
                                              image: productProvider
                                                  .getProduct[index]
                                                  .productImage,
                                            )));
                              },
                              child: ChangeNotifierProvider.value(
                                value: productProvider.getProduct[index],
                                child: InspectAllProductItems(
                                  productId: productProvider
                                      .getProduct[index].productId,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
