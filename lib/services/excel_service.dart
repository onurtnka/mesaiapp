import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../core/app_database.dart';

class ExcelService {
  Future<void> exportToExcel(List<MesaiTableData> mesailer, List<UserSalaryTableData> maaslar) async {
    var excel = Excel.createExcel();

    // 1. Sayfa: Mesai Kayıtları
    Sheet sheet1 = excel['Mesai Kayıtları'];
    
    // Başlık Satırı (Header)
    List<String> headers1 = ["Tarih", "Saat", "Çarpan", "Ücret (TL)", "Açıklama"];
    sheet1.appendRow(headers1.map((e) => TextCellValue(e)).toList());

    // Verileri Ekle
    for (var item in mesailer) {
      String date = DateFormat("dd.MM.yyyy").format(item.tarih);
      sheet1.appendRow([
        TextCellValue(date),
        DoubleCellValue(item.saat),
        DoubleCellValue(item.carpan),
        DoubleCellValue(item.ucret),
        TextCellValue(item.aciklama ?? ""),
      ]);
    }

    // 2. Sayfa: Maaş Geçmişi
    Sheet sheet2 = excel['Maaş Geçmişi'];
    List<String> headers2 = ["Aylık Brüt", "Aylık Net", "Saatlik Net", "SGK İşçi", "Damga Vergisi"];
    sheet2.appendRow(headers2.map((e) => TextCellValue(e)).toList());

    for (var item in maaslar) {
      sheet2.appendRow([
        DoubleCellValue(item.monthlyBrut),
        DoubleCellValue(item.monthlyNet),
        DoubleCellValue(item.hourlyRateNet ?? 0),
        DoubleCellValue(item.sgkIsci),
        DoubleCellValue(item.damga),
      ]);
    }

    // Varsayılan "Sheet1"i sil (Excel kütüphanesi otomatik oluşturuyor)
    excel.delete('Sheet1');

    // Dosyayı Kaydet ve Paylaş
    final fileBytes = excel.save();
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "Mesai_Raporu_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx";
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsBytes(fileBytes!);

    // Paylaşım Penceresini Aç
    await Share.shareXFiles([XFile(file.path)], text: "Mesai ve Maaş Raporum");
  }
}