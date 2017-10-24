CREATE TABLE [dbo].[vdp_table]
(
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[week] [int] NOT NULL,
[po_number] [int] NOT NULL,
[cum_oqty] [numeric] (20, 6) NULL,
[cum_rqty] [numeric] (20, 6) NULL,
[date_evaluated] [datetime] NOT NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
