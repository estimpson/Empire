CREATE TABLE [FT].[CustReleasePlanDetailDates]
(
[RPDDID] [int] NOT NULL IDENTITY(1, 1),
[RPDID] [int] NOT NULL,
[DateQualifier] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseDate] [datetime] NOT NULL,
[QuantityQualifier] [tinyint] NOT NULL,
[Quantity] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanDetailDates] ADD CONSTRAINT [PK_CustReleasePlanDetailDates] PRIMARY KEY CLUSTERED  ([RPDDID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanDetailDates] ADD CONSTRAINT [FK_CustReleasePlanDetailDates_CustReleasePlanDetails] FOREIGN KEY ([RPDID]) REFERENCES [FT].[CustReleasePlanDetails] ([RPDID])
GO
