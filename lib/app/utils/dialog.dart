import 'package:flutter/material.dart';

// Future<bool?> showExitDialog() async {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Deseja sair?'),
//           content: const Text('Você tem certeza que deseja sair sem confirmar a transação?'),
//           actions: [
//             TextButton(
//               child: const Text('Cancelar'),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//             ),
//             TextButton(
//               child: const Text('Sair'),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//           ],
//         );
//       },
//     ) ?? false;
//   }

// // void showExitDialog(BuildContext context) {
//   // showDialog(
//   //   context: context,
//   //   builder: (BuildContext context) {
//   //     return AlertDialog(
//   //       title: const Text('Deseja sair?'),
//   //       content: const Text('Você tem certeza que deseja sair sem confirmar a transação?'),
//   //       actions: [
//   //         TextButton(
//   //           child: const Text('Cancelar'),
//   //           onPressed: () {
//   //             Navigator.of(context).pop();
//   //           },
//   //         ),
//   //         TextButton(
//   //           child: const Text('Sair'),
//   //           onPressed: () {
//   //             Navigator.of(context).pop();
//   //             Navigator.of(context).pop();
//   //           },
//   //         ),
//   //       ],
//   //     );
//   //   },
//   // );
// // }

Future<bool?> showExitDialog(
    BuildContext context, Map<String, String> messageDialog) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(messageDialog["title"]!),
        content: Text(messageDialog["content"]!),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child:  Text(messageDialog["action"]!),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
