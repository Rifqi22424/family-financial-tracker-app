import 'package:financial_family_tracker/features/family/data/models/arguments/join_family_argument.dart';
import 'package:flutter/material.dart';

import '../../../../core/consts/app_colors.dart';
import '../../../../core/consts/app_padding.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  List<String> _roles = ["AYAH", "IBU", "ANAK"];
  String? _selectedRole;
  bool _isHeadOfFamily = false; // Menyimpan pilihan kepala keluarga

  void _showHeadOfFamilyDialog(String role) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text(
              "Anda memilih peran $role. Apakah Anda ingin menjadi kepala keluarga?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isHeadOfFamily = false;
                });
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isHeadOfFamily = true;
                });
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
          child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Silahkan untuk memilih role anda"),
              ..._roles.map((role) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.small),
                  child: ChoiceChip(
                    label: Text(
                      role,
                      style: TextStyle(
                          color: _selectedRole == role
                              ? AppColors.white
                              : AppColors.black),
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.large, vertical: AppPadding.medium),
                    selected: _selectedRole == role,
                    selectedColor: AppColors.orange,
                    checkmarkColor: AppColors.white,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedRole = selected ? role : null;
                        _isHeadOfFamily = false;
                      });
                      if (selected && (role == "AYAH" || role == "IBU")) {
                        _showHeadOfFamilyDialog(role);
                      }
                    },
                  ),
                );
              }).toList(),
              SizedBox(height: AppPadding.medium),
              ElevatedButton(
                  onPressed: () {
                    if (_selectedRole == null) return;
            
                    _isHeadOfFamily
                        ? Navigator.pushNamed(context, "/create_family",
                            arguments: RoleArgument(
                              role: _selectedRole ?? 'AYAH',
                            ))
                        : Navigator.pushNamed(context, "/join_family",
                            arguments: RoleArgument(
                              role: _selectedRole ?? 'ANAK',
                            ));
            
                    setState(() {
                      _selectedRole = null;
                    });
                  },
                  child: Text("Lanjut"))
            ]),
          ),
        ),
      ),
    );
  }
}
