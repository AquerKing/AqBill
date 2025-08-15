import 'dart:convert';

import 'package:bill/data/category_model.dart';
import 'package:bill/extension/id_generator.dart';
import 'package:bill/manager/category_manager.dart';
import 'package:bill/manager/transcation_repository.dart';

/// Transaction 数据模型
class TransactionModel {
  TransactionModel();
  TransactionModel.optional({
    int? amount,
    CategoryModel? category,
    String? comment,
    String? date,
  }) {
    if (amount != null) this.amount = amount;
    if (category != null) this.category = category;
    if (comment != null) this.comment = comment;
    if (date != null) this.date = int.parse(date);
  }
  TransactionModel._deserialize({
    required this.id,
    required this.amount,
    required CategoryModel this.category,
    required this.comment,
    required this.date,
  });

  int id = IdGenerator().generateId();
  int amount = 0;
  CategoryModel? category;
  String comment = '';
  int date = int.parse(TranscationRepository().getCurrentDateString());

  bool get isExpense {
    return category!.id >= 10000 && category!.id < 20000;
  }

  void modify({
    int? amount,
    CategoryModel? category,
    String? comment,
    String? date,
  }) {
    if (amount != null) this.amount = amount;
    if (category != null) this.category = category;
    if (comment != null) this.comment = comment;
    if (date != null) this.date = int.parse(date);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category!.id,
      'amount': amount,
      'date': date,
      'comment': comment,
    };
  }

  static TransactionModel fromMap(Map<String, dynamic> map) {
    return TransactionModel._deserialize(
      id: map['id'],
      amount: map['amount'],
      category: CategoryManager().get(map['category']),
      comment: map['comment'],
      date: map['date'],
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  static TransactionModel fromJson(String jsonString) {
    Map<String, dynamic> info = json.decode(jsonString);

    return TransactionModel._deserialize(
      id: info['id'],
      amount: info['amount'],
      category: CategoryManager().get(info['category']),
      comment: info['comment'],
      date: info['date'],
    );
  }
}
