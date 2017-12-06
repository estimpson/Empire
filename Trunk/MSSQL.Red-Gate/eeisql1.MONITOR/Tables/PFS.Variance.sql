CREATE TABLE [PFS].[Variance]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Load] [int] NULL,
[Pickup] [datetime] NULL,
[Shipper] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Consignee] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsigneeCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pieces] [int] NULL,
[Weight] [int] NULL,
[Class] [decimal] (20, 6) NULL,
[Carrier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Billed] [decimal] (20, 6) NULL,
[CostPerPound] [decimal] (20, 6) NULL,
[InvDate] [datetime] NULL,
[PoRef] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProNumber] [bigint] NULL,
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowCreateDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [PFS].[Variance] ADD CONSTRAINT [PK_Variance_2] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
