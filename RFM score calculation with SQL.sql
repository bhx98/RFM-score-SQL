select ContactName, rfm_recency, rfm_frequency, rfm_monetary, round((rfm_monetary + rfm_recency + rfm_frequency)/3) as rfm_score 
from (
select ContactName,
	ntile(5) over (order by last_order_date) as rfm_recency,
	ntile(5) over (order by count_order) as rfm_frequency,
	ntile(5) over (order by avg_amount) as rfm_monetary

from (

select cus.ContactName, 
       max(ord.OrderDate) as last_order_date,
       count(*) as count_order,
       avg(ordd.UnitPrice) as avg_amount
from orders ord
left join `order details` ordd
on ordd.OrderID = ord.OrderID
left join customers cus 
on cus.CustomerID = ord.CustomerID 
group by cus.ContactName
) as RFM 
) as RFMcombined 
order by rfm_score desc