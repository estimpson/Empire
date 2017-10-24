CREATE TABLE [FT].[EndingOrders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProgramID] [int] NOT NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EndingQty] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[EndingOrders] ADD CONSTRAINT [PK__EndingOrders__019E3B86] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
