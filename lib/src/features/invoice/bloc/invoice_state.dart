part of 'invoice_bloc.dart';

final class InvoiceState {
  InvoiceState({
    this.invoices = const [],
    this.photos = const [],
  });

  final List<Invoice> invoices;
  final List<Photo> photos;

  InvoiceState copyWith({
    List<Invoice>? invoices,
    List<Photo>? photos,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      photos: photos ?? this.photos,
    );
  }
}
