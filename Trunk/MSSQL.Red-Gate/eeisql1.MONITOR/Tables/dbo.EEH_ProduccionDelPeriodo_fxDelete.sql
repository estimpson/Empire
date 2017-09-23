CREATE TABLE [dbo].[EEH_ProduccionDelPeriodo_fxDelete]
(
[Part] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [int] NULL,
[remarks] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_stamp] [datetime] NULL,
[id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
