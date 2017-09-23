CREATE TABLE [dbo].[ft_at_receiptCompare]
(
[ponumber] [int] NOT NULL,
[ftpart] [varchar] (125) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[atpart] [varchar] (125) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ftqty] [numeric] (20, 6) NULL,
[atqty] [numeric] (20, 6) NULL,
[lastupdate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
