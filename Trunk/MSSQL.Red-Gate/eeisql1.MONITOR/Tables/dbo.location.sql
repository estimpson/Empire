CREATE TABLE [dbo].[location]
(
[code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[group_no] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sequence] [numeric] (3, 0) NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[secured_location] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[label_on_transfer] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hazardous] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__location__hazard__7B0D3CA6] DEFAULT ('N'),
[AllowMultiplePallet] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__location__AllowM__672D616A] DEFAULT ('N'),
[Box_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaxSerialLoc] [int] NULL,
[Active] [int] NOT NULL CONSTRAINT [DF_location_Active] DEFAULT ((1)),
[regby] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[regdate] [datetime] NOT NULL CONSTRAINT [DF_location_regdate] DEFAULT (getdate()),
[updateby] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[updatedate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[location] ADD CONSTRAINT [PK__location__27A3E8DD] PRIMARY KEY CLUSTERED  ([code]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_location_2] ON [dbo].[location] ([plant], [code], [secured_location]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[location] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[location] TO [APPUser]
GO
GRANT SELECT ON  [dbo].[location] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[location] TO [APPUser]
GO
