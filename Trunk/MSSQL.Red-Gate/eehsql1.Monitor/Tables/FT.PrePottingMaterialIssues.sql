CREATE TABLE [FT].[PrePottingMaterialIssues]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Qty] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[PrePottingMaterialIssues] ADD CONSTRAINT [PK__PrePottingManual__1646E680] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
