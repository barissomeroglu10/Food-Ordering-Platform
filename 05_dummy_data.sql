-- Aşama 4 (Ek): Örnek Test Verileri (Dummy Data)

-- 1. Kullanıcılar
INSERT INTO Users (FullName, Email, PasswordHash, Role) VALUES
('Ahmet Yılmaz', 'ahmet@example.com', 'hashedpw123', 'Customer'),
('Ayşe Kaya', 'ayse@example.com', 'hashedpw123', 'Customer'),
('Mehmet Usta', 'mehmet@example.com', 'hashedpw123', 'RestaurantOwner'),
('Ali Veli', 'ali@example.com', 'hashedpw123', 'Courier');

-- 2. Restoranlar
INSERT INTO Restaurants (OwnerID, Name, Address) VALUES
(3, 'Usta Kebap', 'Atatürk Cad. No:1, İstanbul'),
(3, 'Lezzet Ev Yemekleri', 'Cumhuriyet Bulv. No:2, Ankara');

-- 3. Kuryeler
INSERT INTO Couriers (UserID, VehicleType) VALUES
(4, 'Motorcycle');

-- 4. Menü Ürünleri
INSERT INTO MenuItems (RestaurantID, Name, Description, Price) VALUES
(1, 'Adana Kebap', 'Acılı zırh kebabı', 150.00),
(1, 'Urfa Kebap', 'Acısız kebap', 140.00),
(2, 'Kuru Fasulye', 'Etli kuru fasulye', 80.00),
(2, 'Pilav', 'Tereyağlı pirinç pilavı', 40.00);

-- 5. Siparişler
INSERT INTO Orders (CustomerID, RestaurantID, CourierID, TotalAmount, Status) VALUES
(1, 1, 1, 0, 'Delivered'), -- Toplam tutar trigger ile güncellenecek
(2, 2, 1, 0, 'Pending');

-- 6. Sipariş Kalemleri (TotalAmount trigger tarafından Orders'da güncellenecek)
INSERT INTO OrderItems (OrderID, ItemID, Quantity, UnitPrice) VALUES
(1, 1, 2, 150.00), -- 300
(1, 2, 1, 140.00), -- 140 -> Total: 440
(2, 3, 1, 80.00),  -- 80
(2, 4, 1, 40.00);  -- 40 -> Total: 120

-- 7. Askıda Yemek Bağışları (Trigger çalışacak ve Havuzu güncelleyecek)
-- Ahmet (UserID 1) Usta Kebap'a (Rest 1) anonim olmayan 200 TL bakiye bağışı yapıyor.
INSERT INTO SuspendedMealDonations (DonorID, RestaurantID, DonationType, Amount, IsAnonymous) VALUES
(1, 1, 'Balance', 200.00, FALSE);

-- İsimsiz biri Usta Kebap'a 2 adet yemek bağışı yapıyor.
INSERT INTO SuspendedMealDonations (DonorID, RestaurantID, DonationType, Amount, IsAnonymous) VALUES
(NULL, 1, 'Meal', 2, TRUE);

-- 8. Askıda Yemek Kullanımı (Trigger çalışıp Havuzdan düşecek)
-- Ayşe (UserID 2) Usta Kebap'tan (Rest 1) 1 nolu siparişte (Aslında 3 nolu sipariş olmalı, uyduralım) yemek kullandı
INSERT INTO Orders (CustomerID, RestaurantID, Status) VALUES (2, 1, 'Delivered'); -- OrderID 3 oldu.
INSERT INTO SuspendedMealUsages (BeneficiaryID, RestaurantID, OrderID) VALUES
(2, 1, 3);
