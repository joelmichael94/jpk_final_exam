import 'package:flutter/material.dart';
import 'package:quote_of_the_day/models/quote.dart';
import 'package:quote_of_the_day/screens/details.dart';
import 'package:quote_of_the_day/screens/overall.dart';
import 'package:quote_of_the_day/services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuoteAPI quoteAPI = QuoteAPI();
  Quote? currentQuote;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    handleGetInitQuote();
  }

  void handleGetInitQuote() async {
    try {
      List<Quote> quote = await quoteAPI.getQuote();
      setState(() {
        currentQuote = quote.first;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch quote: $error');
    }
  }

  void handleGetNewQuote() async {
    try {
      List<Quote> quotes = await quoteAPI.getQuote();
      setState(() {
        currentQuote = (quotes..shuffle()).first;
        isLoading = false;
      });
    } catch (error) {
      setState(() => {isLoading: false});
      throw Exception('Failed to fetch quote: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: const Text(
            "Quotes",
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 325,
              height: 325,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigoAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0)),
              child: InkWell(
                onTap: () {
                  if (!isLoading && currentQuote != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Details(quote: currentQuote!)));
                  }
                },
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.indigoAccent,
                        )
                      : Text(
                          currentQuote!.quote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent),
                    onPressed: handleGetNewQuote,
                    child: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(height: 15),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Overall()));
                    },
                    child: const Text(
                      'Show All',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
