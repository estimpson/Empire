CREATE TABLE [FT].[EndofProgramRawParts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProgramID] [int] NOT NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[EndofProgramRawParts] ADD CONSTRAINT [PK__EndofProgramRawP__14B10FFA] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
