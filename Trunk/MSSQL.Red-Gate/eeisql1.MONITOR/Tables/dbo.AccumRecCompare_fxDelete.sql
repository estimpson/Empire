CREATE TABLE [dbo].[AccumRecCompare_fxDelete]
(
[po] [numeric] (20, 0) NOT NULL,
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cum1] [numeric] (20, 6) NULL,
[cym2] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccumRecCompare_fxDelete] ADD CONSTRAINT [POcompareKey] PRIMARY KEY CLUSTERED  ([po], [part]) ON [PRIMARY]
GO
