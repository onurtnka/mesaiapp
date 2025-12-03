class SalaryResult {
  final String month;

  final double brut;
  final double sgkIsci;
  final double issizlikIsci;
  final double damgaVergisi;
  final double gelirVergisi;

  final double matrah;
  final double kumulatifMatrah;

  final double damgaIstisna;
  final double gelirVergisiDilimi;
  final double net;
  final double netIstisnaSonrasi;

  final double sgkIsveren;
  final double issizlikIsveren;
  final double toplamMaliyet;

  SalaryResult({
    required this.month,
    required this.brut,
    required this.sgkIsci,
    required this.issizlikIsci,
    required this.damgaVergisi,
    required this.gelirVergisi,
    required this.matrah,
    required this.kumulatifMatrah,
    required this.damgaIstisna,
    required this.gelirVergisiDilimi,
    required this.net,
    required this.netIstisnaSonrasi,
    required this.sgkIsveren,
    required this.issizlikIsveren,
    required this.toplamMaliyet,
  });
}
