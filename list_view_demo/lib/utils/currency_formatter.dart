extension CurrencyFormatter on double {
  String toThaiBaht() {
    List<String> parts = toStringAsFixed(2).split('.');
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = parts[0].replaceAllMapped(
      reg,
      (Match match) => '${match[1]},',
    );
    return '$formatted.${parts[1]} บาท';
  }
}
