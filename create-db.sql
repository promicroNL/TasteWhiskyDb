CREATE DATABASE [TasteWhisky]
GO
USE [TasteWhisky]
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating [dbo].[Distilleries]'
GO
CREATE TABLE [dbo].[Distilleries]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (100) NOT NULL
)
GO
PRINT N'Creating primary key [PK_Distilleries] on [dbo].[Distilleries]'
GO
ALTER TABLE [dbo].[Distilleries] ADD CONSTRAINT [PK_Distilleries] PRIMARY KEY CLUSTERED ([Id])
GO
PRINT N'Creating [dbo].[Bottles]'
GO
CREATE TABLE [dbo].[Bottles]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (100) NOT NULL,
[DistilleryId] [int] NOT NULL,
[Age] [int] NOT NULL,
[AlcoholByVolume] [real] NOT NULL,
[WhiskyBaseId] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Bottles] on [dbo].[Bottles]'
GO
ALTER TABLE [dbo].[Bottles] ADD CONSTRAINT [PK_Bottles] PRIMARY KEY CLUSTERED ([Id])
GO
PRINT N'Creating index [IX_Bottles_DistilleryId] on [dbo].[Bottles]'
GO
CREATE NONCLUSTERED INDEX [IX_Bottles_DistilleryId] ON [dbo].[Bottles] ([DistilleryId])
GO
PRINT N'Creating [dbo].[Orders]'
GO
CREATE TABLE [dbo].[Orders]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CustomerId] [int] NOT NULL,
[Date] [datetime] NOT NULL,
[Total] [decimal] (18, 2) NOT NULL,
[BottleId] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Orders] on [dbo].[Orders]'
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([Id])
GO
PRINT N'Creating index [IX_Orders_BottleId] on [dbo].[Orders]'
GO
CREATE NONCLUSTERED INDEX [IX_Orders_BottleId] ON [dbo].[Orders] ([BottleId])
GO
PRINT N'Creating index [IX_Orders_CustomerId] on [dbo].[Orders]'
GO
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerId] ON [dbo].[Orders] ([CustomerId])
GO
PRINT N'Creating [dbo].[Customers]'
GO
CREATE TABLE [dbo].[Customers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[FirstName] [nvarchar] (100) NOT NULL,
[LastName] [nvarchar] (100) NOT NULL,
[DateOfBirth] [datetime] NOT NULL,
[Address] [nvarchar] (100) NULL
)
GO
PRINT N'Creating primary key [PK_Customers] on [dbo].[Customers]'
GO
ALTER TABLE [dbo].[Customers] ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([Id])
GO
PRINT N'Creating [dbo].[Tastings]'
GO
CREATE TABLE [dbo].[Tastings]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[BottleId] [int] NOT NULL,
[CustomerId] [int] NOT NULL,
[Date] [datetime] NOT NULL,
[Rating] [int] NOT NULL,
[Notes] [nvarchar] (100) NOT NULL,
[Description] [varchar] (500) NULL
)
GO
PRINT N'Creating primary key [PK_Tastings] on [dbo].[Tastings]'
GO
ALTER TABLE [dbo].[Tastings] ADD CONSTRAINT [PK_Tastings] PRIMARY KEY CLUSTERED ([Id])
GO
PRINT N'Creating index [IX_Tastings_BottleId] on [dbo].[Tastings]'
GO
CREATE NONCLUSTERED INDEX [IX_Tastings_BottleId] ON [dbo].[Tastings] ([BottleId])
GO
PRINT N'Creating index [IX_Tastings_CustomerId] on [dbo].[Tastings]'
GO
CREATE NONCLUSTERED INDEX [IX_Tastings_CustomerId] ON [dbo].[Tastings] ([CustomerId])
GO
PRINT N'Creating [dbo].[vw_TastingDetails]'
GO
CREATE VIEW [dbo].[vw_TastingDetails]
AS (
   SELECT
        t.Id AS TastingId,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        t.Date AS DateTasted,
        d.Name AS DistilleryName,
        b.Name AS BottleName,
        b.Age AS BottleAge,
        t.Notes AS TastingNotes,
        t.Rating AS BottleRating
   FROM dbo.Tastings t
        JOIN dbo.Customers c ON c.Id = t.CustomerId
        JOIN dbo.Bottles b ON b.Id = t.BottleId
        JOIN dbo.Distilleries d ON d.Id = b.DistilleryId);
GO
PRINT N'Creating [dbo].[InsertNewBottle]'
GO

CREATE PROCEDURE [dbo].[InsertNewBottle]
   @BottleName NVARCHAR(100),
   @Age INT,
   @AlcoholByVolume REAL,
   @DistilleryName NVARCHAR(100)
AS
BEGIN
   DECLARE @DistilleryId INT;

   /* Determine DistilleryId by it's name*/
   SELECT @DistilleryId = d.Id
   FROM   dbo.Distilleries AS d
   WHERE  LOWER(d.Name) = LOWER(@DistilleryName);

   IF @DistilleryId IS NULL
   BEGIN
      INSERT dbo.Distilleries
      (
         Name
      )
      VALUES
      (
         @DistilleryName
      );

      SET @DistilleryId = SCOPE_IDENTITY();
   END;

   /* Insert the new bottle */
   INSERT dbo.Bottles
   (
      Name,
      DistilleryId,
      Age,
      AlcoholByVolume
   )
   VALUES
   (
      @BottleName,
      @DistilleryId,
      @Age,
      @AlcoholByVolume
   );

END;
GO
PRINT N'Adding foreign keys to [dbo].[Orders]'
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Bottles_BottleId] FOREIGN KEY ([BottleId]) REFERENCES [dbo].[Bottles] ([Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customers] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[Tastings]'
GO
ALTER TABLE [dbo].[Tastings] ADD CONSTRAINT [FK_Tastings_Bottles_BottleId] FOREIGN KEY ([BottleId]) REFERENCES [dbo].[Bottles] ([Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tastings] ADD CONSTRAINT [FK_Tastings_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customers] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[Bottles]'
GO
ALTER TABLE [dbo].[Bottles] ADD CONSTRAINT [FK_Bottles_Distilleries_DistilleryId] FOREIGN KEY ([DistilleryId]) REFERENCES [dbo].[Distilleries] ([Id]) ON DELETE CASCADE
GO

