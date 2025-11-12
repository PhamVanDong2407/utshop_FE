class UserCart {
  List<Items>? items;
  int? totalItems;
  double? totalAmount; // <-- SỬA: int? thành double?

  UserCart({this.items, this.totalItems, this.totalAmount});

  UserCart.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    totalItems = json['total_items'];
    
    // SỬA: Chuyển đổi an toàn từ num (int hoặc double) sang double
    totalAmount = (json['total_amount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total_items'] = totalItems;
    data['total_amount'] = totalAmount;
    return data;
  }
}

class Items {
  String? variantUuid;
  String? productUuid;
  String? productName;
  String? mainImageUrl;
  double? price; // <-- SỬA: int? thành double?
  int? quantity;
  double? subtotal; // <-- SỬA: int? thành double?
  int? size;
  int? color;
  int? gender;
  int? type;
  int? stock;

  Items({
    this.variantUuid,
    this.productUuid,
    this.productName,
    this.mainImageUrl,
    this.price,
    this.quantity,
    this.subtotal,
    this.size,
    this.color,
    this.gender,
    this.type,
    this.stock,
  });

  Items.fromJson(Map<String, dynamic> json) {
    variantUuid = json['variant_uuid'];
    productUuid = json['product_uuid'];
    productName = json['product_name'];
    mainImageUrl = json['main_image_url'];
    
    // SỬA: Chuyển đổi an toàn
    price = (json['price'] as num?)?.toDouble();
    quantity = json['quantity'];
    subtotal = (json['subtotal'] as num?)?.toDouble();

    size = json['size'];
    color = json['color'];
    gender = json['gender'];
    type = json['type'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variant_uuid'] = variantUuid;
    data['product_uuid'] = productUuid;
    data['product_name'] = productName;
    data['main_image_url'] = mainImageUrl;
    data['price'] = price;
    data['quantity'] = quantity;
    data['subtotal'] = subtotal;
    data['size'] = size;
    data['color'] = color;
    data['gender'] = gender;
    data['type'] = type;
    data['stock'] = stock;
    return data;
  }
}