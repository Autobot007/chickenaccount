class Customer {
  final String shopName;
  final String customerName;
  final String contactNo;

  const Customer({
    required this.shopName,
    required this.customerName,
    required this.contactNo,
  });

  Map<String, dynamic> toJson() => {
        "ShopName": shopName,
        "CustomerName": customerName,
        "ContactNo": contactNo
      };
}
