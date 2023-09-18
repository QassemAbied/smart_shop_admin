import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';
import '../../widget/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class InspectAllProductItems extends StatelessWidget {
  const InspectAllProductItems({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.getProductById(productId);

    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.productImage,
                  boxFit: BoxFit.fill,
                  height: 170,
                  width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              TextWidget(
                text: getCurrentProduct.productName,
                maxLines: 2,
                fontWeight: FontWeight.w500,
                sizeText: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
              Row(
                children: [
                  const TextWidget(
                    text: '\$ ',
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                    sizeText: 18,
                    color: Colors.red,
                  ),
                  TextWidget(
                    text: getCurrentProduct.productPrice,
                    maxLines: 1,
                    fontWeight: FontWeight.w500,
                    sizeText: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          );
  }
}
