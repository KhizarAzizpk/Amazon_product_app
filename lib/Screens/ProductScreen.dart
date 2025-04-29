import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/fetching_category.dart';
import '../models/product_model.dart';

class GiftsScreen extends StatefulWidget {
  @override
  _GiftsScreenState createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  late List<Product> _products;
  late int _currentPage;
  late bool _isLoading;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _products = [];
    _currentPage = 1;
    _isLoading = false;
    _scrollController = ScrollController();
    _loadMoreProducts();

    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _loadMoreProducts();
      }
    });
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading) return; // Avoid multiple requests while loading
    setState(() {
      _isLoading = true;
    });

    try {
      final newProducts = await AmazonService.fetchProducts(page: _currentPage);
      setState(() {
        _products.addAll(newProducts);
        _currentPage++; // Move to next page
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load more products')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gifts for Kids')),
      body: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: _products.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return Center(child: CircularProgressIndicator());
          }

          final product = _products[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${double.tryParse(product.price.toString())?.toStringAsFixed(2) ?? 'N/A'}',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
