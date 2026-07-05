class AppStrings {
  // Main & Home Page Strings
  static const String appTitle = 'ร้านค้าสินค้า';
  static const String homeTitle = 'ร้านค้าแนะนำ';
  static const String exclusiveCollection = 'คอลเลกชันสุดพิเศษ';
  static const String exclusiveCollectionDesc =
      'เลือกชมสินค้าแนะนำที่เราคัดสรรมาอย่างดี เพื่อความสะดวกสบาย สไตล์ และประสิทธิภาพการทำงานสูงสุด';
  static const String productsListed = 'รายการสินค้า';
  static const String totalValue = 'มูลค่ารวมทั้งหมด';
  static const String recommendedForYou = 'สินค้าแนะนำสำหรับคุณ';
  static const String generalProducts = 'สินค้าทั่วไป';
  static const String emptyStore = 'ไม่มีสินค้าเหลืออยู่ในร้านค้าแล้ว';
  static const String resetCatalog = 'รีเซ็ตรายการสินค้า';
  static const String reloadFromBackup = 'โหลดข้อมูลใหม่';

  // Cart Screen Strings
  static const String cartTitle = 'ตะกร้าสินค้าของคุณ';
  static const String cartEmpty = 'ไม่มีสินค้าในตะกร้าของคุณ';
  static const String cartEmptySub =
      'ย้อนกลับเพื่อเลือกซื้อสินค้าแนะนำที่น่าสนใจ';
  static const String totalCartAmount = 'ยอดรวมทั้งหมด:';
  static const String checkout = 'ดำเนินการชำระเงิน';
  static const String checkoutProcessing = 'กำลังดำเนินการชำระเงิน...';

  // SnackBars & Notifications
  static const String ratingUpdateError = 'ข้อผิดพลาดในการอัปเดตคะแนน:';
  static const String cartEmptyAlert = 'ตะกร้าสินค้าว่างเปล่า';

  static String addedProductToCart(String name) =>
      'เพิ่ม $name ลงในตะกร้าแล้ว!';
  static String removedProductFromCart(String name) =>
      'นำ $name ออกจากตะกร้าแล้ว';
  static String ratingUpdated(String name, int rating) =>
      'อัปเดตคะแนนของ $name เป็น $rating ดาวเรียบร้อย';
}
