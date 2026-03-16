import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'STRIPE_PUBLIC_KEY', obfuscate: true)
  static String stripePublicKey = _Env.stripePublicKey;

  @EnviedField(varName: 'STRIPE_PRICE_WEEKLY', obfuscate: true)
  static String stripeWeekly = _Env.stripeWeekly;

  @EnviedField(varName: 'STRIPE_PRICE_MONTHLY', obfuscate: true)
  static String stripeMonthly = _Env.stripeMonthly;

  @EnviedField(varName: 'STRIPE_PRICE_YEARLY', obfuscate: true)
  static String stripeYearly = _Env.stripeYearly;

  @EnviedField(varName: 'PLACES_API_KEY')
  static final String placesApiKey = _Env.placesApiKey;
}
