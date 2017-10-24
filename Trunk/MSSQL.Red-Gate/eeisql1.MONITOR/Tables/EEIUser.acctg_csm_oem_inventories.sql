CREATE TABLE [EEIUser].[acctg_csm_oem_inventories]
(
[ReleaseID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IHSMnemonic] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IHSNameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoNewsVehicle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InventoryonHand] [decimal] (18, 0) NULL,
[CurrentDaysSupply] [decimal] (18, 0) NULL,
[YrAgoDaysSupply] [decimal] (18, 0) NULL
) ON [PRIMARY]
GO
