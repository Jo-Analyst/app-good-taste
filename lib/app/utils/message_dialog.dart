class ListMessageDialog {

  static List<Map<String, dynamic>> messageDialog (String? item) => [
    {
      "title": "Deseja excluir?",
      "content": "Você realmente tem certeza que deseja excluir?",
      "action": "Excluir",
      "show_button_cancel": true,
      "show_button_YN": false,
    },
    {
      "title": "Deseja excluir?",
      "content":
          "Ao excluir você também removerá os items relacionadas a ela. Você realmente tem certeza que deseja excluir?",
      "action": "Excluir",
      "show_button_cancel": true,
      "show_button_YN": false,
    },
    {
      "title": "Deseja sair?",
      "content":
          "Os seguintes sabores foram excluídos da lista: $item\n Você confirma esta ação?",
      "action": "Sim",
      "show_button_cancel": false,
      "show_button_YN": true,
    },
  ];
}
