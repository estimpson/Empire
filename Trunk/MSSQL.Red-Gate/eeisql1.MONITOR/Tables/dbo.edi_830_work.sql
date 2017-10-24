CREATE TABLE [dbo].[edi_830_work]
(
[po_number] [int] NOT NULL,
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[vendor_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[engineering_level] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit_of_measure] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [varchar] (78) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dock_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cum_expected] [numeric] (20, 6) NULL,
[cum_received] [numeric] (20, 6) NULL,
[firm_end_date] [datetime] NULL,
[horizon_end_date] [datetime] NULL,
[raw_auth_end_date] [datetime] NULL,
[last_rcv_id] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_rcv_date] [datetime] NULL,
[last_rcv_qty] [numeric] (20, 6) NULL,
[fab_auth_qty] [numeric] (20, 6) NULL,
[raw_auth_qty] [numeric] (20, 6) NULL,
[buyer_name] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[buyer_phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[buyer_email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler_name] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler_phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler_email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_830_work] ADD CONSTRAINT [PK__edi_830_work__44801EAD] PRIMARY KEY CLUSTERED  ([po_number], [part]) ON [PRIMARY]
GO
