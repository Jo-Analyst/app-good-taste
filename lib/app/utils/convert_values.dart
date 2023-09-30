import 'package:intl/intl.dart';

final NumberFormat numberFormat =
    NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
final DateFormat dateFormat1 = DateFormat("yyyy-MM-dd", "pt_BR");
final DateFormat dateFormat2 =
    DateFormat("EEEE',' dd 'de' MMMM 'de' yyyy", "pt_BR");
final DateFormat dateFormat3 = DateFormat("dd 'de' MMMM 'de' yyyy", "pt_BR");
final DateFormat dateFormat4 = DateFormat("dd/MM/yyyy", "pt_BR");
final DateFormat dateFormat5 =
    DateFormat("EEEE', dia ' dd 'de' MMMM 'de' yyyy 'às' HH:mm:ss", "pt_BR");
