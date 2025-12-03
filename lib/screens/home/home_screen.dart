import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; 
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Veritabanı ve Tablo Importları
import '../../core/app_database.dart';
import '../../data/tables/mesai_table.dart';

// Mesai Ekleme Ekranı
import '../mesai/add_mesai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDatabase db;
  
  // Data
  double currentMonthTotal = 0;
  double totalHours = 0;
  List<MesaiTableData> recentActivities = []; 
  
  // Grafik Verileri
  List<FlSpot> chartData = []; 
  List<String> chartLabels = []; 
  double chartMaxY = 100;

  bool isLoading = true;
  double monthlyGoal = 50000;

  @override
  void initState() {
    super.initState();
    // Veritabanını güvenli şekilde al ve yüklemeyi başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      db = context.read<AppDatabase>();
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      monthlyGoal = prefs.getDouble("monthlyGoal") ?? 50000;

      final now = DateTime.now();
      
      // Veritabanından verileri çek
      final allMesai = await db.select(db.mesaiTable).get();
      
      // --- BU AYIN ÖZETİ ---
      final thisMonthMesai = allMesai.where((m) => m.tarih.month == now.month && m.tarih.year == now.year).toList();
      
      double sumMoney = 0;
      double sumHours = 0;
      for (var m in thisMonthMesai) {
        sumMoney += m.ucret;
        sumHours += m.saat;
      }

      // --- SON HAREKETLER ---
      final recent = List.of(allMesai)..sort((a, b) => b.tarih.compareTo(a.tarih));
      final limitedRecent = recent.take(5).toList();

      // --- GRAFİK VERİSİ ---
      List<FlSpot> spots = [];
      List<String> labels = [];
      double calculatedMaxY = 0;

      for (int i = 5; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        
        final monthRecords = allMesai.where((m) => m.tarih.year == date.year && m.tarih.month == date.month);
        final monthTotal = monthRecords.fold<double>(0, (sum, item) => sum + item.ucret);
        
        spots.add(FlSpot((5 - i).toDouble(), monthTotal));
        
        // 🔥 HATA OLMAMASI İÇİN GÜVENLİ TARİH FORMATI
        try {
          labels.add(DateFormat.MMM("tr_TR").format(date));
        } catch (e) {
          // Eğer tr_TR yüklü değilse varsayılanı kullan
          labels.add("${date.month}");
        }

        if (monthTotal > calculatedMaxY) calculatedMaxY = monthTotal;
      }

      // Veri yoksa estetik dummy data
      if (calculatedMaxY == 0) {
        calculatedMaxY = 100;
        spots = [
          const FlSpot(0, 10), const FlSpot(1, 30), const FlSpot(2, 20),
          const FlSpot(3, 50), const FlSpot(4, 40), const FlSpot(5, 60),
        ];
        // Etiketleri güvenli doldur
        labels = [];
        for (int i = 5; i >= 0; i--) {
           final date = DateTime(now.year, now.month - i, 1);
           try {
             labels.add(DateFormat.MMM("tr_TR").format(date));
           } catch (_) {
             labels.add("${date.month}");
           }
        }
      }

      if (mounted) {
        setState(() {
          currentMonthTotal = sumMoney;
          totalHours = sumHours;
          recentActivities = limitedRecent;
          chartData = spots;
          chartLabels = labels;
          chartMaxY = calculatedMaxY * 1.2;
        });
      }

    } catch (e) {
      debugPrint("Veri Yükleme Hatası: $e");
      // Hata olsa bile kullanıcıya boş ekran gösterme
    } finally {
      // 🔥 NE OLURSA OLSUN LOADING'İ KAPAT
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // --- RENK PALETİ ---
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get colBg => isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
  Color get colCard => isDark ? const Color(0xFF1F2937) : Colors.white;
  Color get colTextMain => isDark ? Colors.white : const Color(0xFF1E293B);
  Color get colTextSec => isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
  Color get colPrimary => const Color(0xFF3B82F6); 
  Color get colAccent => const Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colBg,
      body: isLoading 
          ? Center(child: CircularProgressIndicator(color: colPrimary)) 
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildMasterCard(),
                        const SizedBox(height: 24),
                        _buildAnalyticsSection(),
                        const SizedBox(height: 24),
                        _buildRecentHeader(),
                        const SizedBox(height: 12),
                        _buildRecentList(),
                        const SizedBox(height: 120), // Navigasyon bar payı
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // 1. HEADER
  Widget _buildAppBar() {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) return 'Günaydın';
      if (hour < 17) return 'İyi Günler';
      return 'İyi Akşamlar';
    }

    return SliverAppBar(
      backgroundColor: colBg,
      elevation: 0,
      pinned: true,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: colPrimary.withOpacity(0.2),
              radius: 16,
              child: Icon(LucideIcons.user, size: 18, color: colPrimary),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting(), style: TextStyle(color: colTextSec, fontSize: 10, fontWeight: FontWeight.w500)),
                Text("Kullanıcı", style: TextStyle(color: colTextMain, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: colCard, shape: BoxShape.circle),
            child: Icon(LucideIcons.bell, size: 20, color: colTextMain),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  // 2. MASTER CARD
  Widget _buildMasterCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF2563EB), const Color(0xFF1E40AF)] 
              : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20, child: _circleDeco(150)),
          Positioned(bottom: -50, left: -20, child: _circleDeco(200)),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Text("Bu Ayki Kazanç", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const Icon(LucideIcons.wallet, color: Colors.white70),
                  ],
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: currentMonthTotal),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeOutExpo,
                      builder: (context, value, child) {
                        return Text(
                          "₺${NumberFormat("#,##0", "tr_TR").format(value)}",
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Toplam ${totalHours.toStringAsFixed(1)} saat mesai",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleDeco(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0)],
        ),
      ),
    );
  }

  // 3. ANALİTİK KARTLARI
  Widget _buildAnalyticsSection() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 180, 
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0), 
            decoration: BoxDecoration(
              color: colCard,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kazanç Trendi", style: TextStyle(color: colTextSec, fontSize: 12, fontWeight: FontWeight.bold)),
                    Icon(LucideIcons.trendingUp, size: 16, color: colPrimary),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false), 
                      borderData: FlBorderData(show: false), 
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30, 
                            interval: 1, 
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < chartLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    chartLabels[index],
                                    style: TextStyle(
                                      color: colTextSec, 
                                      fontSize: 10, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      
                      minX: 0, maxX: 5,
                      minY: 0, maxY: chartMaxY,
                      
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData,
                          isCurved: true, 
                          curveSmoothness: 0.35,
                          color: colPrimary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 3,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: colPrimary,
                              );
                            }
                          ),
                          
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [colPrimary.withOpacity(0.2), colPrimary.withOpacity(0.0)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) => colTextMain,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                "₺${spot.y.toStringAsFixed(0)}",
                                TextStyle(color: colCard, fontWeight: FontWeight.bold, fontSize: 12),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: Column(
            children: [
              _quickBtn(
                LucideIcons.plus, 
                "Ekle", 
                colAccent,
                onTap: () async {
                  await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const AddMesaiScreen())
                  );
                  _loadData(); 
                },
              ),
              const SizedBox(height: 12),
              _quickBtn(
                LucideIcons.fileText, 
                "Rapor", 
                const Color(0xFFF59E0B),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Detaylı rapor yakında!"))
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickBtn(IconData icon, String label, Color color, {required VoidCallback onTap}) {
    return Container(
      height: 74,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // 4. SON HAREKETLER
  Widget _buildRecentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Son Hareketler", style: TextStyle(color: colTextMain, fontSize: 18, fontWeight: FontWeight.w800)),
        Text("Tümü", style: TextStyle(color: colPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildRecentList() {
    if (recentActivities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: colCard, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Icon(LucideIcons.clock, size: 40, color: colTextSec.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text("Henüz kayıt yok", style: TextStyle(color: colTextSec)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentActivities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = recentActivities[index];
        return _buildTransactionTile(item);
      },
    );
  }

  Widget _buildTransactionTile(MesaiTableData item) {
    String dateStr = "";
    try {
      dateStr = DateFormat("dd MMM", "tr_TR").format(item.tarih);
    } catch (_) {
      dateStr = "${item.tarih.day}/${item.tarih.month}";
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(LucideIcons.briefcase, color: colPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.aciklama == null || item.aciklama!.isEmpty) ? "Mesai Kaydı" : item.aciklama!,
                  style: TextStyle(color: colTextMain, fontWeight: FontWeight.bold, fontSize: 15)
                ),
                Text(dateStr, style: TextStyle(color: colTextSec, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("+₺${item.ucret.toStringAsFixed(0)}", style: TextStyle(color: colAccent, fontWeight: FontWeight.w900, fontSize: 16)),
              Text("${item.saat} saat", style: TextStyle(color: colTextSec, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}