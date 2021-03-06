CREATE TABLE [EMPIRE\lmelgar].[Slatable]
(
[dserial] [int] NOT NULL,
[szPlantCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCustomerpart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szcustomerPO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dQuantity] [numeric] (20, 6) NULL,
[szLot] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szSupplier] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szPartName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCrossRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szeng] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szMfgDate] [varchar] (54) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szShipDate] [varchar] (54) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szALCDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCentocoDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szFNGDate] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szMitsuMfgDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dtdatetime] [datetime] NOT NULL,
[szPCoName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szPAdd1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szPAdd2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szPAdd3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szdestination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szDName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szDAdd1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szDAdd2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szDAdd3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szLineFeed] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline11] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline12] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline13] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline14] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline15] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline16] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szline17] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szZonecode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szshipper] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lParentSerial] [numeric] (10, 0) NOT NULL,
[szKanban] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szDock] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCustomer] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCAdd1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCAdd2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szCAdd3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szLicensePlate] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szMasterLicensePlate] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dweight] [numeric] (20, 6) NULL,
[dtweight] [numeric] (20, 6) NULL,
[FedMogulCrossRef] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szTAKDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szTAKdayofyear] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szTAKYear] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szTAKShift] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szTRWJulianDate] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[iPQAIndicator] [int] NOT NULL,
[szFirst] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[szSecond] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destinationcode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SLAInfoRecord] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SLALotNo] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Boxes] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
