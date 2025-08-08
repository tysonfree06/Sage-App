class Subscription {
  Subscription({
    required this.label,
    required this.priceString,
    required this.price,
    this.discount,
    this.discountComparedTo,
  });
  final String label;
  final String priceString;
  final int? discount;
  final double price;
  final String? discountComparedTo;
}

class SubscriptionModel {
  SubscriptionModel({this.selectedIndex}) {
    // If selectedIndex is null and the list is not empty, assign the first item by default
    if (selectedIndex == null && subscriptions.isNotEmpty) {
      selectedIndex = 0;
    }
  }

  // List of subscriptions (no static, can be customized per instance)
  static final List<Subscription> subscriptions = [
    Subscription(
      label: 'Yearly',
      priceString: r'$67.99',
      discount: 60,
      discountComparedTo: 'Less Compared To weekly',
      price: 67.99,
    ),
    Subscription(
      label: 'Monthly',
      priceString: r'$6.99',
      discount: 50,
      discountComparedTo: 'Less Compared To weekly',
      price: 6.99,
    ),
    Subscription(
      label: 'Weekly',
      priceString: r'$2.99',
      price: 2.99,
    ),
  ];

  int? selectedIndex;

  // Select a subscription by index
  void selectSubscription(int index) {
    if (index >= 0 && index < subscriptions.length) {
      selectedIndex = index;
    }
  }

  // Get the selected subscription
  Subscription? get selectedSubscription {
    if (selectedIndex != null && selectedIndex! < subscriptions.length) {
      return subscriptions[selectedIndex!];
    }
    return null;
  }
}
