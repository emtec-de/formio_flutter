import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final dynamic value;
  final String? hint;
  final String? errorText;
  final List<DropdownMenuItem<dynamic>>? items;
  final Function? onChanged;
  final Widget? leftIcon;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final Color? textColor;
  final double? textSize;

  const CustomDropDown({
    Key? key,
    this.value,
    this.hint,
    this.errorText,
    this.items,
    this.onChanged,
    this.leftIcon,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.textColor,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor!,
              width: borderWidth!,
            ),
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          child: Row(
            children: [
              leftIcon != null ? SizedBox(width: 12) : Container(),
              leftIcon != null ? leftIcon! : Container(),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButton<dynamic>(
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                  ),
                  value: value,
                  hint: Padding(
                    padding: contentPadding,
                    child: Text(
                      hint != null ? hint! : "",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  items: items,
                  onChanged: (item) {
                    onChanged!(item);
                  },
                  isExpanded: true,
                  underline: Container(),
                  icon: Padding(
                    padding: contentPadding,
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[800],
              ),
            ),
          )
      ],
    );
  }
}
