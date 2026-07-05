# Product Horizontal ListView App

A modern, highly-polished Flutter application illustrating a product catalog using a horizontal `ListView.builder` loaded dynamically from a JSON mockup asset, complete with query and mutation implementations.

---

## สารบัญ / Table of Contents

1. [การสร้าง Class ใน Flutter (Dart)](#1-การสร้าง-class-ใน-flutter-dart)
2. [หลักการทำงานของ ListView ในแนวตั้งและแนวนอน](#2-หลักการทำงานของ-listview-ในแนวตั้งและแนวนอน)
3. [การสร้าง Card และการจัดโครงสร้าง Layout](#3-การสร้าง-card-และการจัดโครงสร้าง-layout)
4. [โครงสร้าง JSON, ระบบแปลภาษา และส่วน Query / Mutation](#4-โครงสร้าง-json-ระบบแปลภาษา-และส่วน-query--mutation)
5. [โครงสร้างโครงงานสถาปัตยกรรม (Project Structure)](#5-โครงสร้างโครงงานสถาปัตยกรรม-project-structure)

---

## 1. การสร้าง Class ใน Flutter (Dart)

ในภาษา Dart เราใช้คำสำคัญ `class` ในการสร้าง Model เพื่อกำหนดรูปแบบและโครงสร้างของข้อมูล เช่น คลาส `Product` สำหรับเก็บรายละเอียดของสินค้า ดังนี้:

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int rating;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  // สร้างออบเจกต์ Product จากโครงสร้าง JSON Map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      rating: json['rating'] as int,
    );
  }

  // แปลงออบเจกต์ Product เป็น Map เพื่อนำไปบันทึกหรือส่งเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }

  // ตัวช่วยคัดลอกออบเจกต์พร้อมอัปเดตค่าฟิลด์บางส่วน (ใช้สำหรับการแก้ไขข้อมูล - Mutation)
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? rating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
    );
  }
}
```

---

## 2. หลักการทำงานของ ListView ในแนวตั้งและแนวนอน

`ListView` เป็นวิจิทที่นิยมที่สุดตัวหนึ่งในการแสดงข้อมูลที่มีรายการจำนวนมากแบบเลื่อนไหล (Scrollable list):

### ListView แบบปกติ (แนวตั้ง - Vertical)

- **ทิศทางเริ่มต้น (Default Direction)**: เลื่อนขึ้น-ลงตามแนวตั้ง (`scrollDirection: Axis.vertical`)
- **การใช้พื้นที่**: จะพยายามขยายความกว้างเต็มขนาดพื้นที่ของ parent ในแนวนอน และเลื่อนไหลแบบไม่มีที่สิ้นสุดในแนวตั้ง

### ListView.builder แบบแนวนอน (Horizontal)

- **ทิศทาง (Direction)**: เลื่อนซ้าย-ขวาในแนวนอน โดยกำหนด `scrollDirection: Axis.horizontal`
- **ข้อกำหนดสำคัญ**: เนื่องจากเป็นแนวนอนและขยายความกว้างแบบไม่จำกัด ตัววิจิท ListView.builder จำเป็นต้องครอบด้วย Container หรือวิจิทจำกัดความสูงที่แน่นอน (เช่น `SizedBox(height: 300)`) เพื่อป้องกันไม่ให้เกิดข้อผิดพลาด Layout Overflow
- **การประหยัดหน่วยความจำ**: การใช้ `.builder` ร่วมกับ `itemCount` และ `itemBuilder` จะช่วยให้ระบบสร้างแค่วิจิทเฉพาะที่แสดงอยู่บนหน้าจอจริงเท่านั้น ทำให้ประสิทธิภาพของแอปรวดเร็วขึ้น

---

## 3. การสร้าง Card และการจัดโครงสร้าง Layout

วิจิท `Card` เป็นส่วนที่ใช้จัดเก็บเนื้อหาสินค้าแต่ละชิ้นให้ดูเป็นสัดส่วน สวยงาม และโดดเด่น:

1. **Card & ClipRRect**: ใช้ `Card` กำหนดเงา (`elevation`) ความโค้งมน (`shape`) จากนั้นหุ้มโครงสร้างทั้งหมดด้วย `ClipRRect` เพื่อตัดขอบรูปภาพที่แสดงด้านบนให้โค้งมนรับกับตัวการ์ดพอดี
2. **การรันรูปภาพในเครื่อง (Local Assets)**: แอปพลิเคชันได้ดึงรูปภาพของ Unsplash ทั้งหมดมาจัดเก็บลงเครื่องไว้ใน `assets/images/` และใช้ `Image.asset()` เพื่อดึงภาพขึ้นมาแสดงผลได้ทันทีแบบออฟไลน์
3. **การแสดงราคาเงินบาทพร้อมคอมมาคั่นหลักพัน**: ใช้ Extension ฟอร์แมตสกุลเงินด้วย Regex คั่นลูกน้ำอย่างมีระเบียบตามรูปแบบ `1,890.00 บาท`
4. **ความคล่องตัวและการจัดแยก Widget**:
   - แยกวิดเจ็ตแสดงผลย่อยออกไปเป็นไฟล์อิสระเดี่ยวๆ ใน `lib/widgets/` เพื่อล้างความซับซ้อนของ Build Method ของหน้าหลักออกทั้งหมด

---

## 4. โครงสร้าง JSON, ระบบแปลภาษา และส่วน Query / Mutation

โปรเจกต์นี้ได้รับการปรับปรุงโดยแยกส่วนของการดึงข้อมูล การแปลภาษา และระบบการจัดการสถานะออกจากกันอย่างชัดเจนตามสถาปัตยกรรม Clean Code:

### โครงสร้างไฟล์ Mockup (`assets/products.json`)

```json
[
  {
    "id": "PROD-001",
    "name": "Wireless Headphones",
    "price": 1890.00,
    "imageUrl": "assets/images/prod_001.jpg",
    "rating": 4
  }
]
```

### การทำระบบแปลภาษา (Centralized Translation)
มีคลาส `AppStrings` ใน `lib/constants/app_strings.dart` คอยดูแลเก็บรวบรวมข้อความภาษาไทยทั้งหมดที่แสดงในแอปพลิเคชัน เพื่อให้ง่ายต่อการปรับเปลี่ยนข้อความหรือแปลภาษาในอนาคต

### การทำ Query & Mutation ด้วย Controller & Repository
เพื่อจัดการสถานะข้อมูลสินค้าในหน่วยความจำและดึงจากไฟล์จำลอง:

1. **Query (ดึงข้อมูลอย่างเป็นสัดส่วนตามคะแนน)**:
   - `getProducts()`: เรียกอ่านและแปลงไฟล์ `assets/products.json` เป็นลิสต์ของ Products ในครั้งแรก และส่งคืนรายการแคชทั้งหมด
   - `recommendedProducts`: ดึงเฉพาะสินค้าที่มีคะแนนรีวิวตั้งแต่ **4 ดาวขึ้นไป** แสดงบนสไลเดอร์แนวนอนด้านบน
   - `generalProducts`: ดึงเฉพาะสินค้าที่มีคะแนนรีวิว**ต่ำกว่า 4 ดาว** แสดงในตารางกรีดด้านล่างเพื่อแก้ปัญหาข้อมูลซ้ำซ้อน
2. **Mutation (เปลี่ยนแปลงข้อมูลตะกร้าสินค้า & การประเมินดาว)**:
   - `updateRating(Product product, int rating)`: อัปเดตดาวของสินค้า (ตัวสินค้าจะเคลื่อนย้ายสลับที่ระหว่างแถบสินค้าแนะนำและสินค้าทั่วไปแบบเรียลไทม์ตามระดับคะแนนดาวที่เปลี่ยนแปลงไป)
   - `addToCart(Product product)`: เพิ่มสินค้าเข้าสู่ตะกร้าสะสม (`cart`) เพื่อแสดงสถิติตัวเลขนับบนเมนู Toolbar
   - `removeFromCart(Product product)`: นำสินค้าออกจากตะกร้าสะสม

---

## 5. โครงสร้างโครงงานสถาปัตยกรรม (Project Structure)

โปรเจกต์ได้รับการออกแบบตามโครงสร้างไฟล์ที่ดีของ Flutter:

```
lib/
├── constants/
│   └── app_strings.dart          # AppStrings centralized translation class
├── controllers/
│   └── products_controller.dart  # ProductsController (ChangeNotifier state manager)
├── models/
│   └── product.dart              # Product data model & JSON serialization
├── repositories/
│   └── product_repository.dart   # ProductRepository class (Query/Mutation service layer)
├── screens/
│   ├── home_page.dart            # MyHomePage UI with event methods
│   └── cart_screen.dart          # CartScreen showing cart item list, total amount & checkout
├── utils/
│   └── currency_formatter.dart   # CurrencyFormatter double extension for Thai Baht formatting
├── widgets/
│   ├── product_card.dart         # ProductCard stateless UI component using Image.asset
│   ├── home_hero_section.dart    # Home page top hero widget
│   ├── home_recommended_section.dart # Recommended list slider widget
│   ├── home_general_products_section.dart # General products grid widget
│   ├── cart_empty_state.dart     # Cart empty placeholder widget
│   ├── cart_list_view.dart       # Cart list items widget
│   └── cart_summary_panel.dart   # Cart summary and checkout drawer widget
└── main.dart                     # MyApp root with GoogleFonts Sarabun applied
```
