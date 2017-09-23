CREATE TABLE [dbo].[part_eecustom_njb_setups]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LabelCrossRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustDrawingNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndUser] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[platform] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[application] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineStatus] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
