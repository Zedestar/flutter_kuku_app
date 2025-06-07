import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(context, 'My Sample'),
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          final WatchQueryOptions options = WatchQueryOptions(
            document: gql(
              """
                query{
                    predictedSamples{
                    user{username}
                    diseaseNamePredicted
                    sampleImage
                    confidenceLevel
                    }
                  }""",
            ),
            pollInterval: Duration(seconds: 10),
            fetchResults: true,
          );
          final ObservableQuery observableQuery = client.watchQuery(options);
          observableQuery.fetchResults();

          return StreamBuilder<QueryResult>(
            stream: observableQuery.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                final theError = snapshot.error.toString();
                if (theError.contains('SocketException')) {
                  return Center(
                    child: Text("There is no internent connection"),
                  );
                } else {
                  return Center(
                    child: Text("Error occured $theError"),
                  );
                }
              }
              if (snapshot.data!.hasException) {
                final graphQLError = snapshot.data!.exception;
                if (graphQLError != null) {
                  if (graphQLError.linkException is LinkException) {
                    return Center(
                      child: Text("The server is temporary unvailable"),
                    );
                  }
                  return Center(
                      child: Text(
                          'GraphQL error: ${graphQLError.graphqlErrors.join(", ")}'));
                }
              }

              final data = snapshot.data!.data;
              final samples = data?['predictedSamples'];

              if (samples != null && samples is List && samples.isNotEmpty) {
                return ListView.builder(
                  itemCount: samples.length,
                  itemBuilder: (context, index) {
                    return Text("Sample ${index + 1}");
                  },
                );
              } else {
                return Center(child: Text("No samples found"));
              }
            },
          );
        },
      ),
    );
  }
}
