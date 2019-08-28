CREATE TABLE [dbo].[NALPrices]
(
[bill_customer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ar_document] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[correct_price] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
