import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gabriel_kobipay_assessment/home_screen/home_screen_notifier/home_screen_notifier.dart';
import 'package:gabriel_kobipay_assessment/home_screen/home_screen_widgets/transaction_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _controller;
  List<bool>? isSelected;
  List<Widget> paymentTypeFilter = const [
    AllTransactions(),
    CreditTransactions(),
    DebitTransactions(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(keepPage: true);
    isSelected = [true, false, false];
    Future.microtask(() {
      if (mounted) {
        ref.read(homeScreenNotifierProvider.notifier).transactions();
      }
    });
  }

  void _onPageChanged(index) {
    setState(() {
      for (int i = 0; i < isSelected!.length; i++) {
        isSelected![i] = i == index;
      }
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
      isSelected![index] = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeScreenNotifierProvider);
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        forceMaterialTransparency: true,
        title: const Stack(
          children: [
            Center(
              child: Text('Kobi Pay'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  '\u22EE',
                ),
              ),
            ),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            )
          : state.transactionModel.data?.totalRecords == null
              ? const SizedBox(
                  child: Center(
                    child: Text('Sorry, please try again later!'),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Center(
                                child: ToggleButtons(
                                  isSelected: isSelected!,
                                  fillColor: Colors.teal,
                                  borderRadius: BorderRadius.circular(10.0),
                                  constraints: BoxConstraints(minWidth: width / 4),
                                  onPressed: (index) => _onPageChanged(index),
                                  children: const [
                                    Center(
                                      child: Text(
                                        'All',
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Credit',
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Debit',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              SizedBox(
                                height: 230.0,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sections: [
                                          PieChartSectionData(
                                            value: state.transactionModel.data?.totalCredit
                                                    ?.toDouble() ??
                                                0.0,
                                            color: Colors.green,
                                            radius: 45.0,
                                            title: 'Credit',
                                          ),
                                          PieChartSectionData(
                                            value: state.transactionModel.data?.totalDebit
                                                    ?.toDouble() ??
                                                0.0,
                                            color: Colors.teal,
                                            title: 'Debit',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(state.transactionModel.data?.totalPayment
                                                ?.toCurrencyString(
                                              mantissaLength: 0,
                                              leadingSymbol: '\$',
                                            ) ??
                                            '0'),
                                        const Text('Total payment'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      children: paymentTypeFilter,
                    ),
                  ),
                ),
    );
  }
}

class AllTransactions extends ConsumerStatefulWidget {
  const AllTransactions({super.key});

  @override
  ConsumerState<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends ConsumerState<AllTransactions>
    with AutomaticKeepAliveClientMixin {
  SearchController controller = SearchController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(homeScreenNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('All Transactions'),
        const SizedBox(
          height: 20.0,
        ),
        SearchAnchor.bar(
          viewLeading: const Icon(
            Icons.search,
          ),
          barBackgroundColor: const WidgetStatePropertyAll(Colors.white),
          barElevation: const WidgetStatePropertyAll(0.0),
          viewHintText: 'Search',
          viewElevation: 1.0,
          viewShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          viewBackgroundColor: Colors.white,
          isFullScreen: false,
          dividerColor: Colors.black,
          viewConstraints: const BoxConstraints.tightFor(
            height: 300.0,
          ),
          constraints: const BoxConstraints.tightFor(height: 40.0),
          keyboardType: TextInputType.number,
          searchController: controller,
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filteredTransactions = state.transactionModel.data!.records!
                .where((transaction) =>
                    transaction.transactionAmount!.toString().toLowerCase().contains(query))
                .toList();

            return filteredTransactions.isNotEmpty
                ? filteredTransactions.map((transaction) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                      child: TransactionCard(
                        leading: transaction.icon!,
                        title: transaction.beneficiaryName!,
                        subtitle: transaction.transactionDate!,
                        trailing:
                            ' ${transaction.paymentType == 'Credit' ? '+' : '-'}\$${transaction.transactionAmount}',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/transaction_detail',
                            arguments: transaction,
                          );
                        },
                      ),
                    );
                  }).toList()
                : [const ListTile(title: Text("No results found"))];
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: state.transactionModel.data!.records!.length,
              itemBuilder: (context, index) {
                final all = state.transactionModel.data!.records![index];
                return TransactionCard(
                  leading: all.icon!,
                  title: all.beneficiaryName!,
                  subtitle: all.transactionDate!,
                  trailing: ' ${all.paymentType == 'Credit' ? '+' : '-'}\$${all.transactionAmount}',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/transaction_detail',
                      arguments: all,
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}

class CreditTransactions extends ConsumerStatefulWidget {
  const CreditTransactions({super.key});

  @override
  ConsumerState<CreditTransactions> createState() => _CreditTransactionsState();
}

class _CreditTransactionsState extends ConsumerState<CreditTransactions>
    with AutomaticKeepAliveClientMixin {
  SearchController controller = SearchController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(homeScreenNotifierProvider);
    final credits = state.transactionModel.data!.records!
        .where((record) => record.paymentType == 'Credit')
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Credit Transactions'),
        const SizedBox(
          height: 20.0,
        ),
        SearchAnchor.bar(
          viewLeading: const Icon(
            Icons.search,
          ),
          barBackgroundColor: const WidgetStatePropertyAll(Colors.white),
          barElevation: const WidgetStatePropertyAll(0.0),
          viewHintText: 'Search',
          viewElevation: 1.0,
          viewShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          viewBackgroundColor: Colors.white,
          isFullScreen: false,
          dividerColor: Colors.black,
          viewConstraints: const BoxConstraints.tightFor(
            height: 300.0,
          ),
          constraints: const BoxConstraints.tightFor(height: 40.0),
          keyboardType: TextInputType.number,
          searchController: controller,
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filteredTransactions = credits
                .where((transaction) =>
                    transaction.transactionAmount!.toString().toLowerCase().contains(query))
                .toList();
            return filteredTransactions.isNotEmpty
                ? filteredTransactions.map((transaction) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                      child: TransactionCard(
                        leading: transaction.icon!,
                        title: transaction.beneficiaryName!,
                        subtitle: transaction.transactionDate!,
                        trailing:
                            ' ${transaction.paymentType == 'Credit' ? '+' : '-'}\$${transaction.transactionAmount}',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/transaction_detail',
                            arguments: transaction,
                          );
                        },
                      ),
                    );
                  }).toList()
                : [const ListTile(title: Text("No results found"))];
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: credits.length,
              itemBuilder: (context, index) {
                final credit = credits[index];
                return TransactionCard(
                  leading: credit.icon!,
                  title: credit.beneficiaryName!,
                  subtitle: credit.transactionDate!,
                  trailing: '+\$${credit.transactionAmount}',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/transaction_detail',
                      arguments: credit,
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}

class DebitTransactions extends ConsumerStatefulWidget {
  const DebitTransactions({super.key});

  @override
  ConsumerState<DebitTransactions> createState() => _DebitTransactionsState();
}

class _DebitTransactionsState extends ConsumerState<DebitTransactions>
    with AutomaticKeepAliveClientMixin {
  SearchController controller = SearchController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(homeScreenNotifierProvider);
    final debits = state.transactionModel.data!.records!
        .where((record) => record.paymentType == 'Debit')
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Debit Transactions'),
        SearchAnchor.bar(
          viewLeading: const Icon(
            Icons.search,
          ),
          barBackgroundColor: const WidgetStatePropertyAll(Colors.white),
          barElevation: const WidgetStatePropertyAll(0.0),
          viewHintText: 'Search',
          viewElevation: 1.0,
          viewShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          viewBackgroundColor: Colors.white,
          isFullScreen: false,
          dividerColor: Colors.black,
          viewConstraints: const BoxConstraints.tightFor(
            height: 300.0,
          ),
          constraints: const BoxConstraints.tightFor(height: 40.0),
          keyboardType: TextInputType.number,
          searchController: controller,
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filteredTransactions = debits
                .where((transaction) =>
                    transaction.transactionAmount!.toString().toLowerCase().contains(query))
                .toList();
            return filteredTransactions.isNotEmpty
                ? filteredTransactions.map((transaction) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                      child: TransactionCard(
                        leading: transaction.icon!,
                        title: transaction.beneficiaryName!,
                        subtitle: transaction.transactionDate!,
                        trailing:
                            ' ${transaction.paymentType == 'Credit' ? '+' : '-'}\$${transaction.transactionAmount}',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/transaction_detail',
                            arguments: transaction,
                          );
                        },
                      ),
                    );
                  }).toList()
                : [const ListTile(title: Text("No results found"))];
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: debits.length,
              itemBuilder: (context, index) {
                final debit = debits[index];
                return TransactionCard(
                  leading: debit.icon!,
                  title: debit.beneficiaryName!,
                  subtitle: debit.transactionDate!,
                  trailing: '-\$${debit.transactionAmount}',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/transaction_detail',
                      arguments: debit,
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
