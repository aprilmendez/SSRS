

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UnconfirmedETAReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

ALTER proc [dbo].[UnconfirmedETAReport] as

SELECT PLBUYR, 
PHCO AS Co, 
PHLOC AS Loc, 
PHDOI AS [Date PO Created], 
PHPO# AS [PO#], 
VMVEND, 
VMNAME AS [Vendor Name], 
PLITEM AS SKU, 
IMDESC AS [Description], 
IMCOLR AS Color, 
PLDDAT AS [Ship Date], 
PLDELT, 
PHOTYP, 
IMCLAS

from openquery(GSFL2K,''

SELECT gsfl2k.POLINE.PLBUYR, 
gsfl2k.POHEAD.PHCO, 
gsfl2k.POHEAD.PHLOC, 
gsfl2k.POHEAD.PHDOI, 
gsfl2k.POHEAD.PHPO#, 
gsfl2k.VENDMAST.VMVEND, 
gsfl2k.VENDMAST.VMNAME, 
gsfl2k.POLINE.PLITEM, 
gsfl2k.ITEMMAST.IMDESC, 
gsfl2k.ITEMMAST.IMCOLR, 
gsfl2k.POLINE.PLDDAT, 
gsfl2k.POLINE.PLDELT, 
gsfl2k.POHEAD.PHOTYP, 
gsfl2k.ITEMMAST.IMCLAS

FROM  gsfl2k.POLINE
	INNER JOIN gsfl2k.VENDMAST ON gsfl2k.VENDMAST.VMVEND = gsfl2k.POLINE.PLVEND 
	INNER JOIN gsfl2k.POHEAD ON (gsfl2k.POHEAD.PHPO# = gsfl2k.POLINE.PLPO# 
				AND gsfl2k.POHEAD.PHREL# = gsfl2k.POLINE.PLREL#
				AND gsfl2k.POHEAD.PHLOC = gsfl2k.POLINE.PLLOC
				AND gsfl2k.POHEAD.PHCO = gsfl2k.POLINE.PLCO)
	INNER JOIN gsfl2k.ITEMMAST ON gsfl2k.POLINE.PLITEM = gsfl2k.ITEMMAST.IMITEM

GROUP BY gsfl2k.POLINE.PLBUYR, 
gsfl2k.POHEAD.PHCO, 
gsfl2k.POHEAD.PHLOC, 
gsfl2k.POHEAD.PHDOI, 
gsfl2k.POHEAD.PHPO#, 
gsfl2k.VENDMAST.VMVEND, 
gsfl2k.VENDMAST.VMNAME, 
gsfl2k.POLINE.PLITEM, 
gsfl2k.ITEMMAST.IMDESC, 
gsfl2k.ITEMMAST.IMCOLR, 
gsfl2k.POLINE.PLDDAT, 
gsfl2k.POLINE.PLDELT, 
gsfl2k.POHEAD.PHOTYP, 
gsfl2k.ITEMMAST.IMCLAS

having gsfl2k.POHEAD.PHDOI < current_Date - 4 days 
and gsfl2k.POLINE.PLDDAT < ''''10/10/2001''''
AND gsfl2k.POLINE.PLDELT = ''''A'''' 
AND gsfl2k.POHEAD.PHOTYP NOT IN (''''CL'''',''''RA'''',''''FC'''')
/*---- And gsfl2k.POHEAD.PHOTYP != ''''RA''''   ------*/
AND gsfl2k.ITEMMAST.IMCLAS != ''''SA''''

ORDER BY gsfl2k.POLINE.PLBUYR, 
gsfl2k.POHEAD.PHCO

'')

ORDER BY PLBUYR, 
PHCO


' 
END
GO


