CREATE TABLE [dbo].[WODSourceRequiremens]
(
[WODID] [int] NOT NULL,
[OrderNo] [int] NULL,
[BillTo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipTo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WODSourceRequiremens] ADD CONSTRAINT [PK__WODSourceRequire__277604C2] PRIMARY KEY CLUSTERED  ([WODID]) ON [PRIMARY]
GO
