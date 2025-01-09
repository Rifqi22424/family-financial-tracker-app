import 'package:financial_family_tracker/core/consts/app_padding.dart';
import 'package:financial_family_tracker/core/utils/input_validator_mixins.dart';
import 'package:financial_family_tracker/core/utils/shared_preferences_helper.dart';
import 'package:financial_family_tracker/features/auth/presentation/widgets/form_field_registration.dart';
import 'package:financial_family_tracker/features/dashboard/data/models/history_transaction_response.dart';
import 'package:financial_family_tracker/features/dashboard/states/dashboard_provider.dart';
import 'package:financial_family_tracker/features/dashboard/widgets/date_picker.dart';
import 'package:financial_family_tracker/features/dashboard/widgets/family_scrollable_data_table.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/consts/app_colors.dart';
import '../../../core/consts/image_routes.dart';
import '../../auth/states/password_provider.dart';
import '../data/models/family_history_trasnsaction_response.dart';
import '../data/models/recent_transaction_response.dart';
import '../states/family_code_provider.dart';
import '../widgets/scrollable_data_table.dart';

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
  final GlobalKey<FormState> _changePasswordKey = GlobalKey<FormState>();

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

  TextEditingController _oldPasswordChangePasswordController =
      TextEditingController();
  TextEditingController _newPasswordChangePasswordController =
      TextEditingController();
  TextEditingController _confirmNewPasswordChangePasswordController =
      TextEditingController();

  int incomeSelectedMonth = DateTime.now().month;
  int incomeSelectedYear = DateTime.now().year;

  int expenseSelectedMonth = DateTime.now().month;
  int expenseSelectedYear = DateTime.now().year;

  int familyIncomeSelectedMonth = DateTime.now().month;
  int familyIncomeSelectedYear = DateTime.now().year;

  int familyExpenseSelectedMonth = DateTime.now().month;
  int familyExpenseSelectedYear = DateTime.now().year;

  late PageController _pageController;

  Future<void> _pickMonthYear(
      String type, DashboardProvider dashboardProvider) async {
    final now = DateTime.now();
    int selectedMonth = now.month;
    int selectedYear = now.year;

    // Tentukan nilai awal berdasarkan tipe
    switch (type) {
      case 'income':
        selectedMonth = incomeSelectedMonth;
        selectedYear = incomeSelectedYear;
        break;
      case 'expense':
        selectedMonth = expenseSelectedMonth;
        selectedYear = expenseSelectedYear;
        break;
      case 'familyIncome':
        selectedMonth = familyIncomeSelectedMonth;
        selectedYear = familyIncomeSelectedYear;
        break;
      case 'familyExpense':
        selectedMonth = familyExpenseSelectedMonth;
        selectedYear = familyExpenseSelectedYear;
        break;
      default:
        throw Exception('Invalid type');
    }

    // Tampilkan picker bulan dan tahun
    final pickedDate = await showMonthYearPicker(
      context: context,
      initialDate: DateTime(selectedYear, selectedMonth),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        // Set nilai bulan dan tahun berdasarkan tipe
        switch (type) {
          case 'income':
            incomeSelectedMonth = pickedDate.month;
            incomeSelectedYear = pickedDate.year;
            dashboardProvider.getHistoryIncome(
                month: incomeSelectedMonth, year: incomeSelectedYear);
            break;
          case 'expense':
            expenseSelectedMonth = pickedDate.month;
            expenseSelectedYear = pickedDate.year;
            dashboardProvider.getHistoryExpense(
                month: expenseSelectedMonth, year: expenseSelectedYear);
            break;
          case 'familyIncome':
            familyIncomeSelectedMonth = pickedDate.month;
            familyIncomeSelectedYear = pickedDate.year;
            dashboardProvider.getFamilyHistoryIncome(
                month: familyIncomeSelectedMonth,
                year: familyIncomeSelectedYear);
            break;
          case 'familyExpense':
            familyExpenseSelectedMonth = pickedDate.month;
            familyExpenseSelectedYear = pickedDate.year;
            dashboardProvider.getFamilyHistoryExpense(
                month: familyExpenseSelectedMonth,
                year: familyExpenseSelectedYear);
            break;
        }
      });
    }
  }

  @override
  void initState() {
    context.read<DashboardProvider>().fetchDashboardData();

    context.read<FamilyCodeProvider>().fetchFamilyCode();
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Ensure the snackbar is shown only once when the widget is built
  //   showTransactionSnackbar(context, context.read<DashboardProvider>());
  // }

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
        // Jika lebar layar lebih dari 800px, tampilkan sidebar.
        final bool isWideScreen = constraints.maxWidth > 800;
        return Scaffold(
          appBar: isWideScreen
              ? null
              : AppBar(
                  title: Text("Financial Family Tracker"),
                ),
          body: Row(
            children: [
              if (isWideScreen) sideBar(),
              Expanded(
                flex: 4,
                child: PageView(
                  controller: _pageController,
                  physics: isWideScreen ? NeverScrollableScrollPhysics() : null,
                  scrollDirection: Axis.vertical, // Animasi vertikal
                  children: [
                    main(dashboardProvider, context),
                    personalReport(dashboardProvider),
                    familyReport(dashboardProvider),
                    setting(context),
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

  setting(BuildContext context) {
    return Consumer<PasswordProvider>(
        builder: (context, passwordProvider, child) {
      return SingleChildScrollView(
        child: Form(
          key: _changePasswordKey,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.medium),
            child: Column(
              children: [
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<FamilyCodeProvider>(
                          builder: (context, familyCodeProvider, child) {
                        switch (familyCodeProvider.state) {
                          case FamilyCodeState.initial:
                            return CircularProgressIndicator();
                          case FamilyCodeState.loading:
                            return CircularProgressIndicator();
                          case FamilyCodeState.error:
                            return Text(familyCodeProvider.errorMessage ??
                                "Anda bukan kepala keluarga");
                          case FamilyCodeState.success:
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: AppPadding.large,
                                  left: AppPadding.large),
                              child: Text(
                                  "Family Code: ${familyCodeProvider.familyCode ?? "Loading..."}"),
                            );
                          default:
                            return Container();
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.large),
                        child: Text("Ubah Password",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      AuthFormField(
                        controller: _oldPasswordChangePasswordController,
                        labelText: "Masukan Password Lama",
                        validator: (value) =>
                            validateText(value, "Password Lama"),
                      ),
                      AuthFormField(
                        controller: _newPasswordChangePasswordController,
                        labelText: "Masukan Password Baru",
                        validator: (value) =>
                            validateText(value, "Password Baru"),
                      ),
                      AuthFormField(
                        controller: _confirmNewPasswordChangePasswordController,
                        labelText: "Masukan Konfirmasi Password Baru",
                        validator: (value) => validateConfirmPassword(
                          confirmPassword: value,
                          newPassword:
                              _newPasswordChangePasswordController.text,
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_changePasswordKey.currentState?.validate() ??
                                false) {
                              String email =
                                  await SharedPreferencesHelper.getEmail() ??
                                      "";
                              final String oldPassword =
                                  _oldPasswordChangePasswordController.text;
                              final String newPassword =
                                  _newPasswordChangePasswordController.text;
                              final String confirmPassword =
                                  _confirmNewPasswordChangePasswordController
                                      .text;

                              // Cetak semua variabel
                              print("Identifier: $email");
                              print("Old Password: $oldPassword");
                              print("New Password: $newPassword");
                              print("Confirm Password: $confirmPassword");

                              try {
                                // Panggil metode changePassword
                                await context
                                    .read<PasswordProvider>()
                                    .changePassword(
                                      identifier: email,
                                      oldPassword: oldPassword,
                                      newPassword: newPassword,
                                      confirmNewPassword: confirmPassword,
                                    );

                                final state = passwordProvider.state;
                                if (state == PasswordState.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.green,
                                        content:
                                            Text("Password berhasil diubah!")),
                                  );
                                  _oldPasswordChangePasswordController.clear();
                                  _newPasswordChangePasswordController.clear();
                                  _confirmNewPasswordChangePasswordController
                                      .clear();
                                } else if (state == PasswordState.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            passwordProvider.errorMessage ??
                                                "Terjadi kesalahan")),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Terjadi kesalahan: $e")),
                                );
                              }
                            }
                          },
                          child: Text("Simpan"),
                        ),
                      ),
                      SizedBox(height: AppPadding.medium),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: _showLogOutDialog, child: Text("Log Out")),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text("Apakah anda yakin ingin logout akun?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () async {
                await SharedPreferencesHelper.clearAll();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (Route<dynamic> route) => false);
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  Drawer drawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Image.asset(ImageRoutes.appLogo, width: 50, height: 50),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.orange),
            title: Text(
              "Home",
            ),
            onTap: () {
              _pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
              Navigator.of(context).pop(); // Pindah ke halaman pertama
            },
          ),
          ExpansionTile(
            shape: Border(),
            title: Text("Laporan"),
            children: [
              ListTile(
                leading:
                    Icon(Icons.self_improvement_rounded, color: Colors.orange),
                title: Text(
                  "Pribadi",
                ),
                onTap: () {
                  // Navigasi atau aksi lainnya
                  _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  ); //
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.family_restroom_rounded, color: Colors.orange),
                title: Text(
                  "Keluarga",
                ),
                onTap: () {
                  // Navigasi atau aksi lainnya
                  _pageController.animateToPage(
                    2,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  ); //
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text(
              "Settings",
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
    );
  }

  SingleChildScrollView personalReport(DashboardProvider dashboardProvider) {
    print(dashboardProvider.historyExpense.length);
    print(dashboardProvider.historyIncome.length);
    print(dashboardProvider.historyExpenseMeta);
    print(dashboardProvider.historyIncomeMeta);

    print("error meta income ${dashboardProvider.historyIncomeError}");
    print("error meta expense ${dashboardProvider.historyExpenseError}");
    bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppPadding.large),
          child: Text("Laporan Pribadi",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        isWideScreen
            ? Row(
                children: [
                  moneyCard(
                      title: "Saldo",
                      balance: dashboardProvider.balance,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pemasukan",
                      balance: dashboardProvider.totalIncome,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pengeluaran",
                      balance: dashboardProvider.totalExpense,
                      isWideScreen: isWideScreen),
                ],
              )
            : Column(
                children: [
                  moneyCard(
                      title: "Saldo",
                      balance: dashboardProvider.balance,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pemasukan",
                      balance: dashboardProvider.totalIncome,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pengeluaran",
                      balance: dashboardProvider.totalExpense,
                      isWideScreen: isWideScreen),
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

  moneyCard(
      {double? balance, required String title, required bool isWideScreen}) {
    Color balanceColor = Colors.black; // default color

    // Set color based on title
    if (title == "Pemasukan") {
      balanceColor = Colors.green;
    } else if (title == "Pengeluaran") {
      balanceColor = Colors.red;
    }

    return isWideScreen
        ? Expanded(
            child: Padding(
            padding: EdgeInsets.all(AppPadding.large),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppPadding.card),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text(
                        "Rp. ${balance ?? "0"}",
                        style: TextStyle(color: balanceColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
        : Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.small),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppPadding.large),
                      child: Column(
                        children: [
                          Text(title,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            "Rp. ${balance ?? "0"}",
                            style: TextStyle(color: balanceColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
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
    bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppPadding.large),
          child: Text("Laporan Keluarga",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        isWideScreen
            ? Row(
                children: [
                  moneyCard(
                      title: "Saldo",
                      balance: dashboardProvider.balance,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pemasukan",
                      balance: dashboardProvider.totalIncome,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pengeluaran",
                      balance: dashboardProvider.totalExpense,
                      isWideScreen: isWideScreen),
                ],
              )
            : Column(
                children: [
                  moneyCard(
                      title: "Saldo",
                      balance: dashboardProvider.balance,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pemasukan",
                      balance: dashboardProvider.totalIncome,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pengeluaran",
                      balance: dashboardProvider.totalExpense,
                      isWideScreen: isWideScreen),
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

  void showTransactionSnackbar(
      BuildContext context, DashboardProvider dashboardProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dashboardProvider.editTransactionState == DashboardState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(dashboardProvider.editTransactionError ??
                "Gagal mengedit transaksi"),
          ),
        );
      } else if (dashboardProvider.editTransactionState ==
          DashboardState.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: const Text("Berhasil mengedit transaksi"),
          ),
        );
      }

      if (dashboardProvider.deleteTransactionState == DashboardState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(dashboardProvider.deleteTransactionError ??
                "Gagal menghapus transaksi"),
          ),
        );
      } else if (dashboardProvider.deleteTransactionState ==
          DashboardState.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: const Text("Berhasil menghapus transaksi"),
          ),
        );
      }
    });
  }

  historyTable({
    required List<HistoryTransaction> history,
    Meta? meta,
    required DashboardState state,
    required DashboardProvider dashboardProvider,
    required String type,
  }) {
    print("meta page ${meta?.page}");
    print("meta total page ${meta?.totalPages}");
    bool isFetching = false;
    bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(AppPadding.large),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.large),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: AppPadding.large),
                    child: (type == "historyExpense")
                        ? Text("Rincian Pengeluaran",
                            style: Theme.of(context).textTheme.headlineSmall)
                        : Text("Rincian Pemasukan",
                            style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  if (type == "historyExpense")
                    Padding(
                      padding: EdgeInsets.only(right: AppPadding.large),
                      child: ElevatedButton(
                          onPressed: () =>
                              _pickMonthYear("expense", dashboardProvider),
                          child: Text(
                              "$expenseSelectedMonth/$expenseSelectedYear")),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(right: AppPadding.large),
                      child: ElevatedButton(
                          onPressed: () =>
                              _pickMonthYear("income", dashboardProvider),
                          child:
                              Text("$incomeSelectedMonth/$incomeSelectedYear")),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 400,
              child: history.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            (state != DashboardState.loading)) {
                          if (meta != null &&
                              meta.page < meta.totalPages &&
                              !isFetching) {
                            isFetching = true;
                            setState(() {});
                            switch (type) {
                              case "historyExpense":
                                dashboardProvider
                                    .getHistoryExpense(page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              case "historyIncome":
                                dashboardProvider
                                    .getHistoryIncome(page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              case "familyHistoryExpense":
                                dashboardProvider
                                    .getFamilyHistoryExpense(
                                        page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              case "familyHistoryIncome":
                                dashboardProvider
                                    .getFamilyHistoryIncome(page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              default:
                                isFetching = false;
                            }
                          }
                        }
                        return false;
                      },
                      child: isWideScreen
                          ? ListView(
                              children: [
                                DataTable(
                                  columns: const [
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Keterangan')),
                                    DataColumn(label: Text('Kategori')),
                                    DataColumn(label: Text('Jumlah')),
                                    DataColumn(label: Text('Tanggal')),
                                    DataColumn(label: Text('Aksi')),
                                  ],
                                  rows: history.map((expense) {
                                    final index = history.indexOf(expense) + 1;
                                    return DataRow(cells: [
                                      DataCell(Text('$index')),
                                      DataCell(Text(expense.description)),
                                      DataCell(Text(expense.category)),
                                      DataCell(Text(
                                          'Rp. ${expense.amount.toString()}')),
                                      DataCell(Text(
                                          '${expense.transactionAt.toLocal().toString().split(' ')[0]}')),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                _editTransaction(context,
                                                    expense); // Panggil fungsi edit
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _deleteTransaction(
                                                    context, expense.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                  // [
                                  // ],
                                )
                              ],
                            )
                          : ListView(
                              children: [
                                ScrollableDataTable(
                                  history: history,
                                  onEdit: (transaction) =>
                                      _editTransaction(context, transaction),
                                  onDelete: (transactionId) =>
                                      _deleteTransaction(
                                          context, transactionId),
                                ),
                              ],
                            ),
                    )
                  : Center(
                      child: Text("Belum ada transaksi di bulan ini"),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  familyHistoryTable(
      {required List<FamilyHistoryTransaction> familyHistory,
      Meta? meta,
      required DashboardState state,
      required DashboardProvider dashboardProvider,
      required String type}) {
    bool isFetching = false;
    bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(AppPadding.large),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.large),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: AppPadding.large),
                    child: (type == "familyHistoryExpense")
                        ? Text("Rincian Pengeluaran",
                            style: Theme.of(context).textTheme.headlineSmall)
                        : Text("Rincian Pemasukan",
                            style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  if (type == "familyHistoryExpense")
                    Padding(
                      padding: EdgeInsets.only(right: AppPadding.large),
                      child: ElevatedButton(
                          onPressed: () => _pickMonthYear(
                              "familyExpense", dashboardProvider),
                          child: Text(
                              "$familyExpenseSelectedMonth/$familyExpenseSelectedYear")),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(right: AppPadding.large),
                      child: ElevatedButton(
                          onPressed: () =>
                              _pickMonthYear("familyIncome", dashboardProvider),
                          child: Text(
                              "$familyIncomeSelectedMonth/$familyIncomeSelectedYear")),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 400,
              child: familyHistory.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
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
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              case "historyIncome":
                                dashboardProvider
                                    .getHistoryIncome(page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              case "familyHistoryExpense":
                                dashboardProvider
                                    .getFamilyHistoryExpense(
                                        page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              case "familyHistoryIncome":
                                dashboardProvider
                                    .getFamilyHistoryIncome(page: meta.page + 1)
                                    .then((_) {
                                  isFetching =
                                      false; // Lepaskan kunci setelah selesai
                                });
                                break;
                              default:
                                isFetching = false;
                            }
                          }
                        }
                        return false;
                      },
                      child: isWideScreen
                          ? ListView(
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
                                  rows: familyHistory.map((expense) {
                                    final index =
                                        familyHistory.indexOf(expense) + 1;
                                    return DataRow(cells: [
                                      DataCell(Text('$index')),
                                      DataCell(
                                          Text(expense.member.user.username)),
                                      DataCell(Text(expense.description)),
                                      DataCell(Text(expense.category)),
                                      DataCell(Text(
                                          'Rp. ${expense.amount.toString()}')),
                                      DataCell(Text(
                                          '${expense.transactionAt.toLocal().toString().split(' ')[0]}')),
                                    ]);
                                  }).toList(),
                                  // [
                                  // ],
                                )
                              ],
                            )
                          : ListView(
                              children: [
                                FamilyScrollableDataTable(
                                    history: familyHistory),
                              ],
                            ),
                    )
                  : Center(
                      child: Text("Belum ada transaksi bulan ini"),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _editTransaction(
      BuildContext context, HistoryTransaction transaction) async {
    final updatedTransaction = await showDialog<HistoryTransaction>(
      context: context,
      builder: (context) {
        String description = transaction.description;
        String category = transaction.category;
        double amount = transaction.amount;
        DateTime transactionAt = transaction.transactionAt;

        // State controllers for TextField
        TextEditingController descriptionController =
            TextEditingController(text: description);
        TextEditingController categoryController =
            TextEditingController(text: category);
        TextEditingController amountController =
            TextEditingController(text: amount.toString());
        TextEditingController dateController = TextEditingController(
            text: transactionAt.toLocal().toString().split(' ')[0]);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Transaksi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Keterangan'),
                    controller: descriptionController,
                    onChanged: (value) => description = value,
                  ),
                  SizedBox(height: AppPadding.large),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    controller: categoryController,
                    onChanged: (value) => category = value,
                  ),
                  SizedBox(height: AppPadding.large),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => amount = double.tryParse(value) ?? 0,
                  ),
                  SizedBox(height: AppPadding.large),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Tanggal'),
                    controller: dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: transactionAt,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          transactionAt = picked;
                          dateController.text =
                              transactionAt.toLocal().toString().split(' ')[0];
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      transaction.copyWith(
                        description: description,
                        category: category,
                        amount: amount,
                        transactionAt: transactionAt,
                      ),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updatedTransaction != null) {
      // Panggil API untuk menyimpan perubahan
      await context.read<DashboardProvider>().editTransaction(
            transactionId: updatedTransaction.id,
            amount: updatedTransaction.amount,
            transactionType: updatedTransaction.transactionType,
            category: updatedTransaction.category,
            transactionAt: updatedTransaction.transactionAt,
            description: updatedTransaction.description,
          );

      showTransactionSnackbar(context, context.read<DashboardProvider>());
    }
  }

  void _deleteTransaction(BuildContext context, int transactionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi'),
          content:
              const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await context
          .read<DashboardProvider>()
          .deleteTransaction(transactionId: transactionId);
      showTransactionSnackbar(context, context.read<DashboardProvider>());
    }
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
    bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppPadding.large),
          child: Text("Dashboard",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        isWideScreen
            ? Row(
                children: [
                  moneyCard(
                      title: "Saldo",
                      balance: dashboardProvider.balance,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pemasukan",
                      balance: dashboardProvider.totalIncome,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pengeluaran",
                      balance: dashboardProvider.totalExpense,
                      isWideScreen: isWideScreen),
                ],
              )
            : Column(
                children: [
                  moneyCard(
                      title: "Saldo",
                      balance: dashboardProvider.balance,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pemasukan",
                      balance: dashboardProvider.totalIncome,
                      isWideScreen: isWideScreen),
                  moneyCard(
                      title: "Pengeluaran",
                      balance: dashboardProvider.totalExpense,
                      isWideScreen: isWideScreen),
                ],
              ),
        isWideScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  transactionSection(context, dashboardProvider, isWideScreen),
                  recentHistory(context, dashboardProvider, isWideScreen),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  transactionSection(context, dashboardProvider, isWideScreen),
                  recentHistory(context, dashboardProvider, isWideScreen),
                ],
              ),
      ],
    ));
  }

  transactionSection(BuildContext context, DashboardProvider dashboardProvider,
      bool isWideScreen) {
    return isWideScreen
        ? Flexible(
            flex: 3,
            child: DefaultTabController(
                length: 3,
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.large),
                  child: Card(
                    child: Column(
                      children: [
                        TabBar(tabs: [
                          Padding(
                            padding: const EdgeInsets.all(AppPadding.medium),
                            child: Text("Pengeluaran"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppPadding.medium),
                            child: Text("Pemasukan"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppPadding.medium),
                            child: Text("Transfer"),
                          ),
                        ]),
                        SizedBox(
                          height: 302,
                          child: TabBarView(children: [
                            addExpense(context, dashboardProvider),
                            addIncome(context, dashboardProvider),
                            tranfer(context, dashboardProvider),
                          ]),
                        ),
                      ],
                    ),
                  ),
                )),
          )
        : DefaultTabController(
            length: 3,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.large),
              child: Card(
                child: Column(
                  children: [
                    TabBar(tabs: [
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.medium),
                        child: Text("Pengeluaran"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.medium),
                        child: Text("Pemasukan"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.medium),
                        child: Text("Transfer"),
                      ),
                    ]),
                    SizedBox(
                      height: 302,
                      child: TabBarView(children: [
                        addExpense(context, dashboardProvider),
                        addIncome(context, dashboardProvider),
                        tranfer(context, dashboardProvider),
                      ]),
                    ),
                  ],
                ),
              ),
            ));
  }

  recentHistory(BuildContext context, DashboardProvider dashboardProvider,
      bool isWideScreen) {
    return isWideScreen
        ? Flexible(
            flex: 1,
            child: SizedBox(
              height: 392,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.large),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.medium),
                        child: Text("Riwayat Transaksi",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      Expanded(
                        child: dashboardProvider.recentTransactions.isNotEmpty
                            ? ListView.separated(
                                separatorBuilder: (context, index) =>
                                    Divider(color: Color(0xFFE0E0E0)),
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount:
                                    dashboardProvider.recentTransactions.length,
                                itemBuilder: (context, index) {
                                  TransactionData transaction =
                                      dashboardProvider
                                          .recentTransactions[index];
                                  return ListTile(
                                    title: Text(transaction.description),
                                    subtitle: Text(
                                        "${transaction.transactionAt.weekday}/${transaction.transactionAt.month}/${transaction.transactionAt.year}"),
                                    trailing: Text(
                                      "Rp. ${transaction.amount.toString()}",
                                      style: TextStyle(
                                          color: (transaction.transactionType ==
                                                  "INCOME")
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text("Belum melakukan transaksi"),
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
              ),
            ))
        : SizedBox(
            height: 392,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.large),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppPadding.medium),
                      child: Text("Riwayat Transaksi",
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    Expanded(
                      child: dashboardProvider.recentTransactions.isNotEmpty
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  Divider(color: Color(0xFFE0E0E0)),
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  dashboardProvider.recentTransactions.length,
                              itemBuilder: (context, index) {
                                TransactionData transaction =
                                    dashboardProvider.recentTransactions[index];
                                return ListTile(
                                  title: Text(transaction.description),
                                  subtitle: Text(
                                      "${transaction.transactionAt.weekday}-${transaction.transactionAt.month}-${transaction.transactionAt.year}"),
                                  trailing: Text(
                                      "Rp. ${transaction.amount.toString()}"),
                                );
                              },
                            )
                          : Center(
                              child: Text("Belum melakukan transaksi"),
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
            ),
          );
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.medium, vertical: AppPadding.small),
            child: DropdownButtonFormField<int>(
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
          Center(
            child: ElevatedButton(
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
                            backgroundColor: Colors.red,
                            content: Text(dashboardProvider.addExpenseError ??
                                "Terjadi kesalahan saat menambahkan pengeluaran")),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Transfer berhasil")),
                    );
                    _transferDescController.clear();
                    selectedFamilyMemberId = null;
                    _transferTotalController.clear();

                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Terjadi kesalahan: $e")),
                    );
                  }
                }
              },
              child: Text("Simpan"),
            ),
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
          Center(
            child: ElevatedButton(
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

                    if (dashboardProvider.addIncomeState ==
                        DashboardState.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(dashboardProvider.addExpenseError ??
                                "Terjadi kesalahan saat menambahkan pengeluaran")),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Pendapatan berhasil disimpan")),
                    );
                    _incomeDescController.clear();
                    _incomeCategoryController.clear();
                    _incomeTotalController.clear();
                    incomeAt = null;

                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Terjadi kesalahan: $e")),
                    );
                  }
                }
              },
              child: Text("Simpan"),
            ),
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
          Center(
            child: ElevatedButton(
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
                            backgroundColor: Colors.red,
                            content: Text(dashboardProvider.addExpenseError ??
                                "Terjadi kesalahan saat menambahkan pengeluaran")),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Pengeluaran berhasil disimpan")),
                    );
                    _expenseDescController.clear();
                    _expenseCategoryController.clear();
                    _expenseTotalController.clear();
                    expenseAt = null;

                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Terjadi kesalahan: $e")),
                    );
                  }
                }
              },
              child: Text("Simpan"),
            ),
          ),
        ],
      ),
    );
  }

  Flexible sideBar() {
    return Flexible(
      flex: 1,
      child: Material(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Image.asset(ImageRoutes.appLogo, width: 50, height: 50),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.orange),
              title: Text(
                "Home",
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
              shape: Border(),
              title: Text("Laporan"),
              children: [
                ListTile(
                  leading: Icon(Icons.self_improvement_rounded,
                      color: Colors.orange),
                  title: Text(
                    "Pribadi",
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
                  leading:
                      Icon(Icons.family_restroom_rounded, color: Colors.orange),
                  title: Text(
                    "Keluarga",
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
              leading: Icon(Icons.settings, color: Colors.orange),
              title: Text(
                "Settings",
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
