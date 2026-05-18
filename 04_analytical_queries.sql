-- Aşama 4: Analitik Sorgular

-- 1. JOIN Sorgusu (En az 3 tablo birleştirme)
-- Senaryo: Sipariş veren müşterinin adı, siparişin verildiği restoranın adı ve siparişi teslim eden kuryenin adını getiren, 
-- teslim edilmiş (Delivered) siparişlerin listesi.
-- Bu sorgu, teslimat performansını ve hangi müşterinin hangi restorandan kurye aracılığıyla hizmet aldığını görmek için kullanılır.
SELECT 
    o.OrderID,
    u_cust.FullName AS CustomerName,
    r.Name AS RestaurantName,
    u_cour.FullName AS CourierName,
    o.TotalAmount,
    o.OrderDate
FROM 
    Orders o
JOIN 
    Users u_cust ON o.CustomerID = u_cust.UserID
JOIN 
    Restaurants r ON o.RestaurantID = r.RestaurantID
JOIN 
    Couriers c ON o.CourierID = c.CourierID
JOIN 
    Users u_cour ON c.UserID = u_cour.UserID
WHERE 
    o.Status = 'Delivered';


-- 2. Gruplama ve Agregasyon (GROUP BY ve HAVING)
-- Senaryo: Restoranların performans analizi. 
-- En az 5 adet sipariş almış ve bu siparişlerin ortalama tutarı 100 TL'nin üzerinde olan restoranları ve toplam gelirlerini listeler.
-- Bu sorgu, yüksek ciro yapan ve aktif olan (çok sipariş alan) restoranları tespit etmek için kullanılır.
SELECT 
    r.RestaurantID,
    r.Name AS RestaurantName,
    COUNT(o.OrderID) AS TotalOrders,
    AVG(o.TotalAmount) AS AverageOrderAmount,
    SUM(o.TotalAmount) AS TotalRevenue
FROM 
    Restaurants r
JOIN 
    Orders o ON r.RestaurantID = o.RestaurantID
WHERE 
    o.Status != 'Cancelled'
GROUP BY 
    r.RestaurantID, r.Name
HAVING 
    COUNT(o.OrderID) >= 5 AND AVG(o.TotalAmount) > 100
ORDER BY 
    TotalRevenue DESC;


-- 3. Alt Sorgu (Subquery - IN / EXISTS)
-- Senaryo: Sisteme kayıtlı, ancak "Askıda Yemek" havuzuna GİZLİ (anonim olmayan) bağış yapmış "Hayırsever" müşterileri bulma.
-- Bu sorgu, platformun sadık ve hayırsever kullanıcılarını belirleyip onlara özel kampanya (örneğin indirim kuponu) sunmak için kullanılabilir.
SELECT 
    UserID,
    FullName,
    Email
FROM 
    Users u
WHERE 
    u.Role = 'Customer' 
    AND EXISTS (
        SELECT 1 
        FROM SuspendedMealDonations smd 
        WHERE smd.DonorID = u.UserID 
          AND smd.IsAnonymous = FALSE
    );

-- Ek Alt Sorgu Örneği (IN Kullanımı):
-- Senaryo: Hiç sipariş almamış menü ürünlerini bulma (Menü optimizasyonu için).
SELECT 
    ItemID,
    Name,
    Price
FROM 
    MenuItems
WHERE 
    IsActive = TRUE
    AND ItemID NOT IN (
        SELECT DISTINCT ItemID 
        FROM OrderItems
    );
