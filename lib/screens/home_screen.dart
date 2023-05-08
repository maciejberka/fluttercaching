import 'package:flutter/material.dart';
import 'package:fluttercaching/hive/hive_manager.dart';
import 'package:fluttercaching/hive/models/quote_model.dart';
import 'package:fluttercaching/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<Quote?> quoteNotifier = ValueNotifier<Quote?>(null);
  late bool fetchingInProgress;
  late bool newlyFetched;

  Future<void> _getQuote() async {
    setState(() {
      fetchingInProgress = true;
      newlyFetched = false;
    });

    try {
      quoteNotifier.value = HiveManager.getQuote();
    } catch (exception) {
      print(exception);
    }

    try {
      quoteNotifier.value = await ApiService.getRandomQuote().timeout(const Duration(seconds: 10));
      setState(() {
        newlyFetched = true;
        fetchingInProgress = false;
      });
      if (quoteNotifier.value != null) {
        HiveManager.updateQuoteBox(
          quoteNotifier.value!,
        );
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    _getQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter caching'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        child: IconButton(
          onPressed: _getQuote,
          icon: const Icon(
            Icons.restart_alt,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ValueListenableBuilder(
          valueListenable: quoteNotifier,
          builder: (_, Quote? quote, __) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (quote != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.quote,
                      ),
                      const SizedBox(height: 20),
                      Text('- ${quote.author}'),
                    ],
                  ),
                const SizedBox(height: 45),
                Column(
                  children: [
                    Opacity(
                      opacity: newlyFetched ? 1 : 0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                              margin: const EdgeInsets.only(right: 12.0),
                            ),
                            const Text('Displaying recently fetched data')
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: quote != null ? 1 : 0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                              margin: const EdgeInsets.only(right: 12.0),
                            ),
                            const Text('Displaying data from cache')
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: fetchingInProgress ? 1 : 0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                              margin: const EdgeInsets.only(right: 12.0),
                            ),
                            const Text('Fetching new data...')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
