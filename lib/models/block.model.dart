// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class BlockModel {
  final blocker;
  final blocked;

  BlockModel({required this.blocker, required this.blocked});

  factory BlockModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
    return BlockModel(blocker: data['blocker'], blocked: data['blocked']);
  }

  Map<String, dynamic> toFirestore() =>
      {'blocker': blocker, 'blocked': blocked};
}
