declare @date1 date='1/1/2013'

set @date1 = GETDATE()
set @date1 = '9/26/2013'  /* Date of latest 832 run */

select t1.Item,
OQ.imdesc as ItemDesc,
OQ.imcolr as ItemColor,
OQ.vmname as Manufacturer,
t1.PriceType,
t1.Price,
t2.PriceType as PreviousPriceType,
t2.Price as PreviousPrice
from customerpricehistory t1
left join CustomerPriceHistory t2 on (t1.CustID = t2.CustID
									and t1.Item = t2.Item
									and t2.EffectiveDate = (select MAX(EffectiveDate) from CustomerPriceHistory t3 
															where t1.CustID = t3.CustID 
															and t1.Item = t3.Item
															and t3.EffectiveDate < @date1)
									
									)  /* need to make more sophisticated to get the latest date for a Item */
									
join SFIRCR on t1.Item = SFIRCR.SKU
left join openquery (gsfl2k,'select imitem,imdesc,imcolr,vmname from ITEMMAST join vendmast on imvend=vmvend') as OQ on OQ.imitem = t1.Item


where t1.EffectiveDate=@date1
