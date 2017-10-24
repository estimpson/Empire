CREATE TABLE [dbo].[EEH_part_vendor_matrix_fxDelete]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [numeric] (20, 6) NOT NULL,
[LowBound] [numeric] (20, 6) NOT NULL,
[HightBound] [int] NOT NULL
) ON [PRIMARY]
GO
