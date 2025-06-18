import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    this.token = '',
    this.error = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'Token')
  final String token;

  @JsonKey(name: 'Error')
  final String error;
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? token,
    String? error,
  }) {
    return UserModel(
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}
