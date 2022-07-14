import 'dart:io';
import 'package:dokuro_flutter/config.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class PostgraphileService2 extends GetxService {
  late GraphQLClient client;

  void refreshClient(String token) {
    final HttpLink httpLink = HttpLink(
      'http://$serverDomain:$portHttp/graphql',
      defaultHeaders: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final WebSocketLink websocketLink = WebSocketLink(
      "ws://$serverDomain/graphql",
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        headers: {
          "Authorization": "Bearer $token",
          "Sec-WebSocket-Protocol": "graphql-ws",
        },
        initialPayload: "",
      ),
    );
    final Link link = Link.split(
        (request) => request.isSubscription, websocketLink, httpLink);

    client = GraphQLClient(cache: GraphQLCache(), link: link);
  }
}
