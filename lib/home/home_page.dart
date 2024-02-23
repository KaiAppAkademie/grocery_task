import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_task/home/models/cart_item.dart';
import 'package:grocery_task/home/models/cart_model.dart';
import 'package:grocery_task/home/models/product.dart';
import 'package:grocery_task/home/repository/products_repository.dart';
import 'package:grocery_task/home/widgets/action_headline.dart';
import 'package:grocery_task/home/widgets/categories_section.dart';
import 'package:grocery_task/home/widgets/hero_image.dart';
import 'package:grocery_task/home/widgets/product_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _products = ProductsRepository().getProducts();

  final CartController cart = CartController(initialItems: []);

  final List<Product> wishlist = [];

  void onAddItem(Product product) {
    setState(() {
      if (cart.items.any((element) => element.product == product)) {
        cart.items
            .firstWhere((element) => element.product == product)
            .quantity++;
        return;
      } else {
        cart.items.add(
          CartItem(product: product, quantity: 1),
        );
      }
    });
  }

  void onRemoveItem(Product product) {
    setState(() {
      if (cart.items.any((element) => element.product == product) &&
          cart.items
                  .firstWhere((element) => element.product == product)
                  .quantity >
              1) {
        cart.items
            .firstWhere((element) => element.product == product)
            .quantity--;
        return;
      } else {
        cart.items.removeWhere((element) => element.product == product);
      }
    });
  }

  void toggleFavoriteList(Product product) {
    setState(() {
      if (wishlist.contains(product)) {
        wishlist.remove(product);
      } else {
        wishlist.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: const Color(0xffF4F5F9),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search keywords..',
                      prefixIcon: Icon(Icons.search),
                      fillColor: Color(0xffe4e5e9),
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const HeroImage(),
                const SizedBox(height: 20),
                CategoriesSection(),
                const SizedBox(height: 20),
                const ActionHeadline(title: 'Featured products'),
                const SizedBox(height: 12),
                Wrap(
                  runSpacing: 20,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    for (final product in _products)
                      ProductItem(
                        product: product,
                        quantity: cart.items
                            .firstWhere((element) => element.product == product,
                                orElse: () =>
                                    CartItem(product: product, quantity: 0))
                            .quantity,
                        onAddToCart: () => onAddItem(product),
                        onRemoveItem: () => onRemoveItem(product),
                        toggleFavorite: () => toggleFavoriteList(product),
                        isFavorite: wishlist.contains(product),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart),
                label: 'Wishlist',
              ),
            ],
          )),
    );
  }
}
