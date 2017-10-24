CREATE TABLE [dbo].[FTRF_Messages]
(
[MessageStamp] [datetime] NOT NULL,
[UserName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MessageText] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_Messages] ADD CONSTRAINT [PK__FTRF_Messages__4A18FC72] PRIMARY KEY CLUSTERED  ([MessageStamp], [UserName], [MessageText]) ON [PRIMARY]
GO
