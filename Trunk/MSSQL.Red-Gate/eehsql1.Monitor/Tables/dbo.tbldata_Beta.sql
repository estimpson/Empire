CREATE TABLE [dbo].[tbldata_Beta]
(
[Inventorycode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Inventorynames] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaterialType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Totalquantities] [decimal] (18, 6) NULL,
[USD] [decimal] (18, 6) NULL,
[Vendor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeeklyReq] [decimal] (18, 6) NULL,
[WeeksNumber] [int] NULL CONSTRAINT [DF__tbldata_B__Weeks__0C35030F] DEFAULT ((0)),
[ActiveWhereUsed] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InactivewhereUsed] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STDPACK] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
