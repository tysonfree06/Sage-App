import 'package:json_annotation/json_annotation.dart';

part 'radeem_model.g.dart';

@JsonSerializable()
class RedeemOfferDetails {
  const RedeemOfferDetails({
    required this.startDate,
    required this.endDate,
    this.backendId = '',
    this.offerId = '',
    this.isPast = false,
    this.title = '',
    this.points = 0,
    this.description = '',
    this.redemptionDate,
    this.imageUrl = '',
  });

  factory RedeemOfferDetails.fromJson(Map<String, dynamic> json) =>
      _$RedeemOfferDetailsFromJson(json);

  @JsonKey(name: 'backendId')
  final String backendId;

  @JsonKey(name: 'offerId')
  final String offerId;

  @JsonKey(name: 'isPast')
  final bool isPast;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'points')
  final int points;

  @JsonKey(
    name: 'startDate',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime startDate;

  @JsonKey(
    name: 'endDate',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime endDate;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(
    name: 'redemptionDate',
    includeIfNull: false,
    fromJson: _nullableDateTimeFromJson,
    toJson: _nullableDateTimeToJson,
  )
  final DateTime? redemptionDate;

  @JsonKey(name: 'imageUrl')
  final String imageUrl;

  RedeemOfferDetails copyWith({
    String? backendId,
    String? offerId,
    bool? isPast,
    String? title,
    int? points,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    DateTime? redemptionDate,
    String? imageUrl,
  }) {
    return RedeemOfferDetails(
      backendId: backendId ?? this.backendId,
      offerId: offerId ?? this.offerId,
      isPast: isPast ?? this.isPast,
      title: title ?? this.title,
      points: points ?? this.points,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      redemptionDate: redemptionDate ?? this.redemptionDate,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => _$RedeemOfferDetailsToJson(this);

  // Helper functions to handle DateTime serialization/deserialization
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  static DateTime? _nullableDateTimeFromJson(String? date) =>
      date == null ? null : DateTime.parse(date);

  static String? _nullableDateTimeToJson(DateTime? date) =>
      date?.toIso8601String();
}
