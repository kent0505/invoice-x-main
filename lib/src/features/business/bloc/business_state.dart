part of 'business_bloc.dart';

final class BusinessState {
  BusinessState({
    this.businesses = const[ ],
    this.loading = false,
  });

  final List<Business> businesses;
  final bool loading;

  BusinessState copyWith({
    List<Business>? businesses,
    bool? loading,
  }) {
    return BusinessState(
      businesses: businesses ?? this.businesses,
      loading: loading ?? this.loading,
    );
  }
}
