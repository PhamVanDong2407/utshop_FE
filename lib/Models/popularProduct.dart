class ProductPopu {
  String? uuid;
  String? name;
  int? price;
  String? image;
  bool? isFavorite;

  ProductPopu({this.uuid, this.name, this.price, this.image, this.isFavorite});

  ProductPopu.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['is_favorite'] = isFavorite;
    return data;
  }
}
