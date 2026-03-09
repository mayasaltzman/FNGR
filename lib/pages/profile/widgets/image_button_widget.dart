import 'dart:io';
import 'package:flutter/material.dart';


class ImageButton extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.image,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 180,
          height: 280,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryFixed,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: image != null
                    ? Image.file(
                        image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Center(
                      child: Icon(
                        Icons.add, 
                        color: Theme.of(context).colorScheme.primaryFixed,
                      )
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//widget for key info form