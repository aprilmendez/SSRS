USE [GartmanReport]
GO
/****** Object:  StoredProcedure [dbo].[ArmstrongPriceOverride]    Script Date: 03/04/2013 10:17:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








ALTER proc [dbo].[ArmstrongPriceOverride] as 


/* ===================================================

	Purpose:  Armstrong Product Price overrides - open orders
	
	Created By:  George
	Date Created:  6/14/2011
	
	Last Update Date: 06/16/2011
	Last Updated By: Thomas Van Nuys
	
	Change Log:
	
	06/16/2011 - added criteria to only get the previous days orders
	11/26/2012 - comment out declaration of @DayofWeek and @QueryDate, case statement and related where criteria -George 
	12/04/2012 - add criteria to exclude lines that Kim Earle has already modified. Also, change passthrough SQL to exclude machine serial nbr.
			Saved original version in MyProjects folder.
	12/10/2012 - changed join to oochange to exclude the sequence number(comment out)
	03/04/2013 - changed where clause to exclude order type "SO" per Kim Earle request --GR
=====================================================*/
/*

declare @DayofWeek int
declare @QueryDate date

set @DayofWeek = (select datepart(dw,getdate()))

select @QueryDate = 
	Case @DayofWeek
		when 2  then dateadd(day,-3,getdate())
		else dateadd(day,-1,getdate())
	end
*/		

select * from openquery(GSFL2K,'

select OLCO AS Company, 
OLLOC AS Location, 
OLORD# AS OrderNum, 
OLREL# AS Release, 
OHODAT AS OrderDate, 
OHOTYP AS OrderType, 
OLCUST AS CustNbr, 
CMNAME AS CustName, 
OLITEM AS ItemNum, 
OLDESC AS ItemDesc, 
OLQORD AS OrdQty, 
OLQSHP AS ShipQty, 
OLQBO AS BackorderQty, 
OLPRIC AS UnitPrice,  

case 
	when olpric = 0 then 0
	else (OLPRIC-(OLCOST-OLSCS4))/OLPRIC 
end as GMPerc,

OLPOR AS PriceOverride, 
OLPCRS AS PriceChangeReason, 
OLCOST AS UnitCost, 
OLSCS4 AS UnitFileback, 
OLC4OR AS FilebackOverride, 
OLQT# AS QuoteNbr, 
OLVEND as VendNum, 
OLPROMO# as ProcedureNum,
IMP1 AS ItemMastP1, 
IMLD1 AS ItemMastP1Rbt, 
IMP2 AS ItemMastP2, 
IMLD2 AS ItemMastP2Rbt, 
IMP3 AS ItemMastP3, 
IMLD3 AS ItemMastP3Rbt, 
IMP4 AS ItemMastP4, 
IMLD4 AS ItemMastP4Rbt, 
IMP5 AS ItemMastP5, 
IMLD5 AS ItemMastP5Rbt, 
OLPRCD as ProdCode

from OOLINE LINE
INNER JOIN OOHEAD HEAD ON (OLCO = OHCO 
	AND OLLOC = OHLOC
	AND OLORD# = OHORD#
	AND OLREL# = OHREL#)
INNER JOIN CUSTMAST ON OLCUST = CMCUST
INNER JOIN ITEMMAST ON OLITEM = IMITEM 
INNER JOIN ITEMXTRA ON OLITEM = IMXITM

WHERE OHOTYP not in (''DP'',''RA'',''SO'')
AND OLVEND in (16037,22312)
AND IMFCRG <> ''S''
and OLPOR = ''Y''
and not exists (select * from oochange
	where line.olco = ogco
			AND line.OLLOC = OGLOC
			AND line.OLORD# = OGORD#
			AND line.OLREL# = OGREL#
		/*	and line.OLSEQ# = OGSEQ# */
			and oguser = ''KIME'')	

/* and OLODAT=@DayofWeek */

order by CustName
')




