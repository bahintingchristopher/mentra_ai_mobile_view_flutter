import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/components/Learner/microtraining_card.dart';
import 'package:mentra_mobile_view/models/learner/microtraining_model.dart';

class MicrotrainingView extends StatelessWidget {
  final Future<List<MicrotrainingModel>> microtrainingFuture;

  const MicrotrainingView({super.key, required this.microtrainingFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MicrotrainingModel>>(
      future: microtrainingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error loading microtrainings: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No microtrainings found.'),
            ),
          );
        }

        final items = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return MicrotrainingCard(item: items[index]);
          },
        );
      },
    );
  }
}