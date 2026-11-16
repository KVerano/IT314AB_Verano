import 'package:postgres/postgres.dart';
import 'neon_config.dart'; // my secret settings (PS: NOT pushed sa GitHub)
import 'package:flutter/foundation.dart';

class DbConnection {
  DbConnection._();

  static Connection? _connection;

  static Future<Connection> getConnection() async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    _connection = await Connection.open(
      Endpoint(
        host: NeonConfig.host,
        port: NeonConfig.port,
        database: NeonConfig.database,
        username: NeonConfig.username,
        password: NeonConfig.password,
      ),

      settings: const ConnectionSettings(sslMode: SslMode.require),
    );

    return _connection!;
  }

  static Future<String> testConnection() async {
    try {
      debugPrint('STEP 1: Opening Neon connection...');

      final connection = await getConnection().timeout(
        const Duration(seconds: 15),
      );

      debugPrint('STEP 2: Neon connection opened!');

      final result = await connection
          .execute('SELECT current_database()')
          .timeout(const Duration(seconds: 15));

      debugPrint('STEP 3: Database query successful!');

      return 'Connected to Neon database: ${result.first[0]}';
    } catch (e) {
      debugPrint('NEON ERROR: $e');
      return 'Connection failed: $e';
    }
  }
}
