import 'package:serverpod/serverpod.dart';

class UserEndpoints extends Endpoint {
  Future<String> test(Session session, String name) async {
    return "This is normal endpoint";
  }
}
