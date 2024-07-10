import 'package:flutter/material.dart';
import 'package:test_ta_1/config/app_color.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    required this.label,
    required this.onTap,
    this.isExpand,
    this.color,
    this.boxShadowColor, 
    this.hasShadow = true,
  }) : super(key: key);

  final String label;
  final Function onTap;
  final bool? isExpand;
  final Color? color;
  final Color? boxShadowColor; 
  final bool hasShadow; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          if (hasShadow) 
            Align(
              alignment: const Alignment(0, 0.7),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: boxShadowColor ?? AppColor.primary, 
                      offset: const Offset(0, 5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                width: isExpand == null
                    ? null
                    : isExpand!
                        ? double.infinity
                        : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  label,
                ),
              ),
            ),
          Align(
            child: Material(
              color: color ?? AppColor.primary,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onTap(),
                child: Container(
                  width: isExpand == null
                      ? null
                      : isExpand!
                          ? double.infinity
                          : null,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 12,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColor.netrall,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
