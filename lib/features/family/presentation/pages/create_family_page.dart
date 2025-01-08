import 'package:financial_family_tracker/core/consts/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/widgets/form_field_registration.dart';
import '../../data/models/arguments/join_family_argument.dart';
import '../../states/create_family_provider.dart';

class CreateFamilyPage extends StatefulWidget {
  final RoleArgument argument;
  const CreateFamilyPage({super.key, required this.argument});

  @override
  State<CreateFamilyPage> createState() => _CreateFamilyPageState();
}

class _CreateFamilyPageState extends State<CreateFamilyPage> {
  final TextEditingController _familyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CreateFamilyProvider>(
        builder: (context, createFamilyProvider, child) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        "Selamat datang kepala keluarga \nSilahkan beri nama keluarga anda"),
                    Row(
                      children: [
                        Expanded(
                          child: AuthFormField(
                              controller: _familyNameController,
                              labelText: "Nama Keluarga"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final String familyName =
                                _familyNameController.text.trim();
                            if (familyName.isEmpty) return;

                            await createFamilyProvider.createFamily(
                              familyName,
                              widget.argument.role,
                            );

                            if (createFamilyProvider.state ==
                                CreateFamilyState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                  content: Text(
                                      createFamilyProvider.errorMessage ??
                                          "Terjadi kesalahan"),
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                    backgroundColor: Colors.green,
                                content: Text("Keluarga berhasil dibuat"),
                              ),
                            );
                            Navigator.pushNamed(context, "/dashboard");
                          },
                          child: createFamilyProvider.state ==
                                  CreateFamilyState.loading
                              ? const CircularProgressIndicator()
                              : const Text("Buat keluarga"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
