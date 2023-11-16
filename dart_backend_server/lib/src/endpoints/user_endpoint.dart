import 'package:serverpod/serverpod.dart';

class UserEndpoints extends Endpoint {
  //Uncomment below line if user login is required to access this endpoint

  // @override
  // bool get requireLogin => true;

  //Uncomment below line if user role is required to access this endpoint, if this is true then requireLogin will also need to be true
  //we can create custom roles here

  // @override
  // Set<Scope> get requiredScopes => {Scope.admin};

  Future<String> test(Session session, String name) async {
    return "hello $name";
  }
}
