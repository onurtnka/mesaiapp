import 'salary_result_model.dart'; // Hesaplanan aylık sonuçları tutan model dosyası

class SalaryCalculatorService {
  // 12 ay listesi – her ay için hesaplama yapılacak
  final List<String> months = [
    "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
    "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
  ];

  // 2025 Gelir Vergisi Dilimleri (Verginet birebir)
  final List<_TaxBracket> gv = [
    _TaxBracket(limit: 110000, rate: 0.15),     // 0 – 110.000 TL → %15
    _TaxBracket(limit: 230000, rate: 0.20),     // 110.000 – 230.000 → %20
    _TaxBracket(limit: 580000, rate: 0.27),     // 230.000 – 580.000 → %27
    _TaxBracket(limit: 3000000, rate: 0.35),    // 580.000 – 3.000.000 → %35
    _TaxBracket(limit: 999999999, rate: 0.40),  // Üstü → %40
  ];

  // 2025 gelir vergisi ve damga vergisi istisnaları
  static const double gvIstisna = 3315.70;   // Gelir Vergisi istisnası (AGİ yerine)
  static const double damgaIstisna = 197.38; // Damga vergisi istisnası

  // Artan oranlı GV hesaplama (Verginet formülü birebir)
  double _calculateIncomeTax(double matrah, double prevKumulatif) {
    double remaining = matrah; // Bu ayın vergilendirilecek matrahı
    double tax = 0;            // Bu ay çıkacak vergi

    for (var bracket in gv) {
      // Geçen ayki kümülatif, dilimin limitini aşmış mı? Aştıysa limit kadar say.
      double usedBefore = prevKumulatif > bracket.limit ? bracket.limit : prevKumulatif;

      // Bu dilimde kalan boş alan
      double available = bracket.limit - usedBefore;
      if (available <= 0) continue;

      // Bu ayın matrahının dilimde vergilenecek kısmı
      double taxable = remaining > available ? available : remaining;

      tax += taxable * bracket.rate; // İlgili dilim oranı ile hesapla
      remaining -= taxable;          // Geriye kalan matrah

      if (remaining <= 0) break;     // Vergilenecek matrah kalmadı
    }

    return tax; // Bu ayın gelir vergisi
  }

  // Tek bir ayın maaş hesabı
  SalaryResult calculateMonth({
    required String month,
    required double brut,
    required double prevKumulatif,
  }) {
    double sgkIsci = brut * 0.14;       // SGK işçi payı %14
    double issizlikIsci = brut * 0.01;  // İşsizlik sig. işçi payı %1

    double matrah = brut - sgkIsci - issizlikIsci; // Vergi matrahı (brüt - kesintiler)

    double gelirVergisi = _calculateIncomeTax(matrah, prevKumulatif); // Artan oranlı GV
    double damgaVergisi = brut * 0.00759; // Damga vergisi %0.759

    // ⭐ Verginet net maaş hesabı
    double net = brut
        - sgkIsci
        - issizlikIsci
        - gelirVergisi
        - damgaVergisi
        + gvIstisna; // Gelir vergisi istisnası eklenir

    // Verginet'te "Net Ödenecek Tutar" → netIst
    double netIst = net;

    // İşveren maliyetleri
    double sgkIsveren = brut * 0.155;  // SGK işveren payı %15.5
    double issizlikIsveren = brut * 0.02; // İşsizlik sigortası işveren payı %2
    double toplamMaliyet = brut + sgkIsveren + issizlikIsveren; // İşveren toplam maliyeti

    return SalaryResult(
      month: month,                // Ay adı
      brut: brut,                  // Brüt maaş
      sgkIsci: sgkIsci,            // SGK işçi kesintisi
      issizlikIsci: issizlikIsci,  // İşsizlik işçi kesintisi
      damgaVergisi: damgaVergisi,  // Damga vergisi
      gelirVergisi: gelirVergisi,  // Gelir vergisi
      matrah: matrah,              // Matrah
      kumulatif: prevKumulatif + matrah, // Bu ay + önceki aylar toplam matrah
      net: net,                    // Net maaş
      netIst: netIst,              // Net ödenecek
      sgkIsveren: sgkIsveren,      // SGK işveren payı
      issizlikIsveren: issizlikIsveren, // İşsizlik işveren payı
      toplamMaliyet: toplamMaliyet, // İşveren maliyet
    );
  }

  // 12 ay için hesap döngüsü
  List<SalaryResult> calculateYear(double brut) {
    double kumulatif = 0; // Yıl boyunca matrah birikir
    List<SalaryResult> results = [];

    for (var m in months) {
      final r = calculateMonth(
        month: m,
        brut: brut,
        prevKumulatif: kumulatif, // Bir önceki ayın birikmiş matrahı
      );

      kumulatif = r.kumulatif; // Kümülatifi güncelle
      results.add(r);          // Listeye ekle
    }

    return results; // 12 aylık maaş listesi
  }
}

// Vergi dilimi yapısı (limit + oran)
class _TaxBracket {
  final double limit;
  final double rate;
  _TaxBracket({required this.limit, required this.rate});
}
