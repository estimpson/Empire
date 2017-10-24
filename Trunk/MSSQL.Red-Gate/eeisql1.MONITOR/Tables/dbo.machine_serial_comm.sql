CREATE TABLE [dbo].[machine_serial_comm]
(
[machine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[serial_port] [smallint] NOT NULL,
[serial_prompt] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[serial_interface] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[winwedge_location] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[wwconfig_location] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount_field] [smallint] NULL,
[steady_field] [smallint] NULL,
[steady_char] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[machine_serial_comm] ADD CONSTRAINT [PK__machine_serial_c__75235608] PRIMARY KEY CLUSTERED  ([machine]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[machine_serial_comm] ADD CONSTRAINT [FK__machine_s__machi__6265874F] FOREIGN KEY ([machine]) REFERENCES [dbo].[machine] ([machine_no])
GO
ALTER TABLE [dbo].[machine_serial_comm] ADD CONSTRAINT [FK__machine_s__machi__61716316] FOREIGN KEY ([machine]) REFERENCES [dbo].[machine] ([machine_no])
GO
