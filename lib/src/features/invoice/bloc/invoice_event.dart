part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent {}

final class GetInvoices extends InvoiceEvent {}

final class AddInvoice extends InvoiceEvent {
  AddInvoice({
    required this.invoice,
    this.paths = const [],
  });

  final Invoice invoice;
  final List<String> paths;
}

final class EditInvoice extends InvoiceEvent {
  EditInvoice({
    required this.invoice,
    this.paths = const [],
  });

  final Invoice invoice;
  final List<String> paths;
}

final class DeleteInvoice extends InvoiceEvent {
  DeleteInvoice({required this.invoice});

  final Invoice invoice;
}
