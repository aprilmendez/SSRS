  
/*----------------------------------------------------------  
--  
-- Jame Tuttle 09/25/2012  
--  
-- Added not to include reverse POs  
-- PHRETURN != 'Y'  
------------------------------------------------------------*/  
  
  
  
  
CREATE Proc [dbo].[InboundFrieghtPortland] as  
  
select OQ.*,MT.MTSTATUS  
from openquery(GSFL2K,'  
  
Select Poline.PLDDAT As DueDate,  
  
case   
 when POLINE.PLDDAT <> ''0001-01-01'' then Poline.PLDDAT - 7 DAYS   
 else ''0001-01-01''  
end as ActualArrivalDueDate,   
  
Poline.PLCO as Company,  
Poline.PLLOC As Location,   
Family.FMDESC as Family,   
Vendmast.VMNAME As VendorName,   
Poline.PLPO# As PO,   
Poline.PLITEM As SKU,   
Poline.PLDESC As Description,   
Itemmast.IMCOLR As Color,   
Poline.PLQORD As UnitsOrdered,  
Itemfact.IFFACA as UnitsPerPallet,   
Itemfact.IFUMC,   
Poline.PLQORD/Itemfact.IFFACA As TotalPallets,  
(select max(mnman#) from manifest where mnpo# = poline.plpo#  
      and mnpolo = poline.plloc  
      and mnitem = poline.plitem  
      and mnpoco = poline.plco) as Manifest,  
(select sum(ibqoh) from itembal where ibitem = itemmast.imitem) as OnHand  
  
FROM Poline  
  
left join Itemmast on Itemmast.IMITEM = Poline.PLITEM  
Left Join Pohead On (Poline.PLco = Pohead.PHco  
 and Poline.PLloc = Pohead.PHloc  
 and poline.plvend = pohead.phvend  
 and Poline.PLPO# = Pohead.PHPO#)   
Left Join Itemfact On Poline.PLITEM = Itemfact.IFITEM   
Left Join Vendmast On Poline.PLVEND = Vendmast.VMVEND   
Left Join Family On Poline.PLFMCD = Family.FMFMCD   
  
Where Itemfact.IFUMC = ''P''   
AND Poline.PLITEM <> ''GENPROMO''   
AND Poline.PLITEM <> ''COBROKENPALLET''   
AND Poline.PLQORD/Itemfact.IFFACA > 0.999   
AND Pohead.PHDOI > ''12/31/2005''  
/* AND Poline.PLCO = 1 */  
and poline.plloc in (42,60)  
AND Poline.PLDELT <> ''C''  
AND Poline.PLDIRS <> ''Y''   
and poline.plvend in (22666,16088,22816,22887,22204,22949,22686)  
/* and Poline.PLDDAT <> ''0001-01-01'' */  
AND POhead.phreturn != ''Y''  
  
Order By Poline.PLDDAT, Vendmast.VMNAME, Poline.PLPO#, Poline.PLITEM   
') OQ  
  
LEFT join GSFL2K.B107Fd6E.GSFL2K.MANTRACK MT on Manifest = MT.MTMAN#  
  
  
  
  