CREATE TABLE [HN].[JobCompleteProcesos]
(
[Circuito] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Cantidad] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Circuito] ON [HN].[JobCompleteProcesos] ([Circuito]) ON [PRIMARY]
GO
