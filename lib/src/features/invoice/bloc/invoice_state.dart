part of 'invoice_bloc.dart';

final class InvoiceState {
  InvoiceState({
    this.invoices = const [],
    this.photos = const [],
    this.iid = 0,
  });

  final List<Invoice> invoices;
  final List<Photo> photos;
  final int iid;

  InvoiceState copyWith({
    List<Invoice>? invoices,
    List<Photo>? photos,
    int? iid,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      photos: photos ?? this.photos,
      iid: iid ?? this.iid,
    );
  }
}
