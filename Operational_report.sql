use gbc_superstore;

select d.customer_name, a.id_order, 
b.ship_postalcode, c.name_category, c.name_subcategory,
c.id_product, c.name_product, CONVERT(a.profit, decimal(10,2)) 'Profit'
from order_details a  inner join orders b
on a.id_order = b.id_order 
inner join (
			select a.id_product, a.name_product, a.id_category,
			a.id_subcategory, b.name_category, b.name_subcategory, a.unit_price from product a inner join 
				(select b.id_category, b.id_subcategory, a.name_category, b.name_subcategory from category a inner join subcategory b
				on a.id_category = b.id_category) b
on a.id_category = b.id_category and a.id_subcategory = b.id_subcategory ) c
 on a.id_product = c.id_product
 inner join  customer d on d.id_customer = b.id_customer
 where b.order_date = '2020-09-04'




