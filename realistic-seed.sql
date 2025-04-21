SET NOCOUNT ON;

-- 1. Seed Distilleries (Real distilleries)
INSERT INTO dbo.Distilleries (Name)
VALUES 
    ('Ardbeg'), ('Laphroaig'), ('Lagavulin'), ('Macallan'), ('Highland Park'),
    ('Glenfiddich'), ('Glenlivet'), ('Bowmore'), ('Talisker'), ('Springbank'),
    ('GlenDronach'), ('Aberlour'), ('Balvenie'), ('Caol Ila'), ('Bunnahabhain'),
    ('Oban'), ('Dalwhinnie'), ('Tomatin'), ('Glenfarclas'), ('Edradour');

-- 2. Seed Customers (Realistic names)
INSERT INTO dbo.Customers (FirstName, LastName, DateOfBirth, Address)
VALUES 
    ('John', 'Smith', '1985-06-12', '123 Whisky St, Edinburgh'),
    ('Emma', 'Brown', '1990-08-25', '45 Malt Lane, Glasgow'),
    ('Robert', 'Wilson', '1978-11-10', '89 Peat Rd, Islay'),
    ('Sophia', 'Taylor', '1983-03-15', '11 Oak St, London'),
    ('James', 'Anderson', '1995-07-20', '77 Glen Rd, Inverness'),
    ('Olivia', 'Thomas', '1988-09-05', '102 Speyside Way, Dufftown'),
    ('Michael', 'Johnson', '1976-12-01', '55 Barley Lane, Aberdeen'),
    ('Isabella', 'White', '1992-02-18', '31 Cask St, Glasgow'),
    ('David', 'Harris', '1980-04-09', '22 Smoke Rd, Campbeltown'),
    ('Charlotte', 'Clark', '1986-05-30', '99 Bourbon St, New York');

-- 3. Seed Bottles (Realistic whiskies, ages, ABV)
INSERT INTO dbo.Bottles (Name, DistilleryId, Age, AlcoholByVolume, WhiskyBaseId)
VALUES 
    ('Ardbeg 10', 1, 10, 46.0, 12345),
    ('Laphroaig Quarter Cask', 2, 5, 48.0, 23456),
    ('Lagavulin 16', 3, 16, 43.0, 34567),
    ('Macallan 18 Sherry Oak', 4, 18, 43.0, 45678),
    ('Highland Park 12 Viking Honour', 5, 12, 40.0, 56789),
    ('Glenfiddich 15 Solera', 6, 15, 40.0, 67890),
    ('Glenlivet 12', 7, 12, 40.0, 78901),
    ('Bowmore 15 Darkest', 8, 15, 43.0, 89012),
    ('Talisker 10', 9, 10, 45.8, 90123),
    ('Springbank 12 Cask Strength', 10, 12, 55.0, 12321),
    ('GlenDronach 18 Allardice', 11, 18, 46.0, 23232),
    ('Aberlour A’bunadh', 12, 0, 60.9, 34343),  -- NAS but cask strength
    ('Balvenie 14 Caribbean Cask', 13, 14, 43.0, 45454),
    ('Caol Ila 12', 14, 12, 43.0, 56565),
    ('Bunnahabhain 18', 15, 18, 46.3, 67676),
    ('Oban 14', 16, 14, 43.0, 78787),
    ('Dalwhinnie 15', 17, 15, 43.0, 89898),
    ('Tomatin 12', 18, 12, 40.0, 90909),
    ('Glenfarclas 21', 19, 21, 43.0, 10101),
    ('Edradour 10', 20, 10, 40.0, 20202);

-- 4. Seed Orders (Random orders from customers)
INSERT INTO dbo.Orders (CustomerId, Date, Total, BottleId)
SELECT 
    FLOOR(RAND(CHECKSUM(NEWID())) * 10) + 1,  -- Random CustomerId (1-10)
    DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID())) * 365), GETDATE()),  -- Random past year
    CAST((FLOOR(RAND(CHECKSUM(NEWID())) * 200) + 30) AS DECIMAL(18,2)),  -- Total between $30 - $230
    FLOOR(RAND(CHECKSUM(NEWID())) * 20) + 1   -- Random BottleId (1-20)
FROM master.dbo.spt_values
WHERE type = 'P' AND number <= 100;

-- 5. Seed Tastings (Realistic tasting notes & ratings)
INSERT INTO dbo.Tastings (BottleId, CustomerId, Date, Rating, Notes, Description)
SELECT 
    FLOOR(RAND(CHECKSUM(NEWID())) * 20) + 1,  -- Random BottleId
    FLOOR(RAND(CHECKSUM(NEWID())) * 10) + 1,  -- Random CustomerId
    DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID())) * 365), GETDATE()),  -- Random past year
    FLOOR(RAND(CHECKSUM(NEWID())) * 5) + 6,  -- Rating (6-10)
    CASE 
        WHEN RAND() < 0.2 THEN 'Smoky and peaty'
        WHEN RAND() < 0.4 THEN 'Rich and sherried'
        WHEN RAND() < 0.6 THEN 'Sweet and fruity'
        WHEN RAND() < 0.8 THEN 'Spicy and complex'
        ELSE 'Smooth and well-balanced'
    END, 
    CASE 
        WHEN RAND() < 0.2 THEN 'A bold and smoky dram with notes of sea salt and medicinal peat.'
        WHEN RAND() < 0.4 THEN 'Rich sherry influence, full of dried fruits, dark chocolate, and spice.'
        WHEN RAND() < 0.6 THEN 'Vanilla and honey sweetness, complemented by orchard fruits and gentle oak.'
        WHEN RAND() < 0.8 THEN 'Warming spices, caramelized sugar, and hints of dark cherries.'
        ELSE 'Silky smooth with layers of malt, toffee, and a touch of citrus zest.'
    END
FROM master.dbo.spt_values
WHERE type = 'P' AND number <= 100;

PRINT 'Database successfully seeded with realistic test data!';
