import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge.dart' as B;
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/product_grid.dart';
import '../models/cart.dart';

enum FilterOptions { Favorite, All }

class ProductsOverviewPage extends StatefulWidget {
  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            elevation: 6,
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.filter_list_alt,
              color: Colors.white,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Somente Favoritos',
                    style: TextStyle(color: Colors.white)),
                value: FilterOptions.Favorite,
              ),
              const PopupMenuItem(
                child: Text('Todos', style: TextStyle(color: Colors.white)),
                value: FilterOptions.All,
              )
            ],
            onSelected: (value) {
              setState(() {
                if (value == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (context, value, child) =>
                B.Badge(value: value.itemsCount.toString(), child: child!),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
