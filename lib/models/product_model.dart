class Product {
  final String title;
  final String image;
  final double price;

  Product({required this.title, required this.image, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['product_title'] ?? 'No Title',
      image: json['product_photo'] ?? '',
      price: _parsePrice(json['product_price']),
    );
  }
  //function to convert string into double.
  static double _parsePrice(dynamic priceString){

    if(priceString ==null) return 0.0;
    try{
      String cleaned = priceString.toString().replaceAll('\$', '').replaceAll(',', '');
      return double.tryParse(cleaned) ?? 0.0;
    }catch (e){
      return 0.0;
    }

  }

}
