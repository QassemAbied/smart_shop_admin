import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widget/text_widget.dart';
import '../../widget/title_text_widget.dart';
import 'order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const TitleTextWidget(
          text: 'All Order',
          color: Colors.black,
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child:
              Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('order').snapshots(),
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
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return OrderItemWidget(
                      image: snapshot.data!.docs[index]['imageUrl'],
                      title: snapshot.data!.docs[index]['title'],
                      price: snapshot.data!.docs[index]['price'],
                      qty: snapshot.data!.docs[index]['quantity'].toString(),
                      order: snapshot.data!.docs[index]['orderDate'],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
