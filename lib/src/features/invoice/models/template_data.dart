import '../../item/models/item.dart';

final class TemplateData {
  TemplateData({
    required this.type,
    required this.currency,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.uniqueItems,
  });

  final String type;
  final String currency;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final List<Item> uniqueItems;
}
