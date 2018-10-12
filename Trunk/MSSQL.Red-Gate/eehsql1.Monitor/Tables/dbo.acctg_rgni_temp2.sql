CREATE TABLE [dbo].[acctg_rgni_temp2]
(
[changed_date] [datetime] NULL,
[po_no] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendor_code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bill_of_lading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inv_line] [int] NULL,
[receiver] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity_received] [decimal] (18, 6) NULL,
[unit_cost] [decimal] (18, 6) NULL,
[total_cost] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
