part of 'business_bloc.dart';

final class BusinessState {
  BusinessState({
    this.businesses = const[ ],
  });

  final List<Business> businesses;

  BusinessState copyWith({
    List<Business>? businesses,
  }) {
    return BusinessState(
      businesses: businesses ?? this.businesses,
    );
  }
}
