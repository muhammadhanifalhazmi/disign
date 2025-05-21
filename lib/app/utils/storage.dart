abstract class SecureStorage{
  Future<dynamic> read();

  Future<void> save(data);

  Future<void> destroy();

  Future<void> clear();

}