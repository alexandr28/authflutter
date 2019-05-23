import 'package:authflutter/blocs/user_bloc.dart';
class User{
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  UserEvent event;
  User({this.id, this.name, this.email, this.avatarUrl, this.event});
}