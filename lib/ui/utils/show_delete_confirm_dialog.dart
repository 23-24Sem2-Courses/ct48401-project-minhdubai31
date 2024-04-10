import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback deleteMethod,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ConfirmDeleteDialog(
        onDeleteConfirmed: deleteMethod,
        title: title,
        content: content,
      );
    },
  );
}

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onDeleteConfirmed;

  const ConfirmDeleteDialog(
      {super.key,
      required this.onDeleteConfirmed,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                onDeleteConfirmed();
                Navigator.of(context).pop();
                showFlushbar(
                    context: context,
                    message: "Post was deleted successfully",
                    color: Theme.of(context).primaryColor);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
