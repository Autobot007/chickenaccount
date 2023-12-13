class Bill {
  final String shopName;
  final String customerName;
  final String contactNo;
  final String date;
  final List<Map<String, dynamic>> entry;
  final double total;
  final String balance;
  final String grandTotal;

  Bill(
      {required this.shopName,
      required this.customerName,
      required this.contactNo,
      required this.date,
      required this.entry,
      required this.total,
      required this.balance,
      required this.grandTotal});
  Map<String, dynamic> toJson() => {
        "Date": date,
        "ShopName": shopName,
        "CustomerName": customerName,
        "ContactNo": contactNo,
        "Entries": entry,
        "Total": total,
        "Balance": balance,
        "GrandTotal": grandTotal
      };
}
