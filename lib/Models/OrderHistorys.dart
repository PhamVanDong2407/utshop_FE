class OrderHis {
  String? uuid;
  String? orderCode;
  String? totalAmount;
  String? status;
  String? createdAt;
  String? productName;
  String? mainImageUrl;
  int? quantity;
  int? size;
  int? color;
  String? totalItemsCount;

  OrderHis(
      {this.uuid,
      this.orderCode,
      this.totalAmount,
      this.status,
      this.createdAt,
      this.productName,
      this.mainImageUrl,
      this.quantity,
      this.size,
      this.color,
      this.totalItemsCount});

  OrderHis.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    orderCode = json['order_code'];
    totalAmount = json['total_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    productName = json['product_name'];
    mainImageUrl = json['main_image_url'];
    quantity = json['quantity'];
    size = json['size'];
    color = json['color'];
    totalItemsCount = json['total_items_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['order_code'] = orderCode;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['product_name'] = productName;
    data['main_image_url'] = mainImageUrl;
    data['quantity'] = quantity;
    data['size'] = size;
    data['color'] = color;
    data['total_items_count'] = totalItemsCount;
    return data;
  }
}
