CREATE TABLE [dbo].[MATOrderAuth]
(
[ReleasePlanID] [int] NOT NULL,
[OrderNumber] [int] NOT NULL,
[WeekRecorded] [smallint] NOT NULL,
[AuthWeek] [smallint] NOT NULL,
[PostAccum] [decimal] (20, 6) NOT NULL,
[EEIEntry] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MATWeeks] [smallint] NOT NULL,
[atLeadTime] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
