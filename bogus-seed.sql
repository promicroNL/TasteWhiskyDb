SET NOCOUNT ON;
W 1 = 1
BEGIN
   -- Seed Distilleries
   PRINT N'Seeding Distilleries';
   INSERT INTO dbo.Distilleries
   (
      Name
   )
   SELECT
         'Distillery '
         + CAST(ROW_NUMBER() OVER (ORDER BY (
                                               SELECT NULL
                                            )
                                  ) AS NVARCHAR(10))
   FROM  master.dbo.spt_values
   WHERE type = 'P'
         AND number <= 100;

   -- Seed Customers
   PRINT N'Seeding Customers';
   INSERT INTO dbo.Customers
   (
      FirstName,
      LastName,
      DateOfBirth,
      Address
   )
   SELECT
         'FirstName'
         + CAST(ROW_NUMBER() OVER (ORDER BY (
                                               SELECT NULL
                                            )
                                  ) AS NVARCHAR(10)),
         'LastName'
         + CAST(ROW_NUMBER() OVER (ORDER BY (
                                               SELECT NULL
                                            )
                                  ) AS NVARCHAR(10)),
         DATEADD(YEAR, -20 - (ABS(CHECKSUM(NEWID())) % 40), GETDATE()),
         'Address '
         + CAST(ROW_NUMBER() OVER (ORDER BY (
                                               SELECT NULL
                                            )
                                  ) AS NVARCHAR(10))
   FROM  master.dbo.spt_values
   WHERE type = 'P'
         AND number <= 100;

   -- Seed Bottles
   PRINT N'Seeding Bottles';
   INSERT INTO dbo.Bottles
   (
      Name,
      DistilleryId,
      Age,
      AlcoholByVolume,
      WhiskyBaseId
   )
   SELECT
         'Bottle '
         + CAST(ROW_NUMBER() OVER (ORDER BY (
                                               SELECT NULL
                                            )
                                  ) AS NVARCHAR(10)),
         (ABS(CHECKSUM(NEWID())) % 100) + 1,
         (ABS(CHECKSUM(NEWID())) % 30) + 1,
         (40 + (ABS(CHECKSUM(NEWID())) % 20) * 0.1),
         NULLIF(ABS(CHECKSUM(NEWID())) % 200, 0)
   FROM  master.dbo.spt_values
   WHERE type = 'P'
         AND number <= 100;

   -- Seed Orders
   PRINT N'Seeding Orders';
   INSERT INTO dbo.Orders
   (
      CustomerId,
      Date,
      Total,
      BottleId
   )
   SELECT (ABS(CHECKSUM(NEWID())) % 100) + 1,
          DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 365), GETDATE()),
          CAST((ABS(CHECKSUM(NEWID())) % 200) + 10 AS DECIMAL(18, 2)),
          (ABS(CHECKSUM(NEWID())) % 100) + 1
   FROM   master.dbo.spt_values
   WHERE  type = 'P'
          AND number <= 100;

   -- Seed Tastings
   PRINT N'Seeding Tastings';
   INSERT INTO dbo.Tastings
   (
      BottleId,
      CustomerId,
      Date,
      Rating,
      Notes,
      Description
   )
   SELECT (ABS(CHECKSUM(NEWID())) % 100) + 1,
          (ABS(CHECKSUM(NEWID())) % 100) + 1,
          DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 365), GETDATE()),
          (ABS(CHECKSUM(NEWID())) % 10) + 1,
          'Notes '
          + CAST(ROW_NUMBER() OVER (ORDER BY (
                                                SELECT NULL
                                             )
                                   ) AS NVARCHAR(10)),
          'Description '
          + CAST(ROW_NUMBER() OVER (ORDER BY (
                                                SELECT NULL
                                             )
                                   ) AS NVARCHAR(10))
   FROM   master.dbo.spt_values
   WHERE  type = 'P'
          AND number <= 100;

   PRINT N'Seed Data Inserted Successfully';
END;