CREATE TABLE [dbo].[PartConvertion]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InitUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinalUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConvertionFactor] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
