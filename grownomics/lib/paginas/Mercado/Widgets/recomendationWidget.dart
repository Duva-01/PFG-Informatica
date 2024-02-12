import 'package:flutter/material.dart';
import 'package:grownomics/api/recomendationAPI.dart';

class RecommendationWidget extends StatefulWidget {
  final String symbol;
  final String userEmail;

  const RecommendationWidget({
    Key? key,
    required this.symbol,
    required this.userEmail,
  }) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  Future<String>? recommendationFuture;

  @override
  void initState() {
    super.initState();
    recommendationFuture = getRecommendation(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: recommendationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recomendación para ${widget.symbol}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.data!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
