import 'dart:io';
import 'package:flutter/material.dart';
import '../models/prediction_record.dart';
import '../services/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<PredictionRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _recordsFuture = DatabaseHelper.instance.getAllRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction History')),
      body: FutureBuilder<List<PredictionRecord>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history found.'));
          }

          final records = snapshot.data!;
          
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Dismissible(
                key: Key(record.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissibleDirection.endToStart,
                onDismissed: (direction) async {
                  await DatabaseHelper.instance.delete(record.id!);
                  _refreshList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Record deleted')),
                  );
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(record.imagePath),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    record.resultLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: record.resultLabel.contains('No') ? Colors.green : Colors.red,
                    ),
                  ),
                  subtitle: Text(
                    '${record.timestamp.toString().substring(0, 16)} • Conf: ${(record.confidence * 100).toStringAsFixed(1)}%',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
