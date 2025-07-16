import 'package:hive/hive.dart';

part 'users.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String userName;

  @HiveField(1)
  final String email;

  UserModel(this.userName, this.email);
}
