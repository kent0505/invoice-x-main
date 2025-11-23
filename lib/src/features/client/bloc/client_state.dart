part of 'client_bloc.dart';

final class ClientState {
  ClientState({
    this.clients = const[ ],
    this.loading = false,
  });

  final List<Client> clients;
  final bool loading;

  ClientState copyWith({
    List<Client>? clients,
    bool? loading,
  }) {
    return ClientState(
      clients: clients ?? this.clients,
      loading: loading ?? this.loading,
    );
  }
}
