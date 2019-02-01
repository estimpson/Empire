CREATE TABLE [FxPVQ].[Oems]
(
[Oem] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__Oems__Status__61944DAC] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Oems__Type__628871E5] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Oems__RowCreateD__637C961E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Oems__RowCreateU__6470BA57] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Oems__RowModifie__6564DE90] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Oems__RowModifie__665902C9] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FxPVQ].[Oems] ADD CONSTRAINT [PK__Oems__FFEE74515CCF988F] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FxPVQ].[Oems] ADD CONSTRAINT [UQ__Oems__CB3EAEB65FAC053A] UNIQUE NONCLUSTERED  ([Oem]) ON [PRIMARY]
GO
