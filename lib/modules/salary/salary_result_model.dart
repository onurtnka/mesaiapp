class SalaryResult {
  final String month;
  final double brut;
  final double sgkIsci;
  final double issizlikIsci;
  final double damgaVergisi;
  final double gelirVergisi;
  final double matrah;
  final double kumulatifMatrah; // İsmi bu, 'kumulatif' değil
  final double gvIstisnaTutari; // İsmi bu
  final double dvIstisnaTutari;
  final double netEleGecen; // İsmi bu
  final double isverenMaliyeti;

  SalaryResult({
    required this.month,
    required this.brut,
    required this.sgkIsci,
    required this.issizlikIsci,
    required this.damgaVergisi,
    required this.gelirVergisi,
    required this.matrah,
    required this.kumulatifMatrah,
    required this.gvIstisnaTutari,
    required this.dvIstisnaTutari,
    required this.netEleGecen,
    required this.isverenMaliyeti,
  });
}