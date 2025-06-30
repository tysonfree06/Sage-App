import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.location,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.verified,
    required this.interests,
    required this.giftPreferences,
    required this.createdAt,
    required this.updatedAt,
    required this.anniversaryDate,
    required this.apologyLanguage,
    required this.budgetLevel,
    required this.communicationStyle,
    required this.dateOfBirth,
    required this.image,
    required this.loveLanguage,
    required this.relationshipStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final Location location;
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String password;
  final bool verified;
  final List<String> interests;
  final List<String> giftPreferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime anniversaryDate;
  final String apologyLanguage;
  final String budgetLevel;
  final String communicationStyle;
  final DateTime dateOfBirth;
  final String image;
  final String loveLanguage;
  final String relationshipStatus;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    Location? location,
    String? id,
    String? name,
    String? email,
    String? password,
    bool? verified,
    List<String>? interests,
    List<String>? giftPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? anniversaryDate,
    String? apologyLanguage,
    String? budgetLevel,
    String? communicationStyle,
    DateTime? dateOfBirth,
    String? image,
    String? loveLanguage,
    String? relationshipStatus,
  }) {
    return UserModel(
      location: location ?? this.location,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      verified: verified ?? this.verified,
      interests: interests ?? this.interests,
      giftPreferences: giftPreferences ?? this.giftPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      apologyLanguage: apologyLanguage ?? this.apologyLanguage,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      image: image ?? this.image,
      loveLanguage: loveLanguage ?? this.loveLanguage,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
    );
  }
}

@JsonSerializable()
class Location {
  Location({
    required this.city,
    required this.state,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  final String city;
  final String state;
  final String country;

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  Location copyWith({
    String? city,
    String? state,
    String? country,
  }) {
    return Location(
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }
}
