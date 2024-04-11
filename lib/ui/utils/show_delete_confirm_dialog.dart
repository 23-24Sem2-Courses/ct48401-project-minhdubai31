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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Text(
        content,
        style: const TextStyle(fontSize: 15),
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
                    message: "Deleted successfully",
                    color: Theme.of(context).primaryColor);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
