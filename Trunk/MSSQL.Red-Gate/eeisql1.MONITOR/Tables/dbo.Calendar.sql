CREATE TABLE [dbo].[Calendar]
(
[dt] [smalldatetime] NOT NULL,
[isWeekday] [bit] NULL,
[isHoliday] [bit] NULL,
[Y] [smallint] NULL,
[FY] [smallint] NULL,
[Q] [tinyint] NULL,
[M] [tinyint] NULL,
[D] [tinyint] NULL,
[DW] [tinyint] NULL,
[monthname] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dayname] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[W] [tinyint] NULL,
[UTCOffset] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Calendar] ADD CONSTRAINT [PK__Calendar__32136E5F14B1079C] PRIMARY KEY CLUSTERED  ([dt]) ON [PRIMARY]
GO
