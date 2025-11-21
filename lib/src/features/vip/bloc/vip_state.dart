part of 'vip_bloc.dart';

final class VipState {
  final bool loading;
  final bool isVip;
  final Offering? offering;

  VipState({
    this.loading = false,
    this.isVip = false,
    this.offering,
  });

  VipState copyWith({
    bool? loading,
    bool? isVip,
    Offering? offering,
  }) {
    return VipState(
      loading: loading ?? this.loading,
      isVip: isVip ?? this.isVip,
      offering: offering ?? this.offering,
    );
  }
}
