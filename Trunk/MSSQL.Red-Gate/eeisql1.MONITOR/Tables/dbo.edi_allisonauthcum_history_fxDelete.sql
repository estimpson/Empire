CREATE TABLE [dbo].[edi_allisonauthcum_history_fxDelete]
(
[release_no] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sched_date] [datetime] NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_po] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cum_type] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cum_date] [datetime] NULL,
[cum_qty] [decimal] (20, 6) NULL,
[start_date] [datetime] NULL
) ON [PRIMARY]
GO
