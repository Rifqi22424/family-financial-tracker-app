import 'package:flutter/material.dart';

import '../../../core/consts/app_colors.dart';
import '../../../core/consts/app_padding.dart';

class DatePicker extends StatelessWidget {
  // final BuildContext context;
  final DateTime? minDate;
  final DateTime? date;
  final void Function(DateTime) onDatePicked;

  const DatePicker({
    Key? key,
    // required this.context,
    this.minDate,
    required this.date,
    required this.onDatePicked,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context, DateTime? date,
      void Function(DateTime) onDatePicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? minDate,
      firstDate: minDate ?? DateTime.now(), // Gunakan minDate jika tersedia
      lastDate: DateTime(2100),
      // builder: (context, child) {
        // return Theme(
        //   data: Theme.of(context).copyWith(
        //     colorScheme: ColorScheme.light(
        //       primary: AppColors.orange, // header background color
        //       onPrimary: AppColors.white, // header text color
        //       onSurface: AppColors.black, // body text color
        //     ),
        //     textButtonTheme: TextButtonThemeData(
        //       style: TextButton.styleFrom(
        //         foregroundColor: AppColors.orange, // button text color
        //       ),
        //     ),
        //   ),
        //   child: child!,
        // );
        
      // },
    );
    if (picked != null && picked != date) {
      onDatePicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.medium, vertical: AppPadding.small),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                _selectDate(context, date, onDatePicked);
              },
              child: ListTile(
                title: Text(
                  date == null
                      ? 'Pilih tanggal'
                      : '${date!.day}/${date!.month}/${date!.year}',
                  // style: AppStyles.labelTextStyle,
                ),
                trailing: Icon(Icons.calendar_today, size: 24),
              ),
            ),
          ),
        )
      ],
    );
  }
}
