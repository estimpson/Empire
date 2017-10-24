CREATE TABLE [FT].[BasePartCustomerHighAuthorizations]
(
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HighRawMaterialAccum] [numeric] (20, 6) NULL,
[HighRawMaterialAccumDT] [datetime] NULL,
[HighFabricationAccum] [numeric] (20, 6) NULL,
[HighFabricationAccumDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[BasePartCustomerHighAuthorizations] ADD CONSTRAINT [PK__BasePartCustomer__56FEC19B] PRIMARY KEY CLUSTERED  ([BasePart]) ON [PRIMARY]
GO
