class WishlistProduct {
  String? uuid;
  String? name;
  String? price;
  String? imageUrl;

  WishlistProduct({this.uuid, this.name, this.price, this.imageUrl});

  WishlistProduct.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    price = json['price'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    data['price'] = price;
    data['image_url'] = imageUrl;
    return data;
  }
}
