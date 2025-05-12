import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  bool? isSuccessful;
  int? statusCode;
  String? message;
  Data? data;

  TransactionModel({
    this.isSuccessful,
    this.statusCode,
    this.message,
    this.data,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

@JsonSerializable()
class Data {
  int? totalRecords;
  int? totalPayment;
  int? totalCredit;
  int? totalDebit;
  List<Record>? records;

  Data({
    this.totalRecords,
    this.totalPayment,
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Record {
  String? icon;
  String? beneficiaryName;
  int? transactionAmount;
  String? paymentMethod;
  String? paymentType;
  String? transactionStatus;
  String? transactionDate;

  Record({
    this.icon,
    this.beneficiaryName,
    this.transactionAmount,
    this.paymentMethod,
    this.paymentType,
    this.transactionStatus,
    this.transactionDate,
  });

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  Map<String, dynamic> toJson() => _$RecordToJson(this);
}
