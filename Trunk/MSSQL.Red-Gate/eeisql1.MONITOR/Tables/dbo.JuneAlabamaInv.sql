CREATE TABLE [dbo].[JuneAlabamaInv]
(
[DateStamp] [datetime] NULL,
[InPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ins] [numeric] (20, 6) NOT NULL,
[ExtendedMaterialIn] [numeric] (38, 9) NULL,
[Parent_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity] [numeric] (20, 6) NULL,
[StandardOuts] [numeric] (38, 7) NOT NULL,
[StandardExtendedOuts] [numeric] (38, 6) NULL,
[ActualOuts] [numeric] (38, 6) NULL,
[ActualOutsExtended] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
