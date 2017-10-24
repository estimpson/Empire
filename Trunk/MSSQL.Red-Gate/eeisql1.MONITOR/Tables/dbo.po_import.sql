CREATE TABLE [dbo].[po_import]
(
[po_number] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[date_due] [smalldatetime] NOT NULL,
[week] [int] NOT NULL,
[row_id] [int] NOT NULL,
[quantity] [numeric] (20, 6) NULL,
[received] [numeric] (20, 6) NULL,
[balance] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
