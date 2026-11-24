import 'package:flutter/widgets.dart';

import '../data/catalog.dart';

enum PaymentMethod {
  visa('Visa', '4242'),
  mastercard('Mastercard', '5321'),
  paypal('PayPal', ''),
  rupay('RuPay', '9841'),
  paytm('Paytm', '');

  const PaymentMethod(this.label, this.demoDigits);

  final String label;
  final String demoDigits;
}

class ShippingAddress {
  const ShippingAddress(
    this.name,
    this.line1,
    this.line2,
    this.city,
    this.region,
    this.postcode,
  );

  static const demo = ShippingAddress(
    'Dylan Flores',
    '100-A, Super Bazaar, Station Road',
    'Opp. Bhagwan Cutpiece, Santacruz',
    'Bangalore',
    'Karnataka',
    '560016',
  );

  final String name;
  final String line1;
  final String line2;
  final String city;
  final String region;
  final String postcode;

  List<String> get fields => [name, line1, line2, city, region, postcode];

  String get summary => [
    line1,
    if (line2.isNotEmpty) line2,
    '$city, $region $postcode',
  ].join('\n');
}

class OrderState extends ChangeNotifier {
  final Map<Food, int> _basket = {};
  String _name = 'Dylan Flores';
  String? _email;
  ShippingAddress _address = ShippingAddress.demo;
  PaymentMethod _method = PaymentMethod.mastercard;
  String _lastDigits = PaymentMethod.mastercard.demoDigits;
  String? _expiry = '06/30';
  bool _saveCard = true;
  bool _orderUpdates = true;

  String get name => _name;
  String get handle =>
      _email == null ? '@infomadbrains' : '@${_email!.split('@').first}';
  ShippingAddress get address => _address;
  PaymentMethod get method => _method;
  String get lastDigits => _lastDigits;
  String? get expiry => _expiry;
  bool get saveCard => _saveCard;
  bool get orderUpdates => _orderUpdates;
  Map<Food, int> get basket => Map.unmodifiable(_basket);
  int get itemCount =>
      _basket.values.fold(0, (total, quantity) => total + quantity);
  int get subtotal => _basket.entries.fold(
    0,
    (total, row) => total + row.key.price * row.value,
  );
  int get deliveryFee => _basket.isEmpty ? 0 : 10;
  int get total => subtotal + deliveryFee;

  void signIn(String username, {String? email}) {
    _name = username.trim();
    _email = email;
    notifyListeners();
  }

  void signOut() {
    _name = 'Dylan Flores';
    _email = null;
    _address = ShippingAddress.demo;
    _basket.clear();
    _method = PaymentMethod.mastercard;
    _lastDigits = _method.demoDigits;
    _expiry = '06/30';
    _saveCard = true;
    _orderUpdates = true;
    notifyListeners();
  }

  void changeQuantity(Food food, int delta) {
    final quantity = (_basket[food] ?? 0) + delta;
    if (quantity <= 0) {
      _basket.remove(food);
    } else {
      _basket[food] = quantity;
    }
    notifyListeners();
  }

  void removeFood(Food food) {
    _basket.remove(food);
    notifyListeners();
  }

  void setAddress(ShippingAddress address) {
    _address = address;
    notifyListeners();
  }

  void selectPayment(PaymentMethod method) {
    _method = method;
    _lastDigits = method.demoDigits;
    _expiry = _lastDigits.isEmpty ? null : '06/30';
    notifyListeners();
  }

  void useCard(
    PaymentMethod method,
    String digits,
    String expiry,
    bool saveCard,
  ) {
    _method = method;
    _lastDigits = digits;
    _expiry = expiry;
    _saveCard = saveCard;
    notifyListeners();
  }

  void setOrderUpdates(bool enabled) {
    _orderUpdates = enabled;
    notifyListeners();
  }

  bool submitOrder() {
    if (_basket.isEmpty) return false;
    _basket.clear();
    if (!_saveCard) {
      _lastDigits = _method.demoDigits;
      _expiry = _lastDigits.isEmpty ? null : '06/30';
    }
    notifyListeners();
    return true;
  }
}

class OrderScope extends InheritedNotifier<OrderState> {
  const OrderScope({super.key, required OrderState state, required super.child})
    : super(notifier: state);

  static OrderState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OrderScope>()!.notifier!;

  static OrderState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<OrderScope>()!.notifier!;
}
