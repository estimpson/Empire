CREATE TABLE [dbo].[CycleCountHeaders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDT] [datetime] NOT NULL,
[EndDT] [datetime] NOT NULL,
[BoxesStarting] [int] NOT NULL,
[BoxesFoundInPos] [int] NULL,
[BoxesFoundInRow] [int] NULL,
[BoxesMissing] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CycleCountHeaders] ADD CONSTRAINT [PK__CycleCou__3214EC2750142AC0] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CycleCountHeaders] ADD CONSTRAINT [UQ__CycleCou__EE93E39752F0976B] UNIQUE NONCLUSTERED  ([Location], [StartDT]) ON [PRIMARY]
GO
