class StoreUser {
  final String name;
  final String email;
  final String status;

  StoreUser({
    required this.name,
    required this.email,
    required this.status,
  });
}

class Product {
  final String title;
  final double price;
  final bool inStock;

  Product({
    required this.title,
    required this.price,
    required this.inStock,
  });
}

class Order {
  final String id;
  final String date;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
  });
}

class StoreService {
  Future<StoreUser> getUser({bool shouldFail = false}) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (shouldFail) {
      throw Exception('Не вдалося завантажити профіль користувача (Помилка 500)');
    }

    return StoreUser(
      name: 'Олександр Коваленко',
      email: 'alex.kovalenko@gmail.com',
      status: 'Постійний клієнт (Знижка 10%)',
    );
  }

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      Product(title: 'Бездротові навушники', price: 2499.0, inStock: true),
      Product(title: 'Механічна клавіатура', price: 3150.0, inStock: true),
      Product(title: 'Ігрова миша', price: 1420.0, inStock: false),
      Product(title: 'Підставка під ноутбук', price: 890.0, inStock: true),
    ];
  }

  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    return [
      Order(id: '#1042', date: '14.11.2026', total: 3919.0, status: 'Доставлено'),
      Order(id: '#1089', date: '19.11.2026', total: 890.0, status: 'У дорозі'),
    ];
  }
}