import 'package:flutter/material.dart';
import 'package:new_store_admin/screens/search/search_screen.dart';

import '../widget/title_text_widget.dart';
import 'add_product_screen.dart';
import 'order/order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categoryGrid = [
      {
        'image': 'assets/images/dashboard/cloud.png',
        'title': 'add A New Product',
      },
      {
        'image': 'assets/images/bag/shopping_cart.png',
        'title': 'inspect All Products',
      },
      {
        'image': 'assets/images/dashboard/order.png',
        'title': 'All Order',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const TitleTextWidget(
          text: 'Home',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.66,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                  ),
                  itemCount: categoryGrid.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (categoryGrid[index]['title'] ==
                            'add A New Product') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen()));
                        } else if (categoryGrid[index]['title'] ==
                            'inspect All Products') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InspectAllProduct()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OrderScreen()));
                        }
                      },
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(categoryGrid[index]['image']),
                            fit: BoxFit.fill,
                            height: 200,
                            width: 200,
                          ),
                          TitleTextWidget(
                              text: categoryGrid[index]['title'],
                              color: Colors.black),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
