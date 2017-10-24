CREATE TABLE [dbo].[SSR_LogDefect_Report]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Serial] [int] NULL,
[Type_Defect] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[RegisterDT] [datetime] NOT NULL CONSTRAINT [DF__SSR_LogDe__Regis__6ED34B6B] DEFAULT (getdate()),
[RegisterBy] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Origin] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SSR_LogDefect_Report_Origin] DEFAULT ('EEI')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SSR_LogDefect_Report] ADD CONSTRAINT [PK_SSR_LogDefect_Report] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-Serial-Defect] ON [dbo].[SSR_LogDefect_Report] ([Serial], [Type_Defect]) ON [PRIMARY]
GO
