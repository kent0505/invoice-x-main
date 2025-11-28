part of 'vip_bloc.dart';

final class VipState {
  final bool loading;
  final bool isVip;
  final Offering? offering;
  final int free;

  VipState({
    this.loading = false,
    this.isVip = false,
    this.offering,
    this.free = Constants.free,
  });

  VipState copyWith({
    bool? loading,
    bool? isVip,
    Offering? offering,
    int? free,
  }) {
    return VipState(
      loading: loading ?? this.loading,
      isVip: isVip ?? this.isVip,
      offering: offering ?? this.offering,
      free: free ?? this.free,
    );
  }
}
