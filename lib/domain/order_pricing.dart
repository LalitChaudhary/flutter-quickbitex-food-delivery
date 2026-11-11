class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.priceMinor,
    required this.cuisine,
  });

  final String id;
  final String name;
  final int priceMinor;
  final String cuisine;
}

class BasketLine {
  BasketLine(
      {required this.item, this.qty = 1, this.addonMinor = 0, this.note = ''});

  final MenuItem item;
  int qty;
  int addonMinor;
  String note;

  int get lineMinor => (item.priceMinor + addonMinor) * qty;
}

class OrderQuote {
  const OrderQuote({
    required this.foodMinor,
    required this.discountMinor,
    required this.deliveryMinor,
    required this.totalMinor,
  });

  final int foodMinor;
  final int discountMinor;
  final int deliveryMinor;
  final int totalMinor;
}

class OrderPricing {
  const OrderPricing();

  OrderQuote quote(List<BasketLine> lines, String coupon) {
    final food = lines.fold<int>(0, (sum, line) => sum + line.lineMinor);
    var discount = 0;
    if (coupon.trim().toUpperCase() == 'BITE5' && food > 0) {
      discount = (food * 5) ~/ 100;
    }
    final delivery = food == 0 ? 0 : (food >= 2500 ? 0 : 299);
    return OrderQuote(
      foodMinor: food,
      discountMinor: discount,
      deliveryMinor: delivery,
      totalMinor: food - discount + delivery,
    );
  }
}

const menu = <MenuItem>[
  MenuItem(
      id: 'bao', name: 'Chili crisp bao', priceMinor: 890, cuisine: 'Steam'),
  MenuItem(
      id: 'noodle',
      name: 'Sesame noodle bowl',
      priceMinor: 1450,
      cuisine: 'Noodles'),
  MenuItem(id: 'lime', name: 'Lime soda', priceMinor: 350, cuisine: 'Drinks'),
  MenuItem(
      id: 'cake',
      name: 'Brown butter cake',
      priceMinor: 720,
      cuisine: 'Sweets'),
];
