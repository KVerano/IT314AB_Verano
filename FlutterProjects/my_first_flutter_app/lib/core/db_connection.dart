import 'package:postgres/postgres.dart';
import 'neon_config.dart'; // my secret settings (PS: NOT pushed sa GitHub)

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
      final connection = await getConnection();
      final result = await connection.execute('SELECT current_database()');
      return 'Connected to Neon database: ${result.first[0]}';
    } catch (e) {
      return 'Connection failed: $e';
    }
  }
}
