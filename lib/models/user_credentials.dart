import 'package:hive/hive.dart';

part 'user_credentials.g.dart';

@HiveType(typeId: 1)
class UserCredentials {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  UserCredentials({
    required this.email,
    required this.password,
  });
}
