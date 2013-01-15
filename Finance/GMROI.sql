/* 

GMROI review for Will Crites
SR 6765

http://inventorycurve.com/GMROI.html

Action:  See scanned paperwork from Will
	Validate where summation of avg inventory makes calculations in valid

*/


select *
from openquery(gsfl2k,'
select ibitem,
vmname as Vendor,
pcdesc as ProdCode,
dvdesc as Division,
ITEMMAST.IMDROP AS Drop,
ibco,
ibloc,
(select sum(sleprc-(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)) from shline 
		where slco=ibco
		and slloc=ibloc
		and slitem=ibitem
		and sldate >= current_date - 12 months) AS Profit,
(select sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) from shline 
		where slco=ibco
		and slloc=ibloc
		and slitem=ibitem
		and sldate >= current_date - 12 months) AS COGS,
(select sum(sleprc) from shline 
		where slco=ibco
		and slloc=ibloc
		and slitem=ibitem
		and sldate >= current_date - 12 months) AS Sales,
(IB$I1+IB$I2+IB$I3+IB$I4+IB$I5+IB$I6+IB$I7+IB$I8+IB$I9+IB$I10+IB$I11+IB$I12)/12 as AvgInv


from  itemmast
left join itembal on ibitem = IMITEM
left join itemstat on (isitem = imitem and isloc = ibloc and isco= ibloc)
left join prodcode on pcprcd = imprcd
left join vendmast on imvend = vmvend
left join division on imdiv = dvdiv
left join itemxtra on IMXITM = imitem

where ITEMMAST.IMSI = ''Y''
and itemxtra.imcolimit in (2,0)
/* where ibitem in (''JODC404X120'',''JODC634X120'',''JODC474X4'') */




')

