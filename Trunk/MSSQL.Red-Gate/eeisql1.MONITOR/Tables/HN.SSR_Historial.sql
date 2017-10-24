CREATE TABLE [HN].[SSR_Historial]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[SSR_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyPart] [int] NULL,
[Star_Date] [datetime] NULL,
[Completion_Date] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quality_found] [int] NULL,
[Close_Condition] [int] NULL,
[Identification_Leyend] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Image_OK] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Image_NoOk] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Withness] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NULL,
[Comments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Users] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date_Required] [datetime] NULL,
[Image_Identification_Box] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other_File] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spec_Empaque] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistributionPlant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Defect] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PieceRate] [numeric] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[SSR_Historial] ADD CONSTRAINT [PK_SSR_Historial] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SSR_Historial_Part] ON [HN].[SSR_Historial] ([Part]) INCLUDE ([PieceRate]) ON [PRIMARY]
GO
GRANT SELECT ON  [HN].[SSR_Historial] TO [APPUser]
GO
GRANT INSERT ON  [HN].[SSR_Historial] TO [APPUser]
GO
GRANT DELETE ON  [HN].[SSR_Historial] TO [APPUser]
GO
GRANT UPDATE ON  [HN].[SSR_Historial] TO [APPUser]
GO
