import 'package:gabriel_kobipay_assessment/model/transaction_model.dart';
import 'package:gabriel_kobipay_assessment/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_notifier.g.dart';


class TransactState {
  final TransactionModel transactionModel;
  final bool isLoading;

  TransactState({
    TransactionModel? transactionModel,
    this.isLoading = false,
  }) : transactionModel = transactionModel ?? TransactionModel();

  TransactState copyWith({
    TransactionModel? transactionModel,
    bool? isLoading,
  }) {
    return TransactState(
      transactionModel: transactionModel ?? this.transactionModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class HomeScreenNotifier extends _$HomeScreenNotifier {
  @override
  TransactState build() {
    return TransactState();
  }

  ApiClient apiClient = ApiClient();

  Future transactions() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await apiClient.transactions();
      if(response.data!.records!.isNotEmpty){
        state = state.copyWith(transactionModel: response);
      }
    } catch (e) {
      rethrow;
    }finally{
      state = state.copyWith(isLoading: false);
    }
  }
}
