import '../../states/join_family_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/arguments/join_family_argument.dart';
import '../../../auth/presentation/widgets/form_field_registration.dart';

class JoinFamilyPage extends StatefulWidget {
  final RoleArgument argument;
  const JoinFamilyPage({super.key, required this.argument});

  @override
  State<JoinFamilyPage> createState() => _JoinFamilyPageState();
}

class _JoinFamilyPageState extends State<JoinFamilyPage> {
  TextEditingController _familyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.argument.role);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Selamat datang ibu/ anak, Silahkan \nmasukan kode keluarga anda"),
                Row(
                  children: [
                    Expanded(
                        child: AuthFormField(
                      controller: _familyCodeController,
                      labelText: "kode keluarga",
                    )),
                    ElevatedButton(onPressed: () {}, child: Text("Verifikasi"))
                  ],
                ),
                Consumer<JoinFamilyProvider>(
                  builder: (context, joinFamilyProvider, child) {
                    switch (joinFamilyProvider.state) {
                      case JoinFamilyState.loading:
                        return CircularProgressIndicator();
                      default:
                        return ElevatedButton(
                          onPressed: () async {
                            final String familyCode =
                                _familyCodeController.text.trim();
        
                            if (familyCode.isEmpty) return;
        
                            await joinFamilyProvider.joinFamily(
                              familyCode,
                              widget.argument.role,
                            );
                            if (joinFamilyProvider.state ==
                                JoinFamilyState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(joinFamilyProvider.errorMessage ??
                                      "Terjadi kesalahan"),
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Berhasil bergabung ke keluarga"),
                              ),
                            );
                            Navigator.pushNamed(context, "/dashboard");
                          },
                          child: const Text("Login"),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
