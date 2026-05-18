# 🍔 Çevrimiçi Yemek Sipariş Platformu (Veritabanı Tasarımı)

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Database Management](https://img.shields.io/badge/Database_Systems-Academic_Project-blue?style=for-the-badge)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Veritabanı Yönetim Sistemleri (VTYS) dersi dönem projesi kapsamında tasarlanmış, **PostgreSQL** tabanlı tam teşekküllü bir çevrimiçi yemek sipariş platformu veritabanı altyapısıdır. Proje, 3. Normal Form (3NF) kurallarına sıkı sıkıya bağlı kalınarak tasarlanmış olup gelişmiş SQL programlanabilirlik nesnelerini (Triggers, Views, Indexes) bünyesinde barındırır.

---

## 🌟 Öne Çıkan Özellikler

- **Müşteri, Restoran ve Kurye Yönetimi**: Farklı kullanıcı rollerini destekleyen esnek yapı.
- **3NF Uyumluluğu**: Veri tekrarını ve anomaliyi önleyen, tabloların birbirine güçlü `FOREIGN KEY` referanslarıyla bağlandığı normalize edilmiş mimari.
- **"Askıda Yemek" Modülü 🕊️**: Hayırseverlerin restoranlara yemek veya bakiye bağışlayabildiği, ihtiyaç sahiplerinin de bu havuzdan faydalanabildiği özel bağış/yardım sistemi. Gizli bağış (anonim) ve açık bağış seçenekleri sunulur.
- **Güvenli Veri Saklama (Soft Delete)**: Hiçbir kayıt fiziksel olarak silinmez. Tüm ana tablolarda uygulanan `IsActive` (boolean) mantığı ile veri bütünlüğü ve tarihsel takip (audit) sağlanır.
- **Otomasyon (Triggers)**: Askıda yemek havuzundaki bakiyenin güncellenmesi ve sipariş toplam tutarlarının hesaplanması `TRIGGER`'lar ile otomatikleştirilmiştir.

## 📂 Depo İçeriği ve Geliştirme Aşamaları

Veritabanı scriptleri, adım adım çalıştırılabilecek şekilde 4 aşamaya bölünmüştür:

| Dosya | Açıklama |
| :--- | :--- |
| `01_ddl_tables.sql` | Tabloların oluşturulması, 3NF ilişkilerinin (PK/FK) kurulması ve Check/Unique/Not Null kısıtlamaları. |
| `02_views_indexes.sql` | Karmaşık sorguları basitleştiren `VIEW` nesneleri ve sorgu performansını artıran `INDEX` tanımlamaları. |
| `03_triggers.sql` | Askıda yemek bakiyelerini ve sipariş tutarlarını kontrol eden otomasyon fonksiyonları ve `TRIGGER` nesneleri. |
| `04_analytical_queries.sql` | Gelişmiş veri analizi için hazırlanan JOIN, GROUP BY & HAVING ve Alt Sorgular (Subquery). |
| `05_dummy_data.sql` | Sistemi test edebilmeniz için örnek Müşteri, Restoran, Sipariş ve Bağış verileri. |

## 🚀 Kurulum ve Kullanım

Bu projeyi yerel ortamınızda test etmek için sisteminizde **PostgreSQL** kurulu olmalıdır.

1. Depoyu klonlayın:
   ```bash
   git clone https://github.com/barissomeroglu10/Food-Ordering-Platform.git
   cd Food-Ordering-Platform
   ```

2. Yeni bir PostgreSQL veritabanı oluşturun.
3. SQL dosyalarını sırasıyla veritabanınızda çalıştırın:
   - Önce `01_ddl_tables.sql`
   - Ardından `02_views_indexes.sql`
   - Daha sonra `03_triggers.sql`
   - Test verilerini eklemek isterseniz `05_dummy_data.sql`
4. Analitik yetenekleri test etmek için `04_analytical_queries.sql` içindeki sorguları kullanabilirsiniz.

---
*Bu proje, Veritabanı Yönetim Sistemleri dersi gereksinimlerini karşılamak amacıyla akademik kurallar çerçevesinde hazırlanmıştır.*
