import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'STRIPE_PUBLIC_KEY')
  static const String stripePublicKey = _Env.stripePublicKey;

  @EnviedField(varName: 'STRIPE_PRICE_WEEKLY')
  static const String stripeWeekly = _Env.stripeWeekly;

  @EnviedField(varName: 'STRIPE_PRICE_MONTHLY')
  static const String stripeMonthly = _Env.stripeMonthly;

  @EnviedField(varName: 'STRIPE_PRICE_YEARLY')
  static const String stripeYearly = _Env.stripeYearly;
}
