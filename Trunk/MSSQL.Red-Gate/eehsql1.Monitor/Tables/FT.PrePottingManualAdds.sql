CREATE TABLE [FT].[PrePottingManualAdds]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Qty] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[PrePottingManualAdds] ADD CONSTRAINT [PK__PrePottingManual__182F2EF2] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
