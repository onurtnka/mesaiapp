import 'salary_result_model.dart';

class SalaryCalculatorService {
  final List<String> months = [
    "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
    "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
  ];

  // 2025 Vergi Dilimleri
  final List<_TaxBracket> gv = [
    _TaxBracket(limit: 110000, rate: 0.15),
    _TaxBracket(limit: 230000, rate: 0.20),
    _TaxBracket(limit: 580000, rate: 0.27),
    _TaxBracket(limit: 3000000, rate: 0.35),
    _TaxBracket(limit: 999999999, rate: 0.40),
  ];

  static const double gvIstisna = 3315.70;
  static const double damgaIstisna = 197.38;

  double _calculateIncomeTax(double matrah, double prevKumulatif) {
    double remaining = matrah;
    double tax = 0;
    for (var bracket in gv) {
      double usedBefore = prevKumulatif > bracket.limit ? bracket.limit : prevKumulatif;
      double available = bracket.limit - usedBefore;
      if (available <= 0) continue;
      double taxable = remaining > available ? available : remaining;
      tax += taxable * bracket.rate;
      remaining -= taxable;
      if (remaining <= 0) break;
    }
    return tax;
  }

  SalaryResult calculateMonth({
    required String month,
    required double brut,
    required double prevKumulatif,
  }) {
    double sgkIsci = brut * 0.14;
    double issizlikIsci = brut * 0.01;
    double matrah = brut - sgkIsci - issizlikIsci;
    double gelirVergisi = _calculateIncomeTax(matrah, prevKumulatif);
    double damgaVergisi = brut * 0.00759;
    
    // Net Ele Geçen Hesabı
    double netEleGecen = brut - sgkIsci - issizlikIsci - gelirVergisi - damgaVergisi + gvIstisna + damgaIstisna;
    
    double sgkIsveren = brut * 0.155;
    double issizlikIsveren = brut * 0.02;
    double toplamMaliyet = brut + sgkIsveren + issizlikIsveren;

    return SalaryResult(
      month: month,
      brut: brut,
      sgkIsci: sgkIsci,
      issizlikIsci: issizlikIsci,
      damgaVergisi: damgaVergisi,
      gelirVergisi: gelirVergisi,
      matrah: matrah,
      kumulatifMatrah: prevKumulatif + matrah, // Modeldeki ismiyle uyumlu
      gvIstisnaTutari: gvIstisna,
      dvIstisnaTutari: damgaIstisna,
      netEleGecen: netEleGecen, // Modeldeki ismiyle uyumlu
      isverenMaliyeti: toplamMaliyet,
    );
  }

  // 1. YILLIK HESAP (BRÜT GİRİŞİ)
  List<SalaryResult> calculateYear(List<double> monthlyGross) {
    double kumulatif = 0;
    List<SalaryResult> results = [];
    for (int i = 0; i < 12; i++) {
      final r = calculateMonth(
        month: months[i],
        brut: monthlyGross[i],
        prevKumulatif: kumulatif,
      );
      kumulatif = r.kumulatifMatrah; // Modeldeki ismiyle uyumlu
      results.add(r);
    }
    return results;
  }

  // 2. YILLIK HESAP (NET GİRİŞİ)
  List<SalaryResult> calculateYearFromNet(List<double> monthlyNets) {
    double kumulatif = 0;
    List<SalaryResult> results = [];

    for (int i = 0; i < 12; i++) {
      double targetNet = monthlyNets[i];
      double calculatedGross = _findGrossForTargetNet(targetNet, kumulatif);
      
      final r = calculateMonth(
        month: months[i],
        brut: calculatedGross,
        prevKumulatif: kumulatif,
      );
      
      kumulatif = r.kumulatifMatrah; // Modeldeki ismiyle uyumlu
      results.add(r);
    }
    return results;
  }

  double _findGrossForTargetNet(double targetNet, double currentKumulatif) {
    double low = targetNet;
    double high = targetNet * 2.5; 
    double tolerance = 0.01; 

    while (_calculateNetOnly(high, currentKumulatif) < targetNet) {
       high *= 1.5;
    }

    for (int i = 0; i < 100; i++) {
      double mid = (low + high) / 2;
      double net = _calculateNetOnly(mid, currentKumulatif);
      if ((net - targetNet).abs() < tolerance) return mid;
      if (net < targetNet) low = mid; else high = mid;
    }
    return (low + high) / 2;
  }

  double _calculateNetOnly(double brut, double prevKumulatif) {
    double sgkIsci = brut * 0.14;
    double issizlikIsci = brut * 0.01;
    double matrah = brut - sgkIsci - issizlikIsci;
    double gelirVergisi = _calculateIncomeTax(matrah, prevKumulatif);
    double damgaVergisi = brut * 0.00759;
    return brut - sgkIsci - issizlikIsci - gelirVergisi - damgaVergisi + gvIstisna + damgaIstisna;
  }
}

class _TaxBracket {
  final double limit;
  final double rate;
  _TaxBracket({required this.limit, required this.rate});
}