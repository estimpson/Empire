CREATE TABLE [dbo].[csmProgramEEIPart]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CSMProgram] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PartsPerProgram] [numeric] (20, 6) NULL,
[TakeRate] [numeric] (20, 6) NULL,
[Allocation] [numeric] (20, 6) NULL,
[csmnemonic] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[csmprogramnemonic] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[badge] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[platform] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[application] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csmProgramEEIPart] ADD CONSTRAINT [PK__csmProgramEEIPar__3B2BBE9D] PRIMARY KEY CLUSTERED  ([Part], [CSMProgram], [csmnemonic], [csmprogramnemonic]) ON [PRIMARY]
GO
