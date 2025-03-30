import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryPage extends StatefulWidget {
  final String patientId;

  const HistoryPage({Key? key, required this.patientId}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> historyData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  void fetchHistory() async {
    try {
      List<Map<String, dynamic>> history =
          await ApiService.fetchHistory(widget.patientId);

      setState(() {
        historyData = history;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du chargement de l'historique : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique des tests")),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Afficher un loader en attendant les données
          : historyData.isEmpty
              ? Center(child: Text("Aucun historique disponible."))
              : ListView.builder(
                  itemCount: historyData.length,
                  itemBuilder: (context, index) {
                    final item = historyData[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title:
                            Text("Niveau d'anxiété: ${item["niveau_anxiete"]}"),
                        subtitle: Text("Score: ${item["score_anxiete"]}%"),
                        trailing: Text("${item["date"]}"),
                      ),
                    );
                  },
                ),
    );
  }
}
