CREATE TABLE [FT].[ReturnPreToLines]
(
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnToLine] [numeric] (20, 6) NULL,
[Machine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Component] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ComponentQty] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
