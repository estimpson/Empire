CREATE TABLE [FT].[BasePartCustomerAuthorizations]
(
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuthorizationDT] [datetime] NULL,
[RawMaterialAccum] [numeric] (20, 6) NULL,
[FabricationAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[BasePartCustomerAuthorizations] ADD CONSTRAINT [PK__BasePartCustomer__58E70A0D] PRIMARY KEY CLUSTERED  ([BasePart]) ON [PRIMARY]
GO
