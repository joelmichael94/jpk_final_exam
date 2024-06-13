import 'package:flutter/material.dart';
import 'package:quote_of_the_day/models/quote.dart';
import 'package:quote_of_the_day/services/api.dart';

class Overall extends StatefulWidget {
  const Overall({super.key});

  @override
  State<Overall> createState() => _OverallState();
}

class _OverallState extends State<Overall> {
  late Future<List<Quote>> futureQuotes;
  List<Quote> allQuotes = [];

  @override
  void initState() {
    super.initState();
    futureQuotes = QuoteAPI().getQuote();
    futureQuotes.then((quote) {
      setState(() {
        allQuotes = quote;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "All Quotes",
          style: TextStyle(color: Colors.indigoAccent),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: FutureBuilder<List<Quote>>(
            future: futureQuotes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Failed to fetch quotes"));
              } else {
                return ListView.builder(
                    itemCount: allQuotes.length,
                    itemBuilder: (context, index) {
                      return QuoteModel(quote: allQuotes[index]);
                    });
              }
            },
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent),
              child: const Text(
                "Back",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
