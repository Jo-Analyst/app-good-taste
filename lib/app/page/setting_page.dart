import 'package:flutter/material.dart';
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool darkTheme = false;
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Icon(
          Icons.check,
          color: Colors.pink[500],
        );
      }
      return const Icon(
        Icons.close,
        color: Color.fromARGB(255, 209, 207, 207),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Configuração",
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: 100,
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: const Text("Personalize o seu app"),
                subtitle: Text(darkTheme ? "Tema Escuro" : "Thema Claro"),
                leading: const Icon(
                  Icons.brightness_6_sharp,
                  color: Colors.black87,
                  size: 40,
                ),
                trailing: Theme(
                  data: Theme.of(context).copyWith(
                    useMaterial3: true,
                    switchTheme: SwitchThemeData(
                      thumbColor: MaterialStateProperty.all(Colors
                          .pink.shade500), // Cor do polegar (quando ligado)
                      trackColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 209, 207, 207),
                      ),
                      // Cor da trilha (quando desligado)
                    ),
                  ),
                  child: Switch(
                    thumbIcon: thumbIcon,
                    value: darkTheme,
                    activeTrackColor: Colors.pink.shade500,
                    activeColor: const Color.fromARGB(255, 209, 207, 207),
                    onChanged: (value) => setState(() => darkTheme = value),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("Faça uma backup"),
                subtitle: const Text("Sua segurança"),
                leading: const Icon(
                  Icons.backup_table,
                  color: Colors.black87,
                  size: 40,
                ),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Gerar"),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("Restaure o seu app"),
                leading: const Icon(
                  Icons.restore,
                  color: Colors.black87,
                  size: 40,
                ),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Restaurar"),
                ),
              ),
              // Row(
              //   children: [
              //     const Text("Thema: "),
              //     Theme(
              //       data: Theme.of(context).copyWith(
              //         useMaterial3: true,
              //         switchTheme: SwitchThemeData(
              //           thumbColor: MaterialStateProperty.all(Colors
              //               .pink.shade500), // Cor do polegar (quando ligado)
              //           trackColor: MaterialStateProperty.all(Colors.grey),
              //           // Cor da trilha (quando desligado)
              //         ),
              //       ),
              //       child: Switch(
              //         thumbIcon: thumbIcon,
              //         value: darkTheme,
              //         activeTrackColor: Colors.pink
              //             .shade500, // Define a cor da trilha quando o Switch está ativado
              //         activeColor: Colors.green,
              //         onChanged: (value) => setState(() => darkTheme = value),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
