import 'package:financial_family_tracker/core/consts/app_padding.dart';
import 'package:financial_family_tracker/features/auth/data/models/arguments/email_argument.dart';
import 'package:financial_family_tracker/features/auth/presentation/widgets/form_field_registration.dart';
import 'package:financial_family_tracker/features/auth/states/verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerficationPage extends StatefulWidget {
  final EmailArgument argument;
  const VerficationPage({super.key, required this.argument});

  @override
  State<VerficationPage> createState() => _VerficationPageState();
}

class _VerficationPageState extends State<VerficationPage> {
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppPadding.medium),
              Text(
                  "Pendaftaran berhasil. Silakan cek email Anda untuk verifikasi."),
              AuthFormField(
                  controller: _verificationCodeController,
                  labelText: "Masukan kode verifikasi"),
              Consumer<VerificationProvider>(
                  builder: (context, verificationProvider, child) {
                switch (verificationProvider.state) {
                  case VerificationState.loading:
                    return CircularProgressIndicator();
                  default:
                    return ElevatedButton(
                        onPressed: () async {
                          final verificationCode =
                              _verificationCodeController.text.trim();
                          if (verificationCode.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Kode verifikasi tidak boleh kosong")),
                            );
                            return;
                          }

                          await verificationProvider.verifyEmail(
                              widget.argument.email, verificationCode);

                          if (verificationProvider.state ==
                              VerificationState.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      verificationProvider.errorMessage ??
                                          "Terjadi kesalahan")),
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    verificationProvider.response?.message ??
                                        "Verifikasi Berhasil")),
                          );

                          Navigator.pushNamed(context, "/role_selection");
                        },
                        child: Text("Submit"));
                }
              }),
              SizedBox(height: AppPadding.medium),
            ],
          ),
        ),
      ),
    ));
  }
}
