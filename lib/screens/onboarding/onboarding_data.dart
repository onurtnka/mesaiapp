// lib/screens/welcome/onboarding_data.dart

class OnboardingData {
  OnboardingData({
    this.weeklyHours = '45',
    this.monthlyWorkHours = '225',
    this.salaryType = 'gross', // 'gross' (Brüt) veya 'net'
    this.salaryAmount = '',
    this.overtimeWeekday = '1.5',
    this.overtimeWeekend = '1.5',
    this.overtimeHoliday = '2.0', // Resmi tatil
  });

  String weeklyHours;
  String monthlyWorkHours;
  String salaryType;
  String salaryAmount;
  String overtimeWeekday;
  String overtimeWeekend;
  String overtimeHoliday;
}