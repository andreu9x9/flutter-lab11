import 'package:flutter/material.dart';
import '../services/store_service.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  final StoreService _storeService = StoreService();

  bool _isLoading = false;
  String? _errorMessage;
  String _executionTime = '';

  StoreUser? _user;
  List<Product> _products = [];
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  Future<void> _loadStoreData({bool simulateError = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final results = await Future.wait([
        _storeService.getUser(shouldFail: simulateError),
        _storeService.getProducts(),
        _storeService.getOrders(),
      ]);

      stopwatch.stop();

      if (!mounted) return;
      setState(() {
        _user = results[0] as StoreUser;
        _products = results[1] as List<Product>;
        _orders = results[2] as List<Order>;
        _executionTime =
        'Завантажено конкурентно за ${(stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(2)} с';
        _isLoading = false;
      });
    } catch (e) {
      stopwatch.stop();
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Інтернет-магазин'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _loadStoreData(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Оновити дані'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _loadStoreData(simulateError: true),
                    icon: const Icon(Icons.error_outline, color: Colors.red),
                    label: const Text(
                      'Тест помилки',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Отримання даних з сервера (Future.wait)...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Card(
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadStoreData(),
                  child: const Text('Спробувати знову'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView(
      children: [
        if (_executionTime.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _executionTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (_user != null)
          Card(
            color: Colors.teal.shade50,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                _user!.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${_user!.email}\n${_user!.status}'),
              isThreeLine: true,
            ),
          ),
        const SizedBox(height: 16),
        const Text(
          'Доступні товари:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._products.map(
              (product) => Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.teal),
              title: Text(product.title),
              subtitle: Text(
                product.inStock ? 'В наявності' : 'Немає в наявності',
                style: TextStyle(
                  color: product.inStock ? Colors.green : Colors.grey,
                ),
              ),
              trailing: Text(
                '${product.price} грн',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Історія замовлень:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._orders.map(
              (order) => Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.teal),
              title: Text('Замовлення ${order.id} від ${order.date}'),
              subtitle: Text('Статус: ${order.status}'),
              trailing: Text(
                '${order.total} грн',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}