-- Aşama 3: Programlanabilirlik (Triggers)

-- 1. Bağış Yapıldığında Havuzu Güncelleyen Trigger Fonksiyonu ve Tetikleyicisi
CREATE OR REPLACE FUNCTION fn_UpdatePoolOnDonation()
RETURNS TRIGGER AS $$
BEGIN
    -- Eğer restoranın havuzu henüz yoksa, oluştur.
    IF NOT EXISTS (SELECT 1 FROM SuspendedMealPool WHERE RestaurantID = NEW.RestaurantID) THEN
        INSERT INTO SuspendedMealPool (RestaurantID, TotalBalance, AvailableMeals)
        VALUES (NEW.RestaurantID, 0, 0);
    END IF;

    -- Bağış tipine göre havuzu güncelle
    IF NEW.DonationType = 'Balance' THEN
        UPDATE SuspendedMealPool
        SET TotalBalance = TotalBalance + NEW.Amount,
            LastUpdated = CURRENT_TIMESTAMP
        WHERE RestaurantID = NEW.RestaurantID;
    ELSIF NEW.DonationType = 'Meal' THEN
        UPDATE SuspendedMealPool
        SET AvailableMeals = AvailableMeals + NEW.Amount,
            LastUpdated = CURRENT_TIMESTAMP
        WHERE RestaurantID = NEW.RestaurantID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_UpdatePoolOnDonation
AFTER INSERT ON SuspendedMealDonations
FOR EACH ROW
EXECUTE FUNCTION fn_UpdatePoolOnDonation();


-- 2. Askıda Yemek Kullanıldığında Havuzdan Düşen Trigger Fonksiyonu ve Tetikleyicisi
CREATE OR REPLACE FUNCTION fn_UpdatePoolOnUsage()
RETURNS TRIGGER AS $$
DECLARE
    current_meals INT;
BEGIN
    -- Mevcut yemek sayısını al
    SELECT AvailableMeals INTO current_meals 
    FROM SuspendedMealPool 
    WHERE RestaurantID = NEW.RestaurantID;

    -- Eğer havuzda yemek yoksa hata fırlat (iş kuralı ihlali)
    IF current_meals IS NULL OR current_meals <= 0 THEN
        RAISE EXCEPTION 'Bu restoranin askida yemek havuzunda yeterli yemek bulunmamaktadir.';
    END IF;

    -- Havuzdan 1 yemek düş
    UPDATE SuspendedMealPool
    SET AvailableMeals = AvailableMeals - 1,
        LastUpdated = CURRENT_TIMESTAMP
    WHERE RestaurantID = NEW.RestaurantID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_UpdatePoolOnUsage
AFTER INSERT ON SuspendedMealUsages
FOR EACH ROW
EXECUTE FUNCTION fn_UpdatePoolOnUsage();


-- 3. Sipariş Kalemi (OrderItem) Eklendiğinde Sipariş Toplam Tutarını (TotalAmount) Güncelleyen Trigger
CREATE OR REPLACE FUNCTION fn_CalculateOrderTotal()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Orders
    SET TotalAmount = TotalAmount + (NEW.Quantity * NEW.UnitPrice)
    WHERE OrderID = NEW.OrderID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_CalculateOrderTotal
AFTER INSERT ON OrderItems
FOR EACH ROW
EXECUTE FUNCTION fn_CalculateOrderTotal();
