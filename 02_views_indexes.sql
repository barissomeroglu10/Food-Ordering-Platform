-- Aşama 2: Görünümler (Views) ve İndeksler

-- GÖRÜNÜMLER (VIEWS)

-- 1. Görünüm: Restoranların Askıda Yemek Havuzu Durumu
-- Bu view, restoran bilgileri ile havuzdaki güncel bakiye/yemek adedini birleştirerek karmaşık sorguları basitleştirir.
CREATE OR REPLACE VIEW vw_SuspendedMealPoolStatus AS
SELECT 
    r.RestaurantID,
    r.Name AS RestaurantName,
    p.TotalBalance AS PoolBalance,
    p.AvailableMeals AS PoolMeals,
    p.LastUpdated
FROM 
    Restaurants r
LEFT JOIN 
    SuspendedMealPool p ON r.RestaurantID = p.RestaurantID
WHERE 
    r.IsActive = TRUE;

-- 2. Görünüm: Detaylı Sipariş Özeti (Fiş/Fatura Detayı)
-- Sipariş başlığını, müşteri bilgilerini, kuryeyi ve restoranı tek bir sanal tabloda toplayarak analitik raporlamayı kolaylaştırır.
CREATE OR REPLACE VIEW vw_OrderSummary AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Status,
    o.TotalAmount,
    c.FullName AS CustomerName,
    c.Email AS CustomerEmail,
    r.Name AS RestaurantName,
    cr_u.FullName AS CourierName
FROM 
    Orders o
JOIN 
    Users c ON o.CustomerID = c.UserID
JOIN 
    Restaurants r ON o.RestaurantID = r.RestaurantID
LEFT JOIN 
    Couriers cr ON o.CourierID = cr.CourierID
LEFT JOIN 
    Users cr_u ON cr.UserID = cr_u.UserID
WHERE 
    o.IsActive = TRUE;

-- İNDEKSLER (INDEXES)

-- Sipariş tablolarında sıkça aranan yabancı anahtarlar (Foreign Keys) için indeksler:
-- Müşterinin sipariş geçmişini hızlı getirmek için
CREATE INDEX idx_orders_customer_id ON Orders(CustomerID);

-- Restoranın sipariş geçmişini hızlı getirmek için
CREATE INDEX idx_orders_restaurant_id ON Orders(RestaurantID);

-- Bir siparişin kalemlerini hızlı çekmek için
CREATE INDEX idx_orderitems_order_id ON OrderItems(OrderID);

-- Performans için restoran ismine göre aramalarda kullanılabilecek indeks (B-Tree)
CREATE INDEX idx_restaurants_name ON Restaurants(Name);

-- Askıda Yemek bağışlarını tarihe göre sıralamak/filtrelemek için indeks
CREATE INDEX idx_suspendedmealdonations_date ON SuspendedMealDonations(DonationDate);
