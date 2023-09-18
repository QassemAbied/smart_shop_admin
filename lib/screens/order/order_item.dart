import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import '../../widget/text_widget.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.price,
      required this.qty,
      required this.order});
  final String image, title, price, qty;
  final Timestamp order;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final orderModel = widget.order;
    final orderDate = orderModel.toDate();
    orderDateToShow = '${orderDate.day}/ ${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FancyShimmerImage(
                imageUrl: widget.image,
                boxFit: BoxFit.fill,
                height: 140,
                width: size.width * 0.33,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: widget.title,
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                    sizeText: 20,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'qeuty : ${widget.qty}',
                    maxLines: 1,
                    sizeText: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: orderDateToShow,
                    maxLines: 1,
                    sizeText: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.clear),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
