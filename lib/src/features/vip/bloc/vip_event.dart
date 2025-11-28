part of 'vip_bloc.dart';

@immutable
sealed class VipEvent {}

final class CheckVip extends VipEvent {}

final class CheckPurchased extends VipEvent {
  CheckPurchased({required this.customerInfo});

  final CustomerInfo customerInfo;
}

final class UseFree extends VipEvent {}
