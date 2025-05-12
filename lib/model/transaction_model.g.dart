// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      isSuccessful: json['isSuccessful'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'isSuccessful': instance.isSuccessful,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      totalRecords: (json['totalRecords'] as num?)?.toInt(),
      totalPayment: (json['totalPayment'] as num?)?.toInt(),
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => Record.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..totalCredit = (json['totalCredit'] as num?)?.toInt()
      ..totalDebit = (json['totalDebit'] as num?)?.toInt();

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'totalRecords': instance.totalRecords,
      'totalPayment': instance.totalPayment,
      'totalCredit': instance.totalCredit,
      'totalDebit': instance.totalDebit,
      'records': instance.records,
    };

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      icon: json['icon'] as String?,
      beneficiaryName: json['beneficiaryName'] as String?,
      transactionAmount: (json['transactionAmount'] as num?)?.toInt(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentType: json['paymentType'] as String?,
      transactionStatus: json['transactionStatus'] as String?,
      transactionDate: json['transactionDate'] as String?,
    );

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'icon': instance.icon,
      'beneficiaryName': instance.beneficiaryName,
      'transactionAmount': instance.transactionAmount,
      'paymentMethod': instance.paymentMethod,
      'paymentType': instance.paymentType,
      'transactionStatus': instance.transactionStatus,
      'transactionDate': instance.transactionDate,
    };
