import 'package:financial_family_tracker/core/utils/input_validator_mixins.dart';
import 'package:financial_family_tracker/features/auth/presentation/widgets/form_field_registration.dart';
import 'package:financial_family_tracker/features/dashboard/data/models/history_transaction_response.dart';
import 'package:financial_family_tracker/features/dashboard/states/dashboard_provider.dart';
import 'package:financial_family_tracker/features/dashboard/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/consts/app_colors.dart';
import '../data/models/family_history_trasnsaction_response.dart';
import '../data/models/recent_transaction_response.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with InputValidatorMixin {
  final GlobalKey<FormState> _expenseKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _incomeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _transferKey = GlobalKey<FormState>();

  DateTime? expenseAt;
  DateTime? incomeAt;
  int? selectedFamilyMemberId;

  TextEditingController _expenseDescController = TextEditingController();
  TextEditingController _expenseCategoryController = TextEditingController();
  TextEditingController _expenseTotalController = TextEditingController();

  TextEditingController _incomeDescController = TextEditingController();
  TextEditingController _incomeCategoryController = TextEditingController();
  TextEditingController _incomeTotalController = TextEditingController();

  TextEditingController _transferTotalController = TextEditingController();
  TextEditingController _transferDescController = TextEditingController();

  late PageController _pageController;

  @override
  void initState() {
    context.read<DashboardProvider>().fetchDashboardData();
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
      print(dashboardProvider.balanceState);
      print(
          "recent transaction ${dashboardProvider.recentTransactions.toString()}");
      return LayoutBuilder(builder: (context, constraints) {
        // Jika lebar layar lebih dari 600px, tampilkan sidebar.
        final bool isWideScreen = constraints.maxWidth > 600;
        return Scaffold(
          appBar: isWideScreen
              ? null
              : AppBar(
                  title: Text("AooA"),
                ),
          body: Row(
            children: [
              if (isWideScreen) sideBar(),
              Expanded(
                flex: 4,
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical, // Animasi vertikal
                  children: [
                    main(dashboardProvider, context),
                    personalReport(dashboardProvider),
                    familyReport(dashboardProvider),
                    Container(
                      child: Center(child: Text("Setting")),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Drawer untuk layar sempit
          drawer: isWideScreen ? null : drawer(),
        );
      });
    });
  }

  Drawer drawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              _pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              ); // Pindah ke halaman ketiga
              Navigator.pop(context);
              // Navigasi atau aksi lainnya
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              _pageController.animateToPage(
                1,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              ); // Pindah ke h              Navigator.pop(context);
              // Navigasi atau aksi lainnya
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              _pageController.animateToPage(
                2,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              ); // Pindah ke h              Navigator.pop(context);

              // Navigasi atau aksi lainnya
            },
          ),
        ],
      ),
    );
  }

  SingleChildScrollView personalReport(DashboardProvider dashboardProvider) {
    print(dashboardProvider.historyExpense.length);
    print(dashboardProvider.historyIncome.length);
    print(dashboardProvider.historyExpenseMeta);
    print(dashboardProvider.historyIncomeMeta);

    print("error meta income ${dashboardProvider.historyIncomeError}");
    print("error meta expense ${dashboardProvider.historyExpenseError}");
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Financial Family Tracker"),
        Row(
          children: [
            Expanded(
                child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Saldo"),
                    Text("Rp. ${dashboardProvider.balance ?? "0"}"),
                  ],
                ),
              ),
            )),
            Expanded(
                child: Card(
              child: Column(
                children: [
                  Text("Pemasukan"),
                  Text("Rp. ${dashboardProvider.totalIncome ?? "0"}"),
                ],
              ),
            )),
            Expanded(
                child: Card(
              child: Column(
                children: [
                  Text("Pengeluaran"),
                  Text("Rp. ${dashboardProvider.totalExpense ?? "0"}"),
                ],
              ),
            )),
          ],
        ),
        historyTable(
            dashboardProvider: dashboardProvider,
            history: dashboardProvider.historyExpense,
            meta: dashboardProvider.historyExpenseMeta,
            state: dashboardProvider.historyExpenseState,
            type: "historyExpense"),
        historyTable(
            dashboardProvider: dashboardProvider,
            history: dashboardProvider.historyIncome,
            meta: dashboardProvider.historyIncomeMeta,
            state: dashboardProvider.historyIncomeState,
            type: "historyIncome"),
      ],
    ));
  }

  SingleChildScrollView familyReport(DashboardProvider dashboardProvider) {
    print(dashboardProvider.familyHistoryExpense.length);
    print(dashboardProvider.familyHistoryIncome.length);
    print(
        "total should be ${dashboardProvider.familyHistoryExpenseMeta?.total}");
    print(
        "income total should be ${dashboardProvider.familyHistoryIncomeMeta?.total}");

    print("error meta income ${dashboardProvider.familyHistoryIncomeError}");
    print("error meta expense ${dashboardProvider.familyHistoryExpenseError}");
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Financial Family Tracker"),
        Row(
          children: [
            Expanded(
                child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Saldo"),
                    Text("Rp. ${dashboardProvider.balance ?? "0"}"),
                  ],
                ),
              ),
            )),
            Expanded(
                child: Card(
              child: Column(
                children: [
                  Text("Pemasukan"),
                  Text("Rp. ${dashboardProvider.totalIncome ?? "0"}"),
                ],
              ),
            )),
            Expanded(
                child: Card(
              child: Column(
                children: [
                  Text("Pengeluaran"),
                  Text("Rp. ${dashboardProvider.totalExpense ?? "0"}"),
                ],
              ),
            )),
          ],
        ),
        familyHistoryTable(
            dashboardProvider: dashboardProvider,
            familyHistory: dashboardProvider.familyHistoryExpense,
            meta: dashboardProvider.familyHistoryExpenseMeta,
            state: dashboardProvider.familyHistoryExpenseState,
            type: "familyHistoryExpense"),
        familyHistoryTable(
            dashboardProvider: dashboardProvider,
            familyHistory: dashboardProvider.familyHistoryIncome,
            meta: dashboardProvider.familyHistoryIncomeMeta,
            state: dashboardProvider.familyHistoryIncomeState,
            type: "familyHistoryIncome"),
      ],
    ));
  }

  Card historyTable({
    List<HistoryTransaction>? history,
    Meta? meta,
    required DashboardState state,
    required DashboardProvider dashboardProvider,
    required String type,
  }) {
    print("meta page ${meta?.page}");
    print("meta total page ${meta?.totalPages}");
    bool isFetching = false;

    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rincian Pemasukan"),
              Text("Rincian Pemasukan"),
            ],
          ),
          SizedBox(
            height: 400,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    (state != DashboardState.loading)) {
                  if (meta != null &&
                      meta.page < meta.totalPages &&
                      !isFetching) {
                    isFetching = true; // Kunci sebelum memulai fetch
                    setState(() {});
                    switch (type) {
                      case "historyExpense":
                        dashboardProvider
                            .getHistoryExpense(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      case "historyIncome":
                        dashboardProvider
                            .getHistoryIncome(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      case "familyHistoryExpense":
                        dashboardProvider
                            .getFamilyHistoryExpense(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      case "familyHistoryIncome":
                        dashboardProvider
                            .getFamilyHistoryIncome(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      default:
                        isFetching = false;
                    }
                  }
                }
                return false;
              },
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Keterangan')),
                      DataColumn(label: Text('Kategori')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Tanggal')),
                    ],
                    rows: history!.map((expense) {
                      final index = history!.indexOf(expense) + 1;
                      return DataRow(cells: [
                        DataCell(Text('$index')),
                        DataCell(Text(expense.description)),
                        DataCell(Text(expense.category)),
                        DataCell(Text('Rp. ${expense.amount.toString()}')),
                        DataCell(Text(
                            '${expense.transactionAt.toLocal().toString().split(' ')[0]}')),
                      ]);
                    }).toList(),
                    // [
                    // ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card familyHistoryTable(
      {List<FamilyHistoryTransaction>? familyHistory,
      Meta? meta,
      required DashboardState state,
      required DashboardProvider dashboardProvider,
      required String type}) {
    bool isFetching = false;

    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rincian Pemasukan"),
              Text("Rincian Pemasukan"),
            ],
          ),
          SizedBox(
            height: 400,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    (state != DashboardState.loading)) {
                  if (meta != null &&
                      meta.page < meta.totalPages &&
                      !isFetching) {
                    isFetching = true; // Kunci sebelum memulai fetch
                    setState(() {});
                    switch (type) {
                      case "historyExpense":
                        dashboardProvider
                            .getHistoryExpense(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      case "historyIncome":
                        dashboardProvider
                            .getHistoryIncome(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      case "familyHistoryExpense":
                        dashboardProvider
                            .getFamilyHistoryExpense(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      case "familyHistoryIncome":
                        dashboardProvider
                            .getFamilyHistoryIncome(page: meta.page + 1)
                            .then((_) {
                          isFetching = false; // Lepaskan kunci setelah selesai
                        });
                        break;
                      default:
                        isFetching = false;
                    }
                  }
                }
                return false;
              },
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Keterangan')),
                      DataColumn(label: Text('Kategori')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Tanggal')),
                    ],
                    rows: familyHistory!.map((expense) {
                      final index = familyHistory!.indexOf(expense) + 1;
                      return DataRow(cells: [
                        DataCell(Text('$index')),
                        DataCell(Text(expense.member.user.username)),
                        DataCell(Text(expense.description)),
                        DataCell(Text(expense.category)),
                        DataCell(Text('Rp. ${expense.amount.toString()}')),
                        DataCell(Text(
                            '${expense.transactionAt.toLocal().toString().split(' ')[0]}')),
                      ]);
                    }).toList(),
                    // [
                    // ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  String _formatCurrency(double amount) {
    return 'Rp${amount.toStringAsFixed(2)}';
  }

  main(DashboardProvider dashboardProvider, BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Financial Family Tracker"),
        Row(
          children: [
            Expanded(
                child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Saldo"),
                    Text("Rp. ${dashboardProvider.balance ?? "0"}"),
                  ],
                ),
              ),
            )),
            Expanded(
                child: Card(
              child: Column(
                children: [
                  Text("Pemasukan"),
                  Text("Rp. ${dashboardProvider.totalIncome ?? "0"}"),
                ],
              ),
            )),
            Expanded(
                child: Card(
              child: Column(
                children: [
                  Text("Pengeluaran"),
                  Text("Rp. ${dashboardProvider.totalExpense ?? "0"}"),
                ],
              ),
            )),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: DefaultTabController(
                  length: 3,
                  child: Card(
                    child: Column(
                      children: [
                        TabBar(tabs: [
                          Text("Pengeluaran"),
                          Text("Pemasukan"),
                          Text("Transfer"),
                        ]),
                        SizedBox(
                          height: 300,
                          child: TabBarView(children: [
                            addExpense(context, dashboardProvider),
                            addIncome(context, dashboardProvider),
                            tranfer(context, dashboardProvider),
                          ]),
                        ),
                      ],
                    ),
                  )),
            ),
            Flexible(
                flex: 1,
                child: SizedBox(
                  height: 300,
                  child: Card(
                    child: Column(
                      children: [
                        Text("Riwayat Transaksi"),
                        Expanded(
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount:
                                dashboardProvider.recentTransactions.length,
                            itemBuilder: (context, index) {
                              TransactionData transaction =
                                  dashboardProvider.recentTransactions[index];
                              return ListTile(
                                title: Text(transaction.description),
                                subtitle: Text(
                                    "${transaction.transactionAt.weekday} ${transaction.transactionAt.month} ${transaction.transactionAt.year}"),
                                trailing: Text(transaction.amount.toString()),
                              );
                            },
                          ),
                        )

                        // ListTile(
                        //   title: Text("Gaji - Ayah"),
                        //   subtitle: Text("15 Oktober 2025"),
                        //   trailing: Text("+ 7.000.000"),
                        // ),
                        // ListTile(
                        //   title: Text("Gaji - Ayah"),
                        //   subtitle: Text("15 Oktober 2025"),
                        //   trailing: Text("+ 7.000.000"),
                        // ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ],
    ));
  }

  Form tranfer(BuildContext context, DashboardProvider dashboardProvider) {
    return Form(
      key: _transferKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AuthFormField(
          //   controller: _incomeCategoryController,
          //   labelText: "Kirim ke",
          //   validator: (value) => validateText(value, "Kirim ke"),
          // ),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: "Kirim ke"),
            value: selectedFamilyMemberId,
            items: dashboardProvider.familyMembers.map((member) {
              return DropdownMenuItem<int>(
                value: member.id,
                child: Text(member.user.username),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedFamilyMemberId = value;
              });
            },
            validator: (value) {
              if (value == null) return "Pilih salah satu anggota keluarga";
              return null;
            },
          ),
          AuthFormField(
            controller: _transferDescController,
            labelText: "Masukan keterangan",
            validator: (value) => validateText(value, "Keterangan"),
          ),
          AuthFormField(
            controller: _transferTotalController,
            labelText: "Masukan jumlah",
            validator: (value) => validateNumber(value, "Jumlah"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_transferKey.currentState?.validate() ?? false) {
                try {
                  final transferAmount =
                      double.parse(_transferTotalController.text);
                  final transferDesc = _transferDescController.text;
                  final recipientId = selectedFamilyMemberId ?? 0;
                  await context.read<DashboardProvider>().transfer(
                      amount: transferAmount,
                      recipientId: recipientId,
                      description: transferDesc);

                  if (dashboardProvider.addExpenseState ==
                      DashboardState.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(dashboardProvider.addExpenseError ??
                              "Terjadi kesalahan saat menambahkan pengeluaran")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Transfer berhasil")),
                  );
                  _transferDescController.clear();
                  selectedFamilyMemberId = null;
                  _transferTotalController.clear();

                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Terjadi kesalahan: $e")),
                  );
                }
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Form addIncome(BuildContext context, DashboardProvider dashboardProvider) {
    return Form(
      key: _incomeKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatePicker(
            title: Text("Tanggal"),
            date: incomeAt,
            onDatePicked: (DateTime pickedDate) {
              setState(() {
                incomeAt = pickedDate;
              });
            },
          ),
          AuthFormField(
            controller: _incomeCategoryController,
            labelText: "Masukan kategori",
            validator: (value) => validateText(value, "Kategori"),
          ),
          AuthFormField(
            controller: _incomeDescController,
            labelText: "Masukan keterangan",
            validator: (value) => validateText(value, "Keterangan"),
          ),
          AuthFormField(
            controller: _incomeTotalController,
            labelText: "Masukan jumlah",
            validator: (value) => validateNumber(value, "Jumlah"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_incomeKey.currentState?.validate() ?? false) {
                try {
                  final incomeAmount =
                      double.parse(_incomeTotalController.text);
                  final DateTime incomeDate = incomeAt ?? DateTime.now();
                  final incomeDesc = _incomeDescController.text;
                  final incomeCategory = _incomeDescController.text;
                  await context.read<DashboardProvider>().addIncome(
                      amount: incomeAmount,
                      category: incomeCategory,
                      transactionAt: incomeDate,
                      description: incomeDesc);

                  if (dashboardProvider.addExpenseState ==
                      DashboardState.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(dashboardProvider.addExpenseError ??
                              "Terjadi kesalahan saat menambahkan pengeluaran")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Pendapatan berhasil disimpan")),
                  );
                  _incomeDescController.clear();
                  _incomeCategoryController.clear();
                  _incomeTotalController.clear();
                  incomeAt = null;

                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Terjadi kesalahan: $e")),
                  );
                }
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Form addExpense(BuildContext context, DashboardProvider dashboardProvider) {
    return Form(
      key: _expenseKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatePicker(
            title: Text("Tanggal"),
            date: expenseAt,
            onDatePicked: (DateTime pickedDate) {
              setState(() {
                expenseAt = pickedDate;
              });
            },
          ),
          AuthFormField(
            controller: _expenseCategoryController,
            labelText: "Masukan Kategori",
            validator: (value) => validateText(value, "Kategori"),
          ),
          AuthFormField(
            controller: _expenseDescController,
            labelText: "Masukan keterangan",
            validator: (value) => validateText(value, "Keterangan"),
          ),
          AuthFormField(
            controller: _expenseTotalController,
            labelText: "Masukan jumlah",
            validator: (value) => validateNumber(value, "Jumlah"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_expenseKey.currentState?.validate() ?? false) {
                try {
                  final expenseAmount =
                      double.parse(_expenseTotalController.text);
                  final DateTime expenseDate = expenseAt ?? DateTime.now();
                  final expenseDesc = _expenseDescController.text;
                  final expenseCategory = _expenseDescController.text;
                  await context.read<DashboardProvider>().addExpense(
                      amount: expenseAmount,
                      category: expenseCategory,
                      transactionAt: expenseDate,
                      description: expenseDesc);

                  if (dashboardProvider.addExpenseState ==
                      DashboardState.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(dashboardProvider.addExpenseError ??
                              "Terjadi kesalahan saat menambahkan pengeluaran")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Pengeluaran berhasil disimpan")),
                  );
                  _expenseDescController.clear();
                  _expenseCategoryController.clear();
                  _expenseTotalController.clear();
                  expenseAt = null;

                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Terjadi kesalahan: $e")),
                  );
                }
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Flexible sideBar() {
    return Flexible(
      flex: 1,
      child: Material(
        color: AppColors.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _pageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                ); // Pindah ke halaman pertama
              },
            ),
            ExpansionTile(
              title: Text("Laporan"),
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    "Pribadi",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Navigasi atau aksi lainnya
                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                    ); //
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    "Keluarga",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Navigasi atau aksi lainnya
                    _pageController.animateToPage(
                      2,
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                    ); //
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _pageController.animateToPage(
                  3,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                ); //
              },
            ),
          ],
        ),
      ),
    );
  }
}
