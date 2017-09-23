CREATE TABLE [dbo].[FTRF_Users]
(
[ID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DSN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFGunID] [int] NULL,
[StartModule] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogPass] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IntegratedSecurity] [smallint] NULL,
[PrintServer] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_Users] ADD CONSTRAINT [PK__FTRF_Users__1FEDB87C] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
