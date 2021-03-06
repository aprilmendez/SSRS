USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spClaims]    Script Date: 05/09/2013 14:30:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter proc [dbo].[spClaims] 

 @BeginDate varchar(10) = '2011-10-01',
 @EndDate varchar(10) = '2011-10-31'

as

declare @sql as varchar(2500)

set @sql = '

select * from openquery(gsfl2k,''

SELECT SHLINE.SLINV# AS InvoiceNbr,
 SHLINE.SLDATE AS InvoiceDate,
 SHHEAD.SHIDAT,
 SHHEAD.SHODAT AS OrderDate,
 SHHEAD.SHOTYP,
 SHHEAD.SHVIAC,
 SHHEAD.SHCM,
 SHHEAD.SHPO#,
 SHLINE.SLCO AS Company,
 SHLINE.SLLOC AS Loc,
 SHLINE.SLORD# AS OrderNbr,
 SHLINE.SLSEQ#,
 SHHEAD.SHBIL# AS BillToCustNum,
 BillTo.CMNAME AS BillToName,
 BillTo.CMCO AS BillToCo,
 BillTo.CMLOC AS BillToLoc,
 Left(BillTo.CMADR3,23) AS BillToCity,
 Right(BillTo.CMADR3,2) AS BillToState,
 SHLINE.SLCUST AS ShipToCustNum,
 CUSTMAST.CMNAME AS ShipToCustName,
 CUSTMAST.CMADR3 AS ShipCustCitySt,
 SHLINE.SLBYP,
 SHLINE.SLITEM,
 SHLINE.SLSRL1,
 SHLINE.SLILOC,
 SHLINE.SLDESC,
 SHLINE.SLVEND AS VendNum,
 VENDMAST.VMNAME AS VandName,
 SHLINE.SLFCRG,
 SHLINE.SLPRCD,
 SHLINE.SLFMCD,
 SHLINE.SLCLS#,
 ITEMMAST.IMCLS#,
 SHLINE.SLDIV,
 SHLINE.SLQORD AS OrdQtyInvUM,
 SHLINE.SLQSHP AS ShipQtyInvUM,
 SHLINE.SLCUT,
 SHLINE.SLBLUS AS ShipQtyPriceUM,
 SHLINE.SLUM2 AS PriceUM,
 SHLINE.SLPRIC AS UnitPrice,
 SHLINE.SLPOR AS PriceOverride,
 SHLINE.SLPCRS,
 SHLINE.SLCOST AS UnitCost,
 SHLINE.SLEPRC AS ExtendedPrice,
 SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 AS ExtendedCost,
 SHLINE.SLESC1,
 SHLINE.SLESC2,
 SHLINE.SLESC3,
 SHLINE.SLESC4,
 SHLINE.SLSCS4,
 SHLINE.SLESC5,
 slesc1+slesc2+slesc3+slesc4+slesc5 AS NetCost,
 SHLINE.SLSA,
 SHHEAD.SHSLSM as SalesPersonNum,
 salesman.smname as SalesPerson,
 ITEMMAST.IMUMD4,
 SHLINE.SLPROMO#,
 SHHEAD.SHUSER,
 SHLINE.SLCOMC
 
FROM SHLINE 
left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
					AND SHLINE.SLLOC = SHHEAD.SHLOC 
					AND SHLINE.SLORD# = SHHEAD.SHORD# 
					AND SHLINE.SLREL# = SHHEAD.SHREL# 
					AND SHLINE.SLINV# = SHHEAD.SHINV#)
LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
left JOIN CUSTMAST ON SHLINE.SLCUST = CUSTMAST.CMCUST 
left JOIN CUSTMAST BillTo ON SHHEAD.SHBIL# = BillTo.CMCUST 
left JOIN VENDMAST ON SHLINE.SLVEND = VENDMAST.VMVEND
left join salesman on SHHEAD.SHSLSM = salesman.smno

WHERE SHHEAD.SHIDAT >= ' + '''' + '''' + @BeginDate + '''' + '''' +
' And SHHEAD.SHIDAT <= ' + '''' + '''' + @EndDate + '''' + '''' +
' AND SHHEAD.SHOTYP in (''''CL'''',''''FC'''')
and SHLINE.SLCLS# not in (13056, 13059, 13058, 13035, 13037)

ORDER BY SHLINE.SLINV#,
 SHHEAD.SHIDAT,
 SHLINE.SLCO,
 SHLINE.SLSEQ#,
 SHLINE.SLITEM
 
 '')
'

--select @sql

exec(@sql)

GO


