USE [FridgyKey_DB] 
GO
select * from [dbo].[tblFrostProduct];
select * from [dbo].[tblHack];
select * from [dbo].[tblKkal];
select * from [dbo].[tblUser];
select * from [dbo].[tblSticker]; 
select * from [dbo].[tblResorces]; 

---------------------------------------------
CREATE TABLE [dbo].[tblFrostProduct](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[FrostID] [int] NULL,
	[Amount] [int] NULL,
	[ValidData] [date] NULL,
	[PriceAmount] [float] NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [dbo].[tblKkal] ([ID])
	)
---------------------------------------------
CREATE TABLE [dbo].[tblKkal](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Kkal] [int] NULL,
	[Advise] [nvarchar](500) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[tblUser] ([UserID])
	)
---------------------------------------------
CREATE TABLE [dbo].[tblResorces](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RecipeID] [int] NULL,
	[ImagePath] [nvarchar](200) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[tblUser] ([UserID])
	)
---------------------------------------------
CREATE TABLE [dbo].[tblSticker](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FrostID] [int] NULL,
	[Username] [nvarchar](50) NULL,
	[Text] [nvarchar](500) NULL,
	[Data] [date] NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[tblUser] ([UserID])
	)
---------------------------------------------
CREATE TABLE [dbo].[tblUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[FrostID] [int] NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[tblUser] ([UserID])
	)
---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------

---------------------------------------------


