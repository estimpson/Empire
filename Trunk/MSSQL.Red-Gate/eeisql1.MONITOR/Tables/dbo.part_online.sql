CREATE TABLE [dbo].[part_online]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[on_hand] [numeric] (20, 6) NULL,
[on_demand] [numeric] (20, 6) NULL,
[on_schedule] [numeric] (20, 6) NULL,
[bom_net_out] [numeric] (20, 6) NULL,
[min_onhand] [numeric] (20, 6) NULL,
[max_onhand] [numeric] (20, 6) NULL,
[default_vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[default_po_number] [int] NULL,
[kanban_po_requisition] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kanban_required] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auto_releases] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weeks_to_freeze] [smallint] NULL,
[prod_start] [datetime] NULL,
[prod_end] [datetime] NULL,
[generate_mr] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship_note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship_operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_online] ADD CONSTRAINT [PK__part_online__4257DF19] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[part_online] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[part_online] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[part_online] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[part_online] TO [APPUser]
GO
