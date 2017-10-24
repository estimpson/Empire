CREATE TABLE [dbo].[TemporalDataDashboardSSR]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Serial] [int] NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectBirthday] [datetime] NULL,
[Location] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[Status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lote] [int] NULL,
[Note] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSR_Number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Defect] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour_Time] [decimal] (18, 4) NULL,
[Hour_Needed] [decimal] (18, 4) NULL,
[Opera] [decimal] (18, 4) NULL,
[StausSSR] [int] NULL,
[NoSSR] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fifo] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
