import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class const WhenEmptyCard({
  required final String title,
  required final String subtitle,
  required final IconData icon,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
