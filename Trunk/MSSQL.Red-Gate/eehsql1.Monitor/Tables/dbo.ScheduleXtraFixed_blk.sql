CREATE TABLE [dbo].[ScheduleXtraFixed_blk]
(
[ScheId] [int] NOT NULL,
[ScheFixProcessNumberDay] [int] NOT NULL,
[ScheFixSegment] [int] NOT NULL,
[ScXtraFixSubSegment] [int] NOT NULL,
[ScXtraFixNumberDayIn] [int] NULL,
[ScXtraFixHourIn] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScXtraFixMinuteIn] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScXtraFixFormatIn] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScXtraFixTotalMinuteIn] [int] NULL,
[ScXtraFixNumberDayOut] [int] NULL,
[ScXtraFixHourOut] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScXtraFixMinuteOut] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScXtraFixFormatOut] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScXtraFixTotalMinuteOut] [int] NULL,
[ScXtraFixTimeClassType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScXtraFixAutomaticAproved] [int] NULL
) ON [PRIMARY]
GO
