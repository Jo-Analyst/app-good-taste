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
    {
      "title": "Mensagem",
      "content": "Informa a matéria prima utilizada na produção",
      "action": "OK",
      "show_button_cancel": false,
    },{
      "title": "Deseja excluir?",
      "content": "Ao excluir você também removerá os items relacionadas a ela. Você realmente tem certeza que deseja excluir?",
      "action": "Excluir",
      "show_button_cancel": true,
    },
  ];
}
