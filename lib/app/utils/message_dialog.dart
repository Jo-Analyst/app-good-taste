class ListMessageDialog {
  static List<Map<String, dynamic>> messageDialog = [
    {
      "title": "Deseja sair?",
      "content": "Você tem certeza que deseja sair sem confirmar a transação?",
      "action": "Sair",
      "show_button_cancel": true,
    },
    {
      "title": "Deseja excluir?",
      "content": "Você realmente tem certeza que deseja excluir?",
      "action": "Excluir",
      "show_button_cancel": true,
    },
    {
      "title": "Mensagem",
      "content": "Adicione pelo menos um sabor",
      "action": "OK",
      "show_button_cancel": false,
    },
  ];
}
