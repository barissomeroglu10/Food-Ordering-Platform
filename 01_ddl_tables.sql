-- Aşama 1: DDL ve Temel Tabloların Oluşturulması

-- Kullanıcılar tablosu (Müşteri, Restoran Sahibi, Kurye)
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) CHECK (Role IN ('Customer', 'RestaurantOwner', 'Courier')) NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Restoranlar tablosu
CREATE TABLE Restaurants (
    RestaurantID SERIAL PRIMARY KEY,
    OwnerID INT NOT NULL,
    Name VARCHAR(150) NOT NULL,
    Address TEXT NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_restaurant_owner FOREIGN KEY (OwnerID) REFERENCES Users(UserID)
);

-- Kuryeler tablosu
CREATE TABLE Couriers (
    CourierID SERIAL PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    VehicleType VARCHAR(50) CHECK (VehicleType IN ('Bicycle', 'Motorcycle', 'Car')),
    IsActive BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_courier_user FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Menü Ürünleri
CREATE TABLE MenuItems (
    ItemID SERIAL PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) CHECK (Price >= 0) NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_menu_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Siparişler tablosu
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    CourierID INT,
    TotalAmount DECIMAL(10, 2) DEFAULT 0,
    Status VARCHAR(30) CHECK (Status IN ('Pending', 'Preparing', 'OnTheWay', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsActive BOOLEAN DEFAULT TRUE, -- İptal yerine kaydı gizlemek istenirse
    CONSTRAINT fk_order_customer FOREIGN KEY (CustomerID) REFERENCES Users(UserID),
    CONSTRAINT fk_order_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    CONSTRAINT fk_order_courier FOREIGN KEY (CourierID) REFERENCES Couriers(CourierID)
);

-- Sipariş Kalemleri
CREATE TABLE OrderItems (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0) NOT NULL,
    UnitPrice DECIMAL(10, 2) CHECK (UnitPrice >= 0) NOT NULL,
    CONSTRAINT fk_orderitem_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT fk_orderitem_item FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- Askıda Yemek Havuzu (Her restoranın kendi havuzu)
CREATE TABLE SuspendedMealPool (
    PoolID SERIAL PRIMARY KEY,
    RestaurantID INT UNIQUE NOT NULL,
    TotalBalance DECIMAL(10, 2) DEFAULT 0 CHECK (TotalBalance >= 0),
    AvailableMeals INT DEFAULT 0 CHECK (AvailableMeals >= 0),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pool_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Askıda Yemek Bağışları
CREATE TABLE SuspendedMealDonations (
    DonationID SERIAL PRIMARY KEY,
    DonorID INT, -- Nullable çünkü anonim bağış olabilir
    RestaurantID INT NOT NULL,
    DonationType VARCHAR(20) CHECK (DonationType IN ('Balance', 'Meal')) NOT NULL,
    Amount DECIMAL(10, 2) CHECK (Amount > 0) NOT NULL, -- Miktar (Para veya Adet)
    IsAnonymous BOOLEAN DEFAULT FALSE,
    DonationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_donation_donor FOREIGN KEY (DonorID) REFERENCES Users(UserID),
    CONSTRAINT fk_donation_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Askıda Yemek Kullanımları
CREATE TABLE SuspendedMealUsages (
    UsageID SERIAL PRIMARY KEY,
    BeneficiaryID INT NOT NULL,
    RestaurantID INT NOT NULL,
    OrderID INT UNIQUE NOT NULL, -- Hangi sipariş ile kullanıldı
    UsageDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usage_beneficiary FOREIGN KEY (BeneficiaryID) REFERENCES Users(UserID),
    CONSTRAINT fk_usage_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    CONSTRAINT fk_usage_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
