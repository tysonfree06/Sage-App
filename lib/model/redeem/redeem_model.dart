//FIXME: Remove this comment after generated files fix #muttas
import 'package:json_annotation/json_annotation.dart';

// part 'radeem_model.g.dart';
part 'redeem_model.g.dart';

@JsonSerializable()
class RedeemOfferDetails {
  const RedeemOfferDetails({
    required this.startDate,
    required this.endDate,
    this.backendId = '',
    this.offerId = '',
    this.title = '',
    this.points = 0,
    this.description = '',
    this.redemptionDate,
    this.imageUrl = '',
  });

  factory RedeemOfferDetails.fromJson(Map<String, dynamic> json) =>
      _$RedeemOfferDetailsFromJson(json);

  final String backendId;

  final String offerId;

  final String title;

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

  static DateTime _dateTimeFromJson(String date) {
    if (date.isEmpty) {
      throw const FormatException('Invalid date string');
    }
    return DateTime.parse(date);
  }

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  static DateTime? _nullableDateTimeFromJson(String? date) =>
      date == null || date.isEmpty ? null : DateTime.parse(date);

  static String? _nullableDateTimeToJson(DateTime? date) =>
      date?.toIso8601String();
}
