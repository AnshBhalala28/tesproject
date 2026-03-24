import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final IconData prefixIcon;

  CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(prefixIcon, color: Colors.blueAccent, size: 22),
              SizedBox(width: 15),
              Text(
                hint,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          icon:
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
          isExpanded: true,
          // આખા Container માં ફેલાઈ જશે
          borderRadius: BorderRadius.circular(15),
          dropdownColor: Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(prefixIcon,
                      color: Colors.blueAccent.withOpacity(0.5), size: 20),
                  SizedBox(width: 15),
                  Text(
                    item,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
