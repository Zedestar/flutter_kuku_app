import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/constants/constant.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // child: Text(
                    //     'GraphQL error: ${graphQLError.graphqlErrors.join(", ")}')
                    child: Text("Login to get your samples"),
                  );
                }
              }

              final data = snapshot.data!.data;
              final samples = data?['predictedSamples'];

              if (samples != null && samples is List && samples.isNotEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text("My Samples"),
                        centerTitle: true,
                      ),
                      backgroundColor: kcolor,
                    ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 4,
                    )),
                    SliverToBoxAdapter(
                      child: Query(
                        options: QueryOptions(
                          document: gql(
                            """
                                query {
                                  diseaseCount
                                }
                              """,
                          ),
                          fetchPolicy: FetchPolicy.networkOnly,
                        ),
                        builder: (QueryResult result,
                            {VoidCallback? refetch, FetchMore? fetchMore}) {
                          final data = result.data?['diseaseCount'];

                          if (data == null) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return SizedBox(
                            height: 270,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 10,
                                barTouchData: BarTouchData(enabled: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        const labels = [
                                          "NewCastle",
                                          "Health",
                                          "Cocci",
                                          "salmonella",
                                        ];
                                        return Text(
                                          labels[value.toInt()]
                                              .toString()
                                              .split('.')
                                              .last
                                              .toLowerCase(),
                                        );
                                      },
                                      reservedSize: 42,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                // borderData: FlBorderData(show: false),
                                barGroups: [
                                  BarChartGroupData(x: 0, barRods: [
                                    BarChartRodData(
                                      toY: (((data[0] as int).toDouble() /
                                              (data[4] as int).toDouble()) *
                                          10),
                                      color: Colors.blue,
                                      width: 40,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    )
                                  ]),
                                  BarChartGroupData(x: 1, barRods: [
                                    BarChartRodData(
                                      toY: (((data[1] as int).toDouble() /
                                              (data[4] as int).toDouble()) *
                                          10),
                                      color: Colors.lightBlueAccent,
                                      width: 40,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                  ]),
                                  BarChartGroupData(x: 2, barRods: [
                                    BarChartRodData(
                                      toY: (((data[2] as int).toDouble() /
                                              (data[4] as int).toDouble()) *
                                          10),
                                      color: Colors.lightBlue,
                                      width: 40,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                  ]),
                                  BarChartGroupData(
                                    x: 3,
                                    barRods: [
                                      BarChartRodData(
                                        toY: (((data[3] as int).toDouble() /
                                                (data[4] as int).toDouble()) *
                                            10),
                                        color: Colors.blueAccent,
                                        width: 40,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Picture (can be network or asset)
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    samples[index]['sampleImage'],
                                    height: 131,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // Time taken
                                Row(
                                  children: [
                                    Icon(Icons.timer,
                                        size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                        "Was: ${samples[index]['timeTaken'].toString()}",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Text(
                                      samples[index]['diseaseNamePredicted']
                                          .toString()
                                          .toLowerCase(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      double.parse((samples[index]
                                                      ['confidenceLevel'] *
                                                  100)
                                              .toString())
                                          .toStringAsFixed(0),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: samples.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 1),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "You haven't took any sample",
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
