use gbc_superstore;

/***************** Report 1 *************************/

DELIMITER 

create procedure Report1_Month_wise_profit_Category_Region (
    In year_selected int, month_selected int 
)
BEGIN
select c.name_category 'Name of Category',  d.Region_name as Region, sum(a.Quantity) as 'Q of Order',
CONVERT(sum(a.profit), decimal(10,2)) 'Sum profit',
round((sum(a.profit)/sum((a.Unit_Price * a.Quantity)*(1 - a.Discount)))*100, 2) '% Of Profit'
    from order_details a  inner join orders b
    on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
    inner join (
                select distinct a.id_product, a.id_category,b.name_category from product a inner join
                    (select b.id_category, a.name_category, b.name_subcategory from category a inner join subcategory b
                    on a.id_category = b.id_category) b
                 on a.id_category = b.id_category  ) c
    on a.id_product = c.id_product
    inner join location d on b.id_city = d.id_city
    where YEAR(b.order_date) =  year_selected and MONTH(b.order_date) =month_selected
    group by c.name_category, d.Region_name
    order by 1, YEAR(b.order_date) , MONTH(b.order_date) asc;

 END;
CALL Report1_Month_wise_profit_Category_Region(2020,12)

/***************************** REPORT 2 *************************/
DELIMITER 
 CREATE PROCEDURE Report2_Comparison_month_category(
    In year_selected int
)
BEGIN
SELECT x.name_category,
 sum(case when x.Month= 'January' then x.profit else 0 end) as January,
	sum(case when x.Month= 'February' then x.profit  else 0 end) as February,
    sum(case when x.Month= 'March' then x.profit  else 0 end) as March,
    sum(case when x.Month= 'April' then x.profit  else 0 end) as April,
    sum(case when x.Month= 'May' then x.profit  else 0 end) as May,
    sum(case when x.Month= 'June' then x.profit  else 0 end) as June,
    sum(case when x.Month= 'July' then x.profit else 0 end) as July,
    sum(case when x.Month= 'August' then x.profit  else 0 end) as August,
    sum(case when x.Month= 'September' then x.profit  else 0 end) as September,
    sum(case when x.Month= 'October' then x.profit  else 0 end) as October,
    sum(case when x.Month= 'November' then x.profit else 0 end) as November,
    sum(case when x.Month= 'December' then x.profit  else 0 end) as December
	FROM ( select  c.name_category, MONTHNAME(b.order_date) 'Month',
				CONVERT(sum(a.profit), decimal(10,2)) 'Profit'
				from order_details a  inner join orders b on a.id_order =b.id_order
				inner join (
							select distinct a.id_product, a.id_category,b.name_category from product a inner join
							(select b.id_category, a.name_category, b.name_subcategory from category a inner join subcategory b
							on a.id_category = b.id_category) b
							on a.id_category = b.id_category  ) c
				on a.id_product = c.id_product
                where year(b.order_date) = year_selected
				group  by c.name_category , MONTHNAME(b.order_date) )  x
                group by name_category;
END


CALL Report2_Comparison_month_category(2020)

/***************** Report 3 *********************/	
DELIMITER 
create procedure Report3_Year_Month_wise_profit_Category_Subcategory(
	In year_selected int , month_selected int 
)
BEGIN
	SELECT p.category, p.subcategory, p.Profit_selection_year_month, q.Profit_last_period_selection_year_month,p.Quantity_selection, q.Quantity_last_selection-- q.Q_last_period_orders_selection_year_month -- ,q.Q_last_period_orders_selection_year_month
    FROM (select c.name_category Category,  c.name_subcategory  as Subcategory, 
					CONVERT(sum(a.profit), decimal(10,2)) 'Profit_selection_year_month', count(a.id_order) as 'Quantity_selection'
					from order_details a  inner join orders b
					on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
					inner join (
								select x.id_product,y.name_category,y.name_subcategory from product X inner join 
								(select a.id_category,b.ID_Subcategory, a.name_category , b.name_subcategory from category a inner join subcategory b
								on a.ID_Category= b.ID_Category) Y
					on X.id_category = y.id_category and x.id_subcategory = y.id_subcategory ) c
					on a.id_product = c.id_product
					where YEAR(b.order_date) =  year_selected and month(b.order_date) = month_selected 
					group by c.name_category,c.name_subcategory ) P
    INNER JOIN
    (select c.name_category Category,  c.name_subcategory  as Subcategory,
	CONVERT(sum(a.profit), decimal(10,2)) 'Profit_last_period_selection_year_month',
	count(a.id_order) 'Quantity_last_selection'
	from order_details a  inner join orders b
	on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
	inner join (
				select x.id_product,y.name_category,y.name_subcategory from product X inner join 
				(select a.id_category,b.ID_Subcategory, a.name_category , b.name_subcategory from category a inner join subcategory b
					on a.ID_Category= b.ID_Category) Y
				on X.id_category = y.id_category and x.id_subcategory = y.id_subcategory ) c
	on a.id_product = c.id_product
	 where YEAR(b.order_date) =  year_selected -1  and month(b.order_date) = month_selected 
	group by c.name_category,c.name_subcategory) Q
    on p.category = q.category and p.subcategory = q.subcategory;      
    
END;

CALL Report3_Year_Month_wise_profit_Category_Subcategory(2020,12)


/***************** Report 4 *********************/	
 DELIMITER // 
create procedure Report4_Month_wise_profit_Category_Sub_Quarter()
BEGIN
	select c.name_category,c.name_subcategory,YEAR(b.order_date) as Year,  QUARTER(b.order_date) as Quarter, 
    count(a.id_order) 'Q orders',
	CONVERT(sum(a.profit), decimal(10,2)) 'Sum profit'
	from order_details a  inner join orders b
	on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
	inner join (
				select x.id_product,y.name_category,y.name_subcategory from product X inner join 
				(select a.id_category,b.ID_Subcategory, a.name_category, b.name_subcategory   from category a inner join subcategory b
					on a.ID_Category= b.ID_Category) Y
				on X.id_category = y.id_category and x.id_subcategory = y.id_subcategory  
                ) c
	on a.id_product = c.id_product
	group by c.name_category, c.name_subcategory
	order by 3,4,1,2 asc;
END //
CALL Report4_Month_wise_profit_Category_Sub_Quarter()


/******************* Report 5 ***************************/
DELIMITER 
create procedure Report5_Quantity_Return_orders_Loss (
	In year_selected int , month_selected int
)
BEGIN 
select c.name_category, c.name_subcategory, count(a.id_order) 'q orders', (CONVERT(sum(a.profit), decimal(10,2)))*-1 'Loss'
 from order_details a inner join returns b
on a.id_order = b.id_order 
inner join orders x on a.id_order = x.id_order
inner join  (
				select x.id_product,y.name_category,y.name_subcategory from product X inner join 
				(select a.id_category,b.ID_Subcategory, a.name_category, b.name_subcategory   from category a inner join subcategory b
					on a.ID_Category= b.ID_Category) Y
				on X.id_category = y.id_category and x.id_subcategory = y.id_subcategory  
                ) c
on a.id_product = c.id_product
WHERE year(x.order_date) = year_selected and month(x.order_date) = month_selected 
group by c.name_category, c.name_subcategory;
END ;

CALL Report5_Quantity_Return_orders_Loss(2018,5)


/**************** REPORT 6 ****************************/
DELIMITER 
create procedure Report6_TOP10_PRODUCT_MOST_PROFIT_MONTH_YEAR (
	In year_selected int , month_selected int
)
BEGIN
select c.Name_product ,
    CONVERT(sum(a.profit), decimal(10,2)) 'Sum_profit'
    from order_details a  inner join orders b
    on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
    inner join product c
    on a.id_product = c.id_product
     where YEAR(b.order_date) =  year_selected and MONTH(b.order_date)= month_selected
    group by c.Name_product
    order by 2 desc
    LIMIT 10;
END;
CALL Report6_TOP10_PRODUCT_MOST_PROFIT_MONTH_YEAR(2020,10)


/**************** REPORT 7 ****************************/
DELIMITER 
create procedure Report7_TOP10_PRODUCT_LESS_PROFIT_MONTH_YEAR (
	In year_selected int , month_selected int
)
BEGIN
select c.Name_product ,
    CONVERT(sum(a.profit), decimal(10,2)) 'Sum_profit'
    from order_details a  inner join orders b
    on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
    inner join product c
    on a.id_product = c.id_product
    where YEAR(b.order_date) =  year_selected and MONTH(b.order_date)= month_selected
    group by c.Name_product
    HAVING CONVERT(sum(a.profit), decimal(10,2))>0
    order by 2 asc
    LIMIT 10;
END;
CALL Report7_TOP10_PRODUCT_LESS_PROFIT_MONTH_YEAR(2020,10)

/**************** REPORT 8 ****************************/
DELIMITER 
create procedure Report8_PROFIT_BY_SHIPPING_MODE(
    In year_selected int , month_selected int
)
BEGIN
select c.Ship_Mode 'Ship mode',
    CONVERT(sum(a.profit), decimal(10,2)) 'Sum_profit'
    from order_details a  inner join orders b
    on a.id_order = b.id_order -- where a.id_order = 'CA-2020-140326'
    inner join shipping c
    on b.ID_Shipping = c.ID_Shipping
    where YEAR(b.order_date) =  year_selected and MONTH(b.order_date)= month_selected
    group by b.ID_Shipping
      HAVING CONVERT(sum(a.profit), decimal(10,2))>0;
END;
CALL Report8_PROFIT_BY_SHIPPING_MODE(2020,10)



/****************************** REPORT 9 *************************/
DELIMITER 
create procedure Report9_PROFIT_BY_CUSTOMER_SEGMENT_Comparison(
    In year_selected int , month_selected int 
)
BEGIN
	SELECT p.typecustomer_name, p.Sum_Profit  'Profit this year',
    q.Sum_Profit  'Profit Last year' , 
    CONVERT(((p.Sum_profit -q.Sum_Profit) /q.Sum_profit )* 100, decimal(10,2)) as '% Variance '
    FROM (select c.typecustomer_name,YEAR(b.order_date) as Year,  MONTHNAME(b.order_date) as Month, 
	CONVERT(sum(a.profit), decimal(10,2)) 'Sum_profit'
	from order_details a  inner join orders b
	on a.id_order = b.id_order 
	inner join ( select x.id_customer, y.typecustomer_name from customer x inner join type_customer y
				on x.id_typecustomer = y.id_typecustomer ) c
	on b.id_customer = c.id_customer
     where YEAR(b.order_date) =  year_selected and MONTH(b.order_date)= month_selected 
	group by c.typecustomer_name, MONTH(b.order_date) ) P 
    
    INNER JOIN 
   (select c.typecustomer_name,YEAR(b.order_date) as Year,  MONTHNAME(b.order_date) as Month, 
	CONVERT(sum(a.profit), decimal(10,2)) 'Sum_profit'
	from order_details a  inner join orders b
	on a.id_order = b.id_order 
	inner join ( select x.id_customer, y.typecustomer_name from customer x inner join type_customer y
				on x.id_typecustomer = y.id_typecustomer ) c
	on b.id_customer = c.id_customer
     where YEAR(b.order_date) =  year_selected -1  and MONTH(b.order_date)= month_selected 
	group by c.typecustomer_name, MONTH(b.order_date) ) Q 
    on p.typecustomer_name = q.typecustomer_name ;

END

CALL Report9_PROFIT_BY_CUSTOMER_SEGMENT_Comparison(2020,3)

/********************* REPORT 10*******************/
DELIMITER 
create procedure Report10_Yearly_city_churn_rate_customers(
    In year_selected int
)
BEGIN
SELECT distinct x.year,x.city_name,   y.Total_Customers , 
CONVERT(((x.total_customer / y.Total_Customers)*100), decimal(10,2)) '% Churn' 
FROM (select   count(distinct(b.id_customer )) 'Total_Customer' ,YEAR(a.order_date) as Year ,
		a.id_city ,
	  c .City_name  
      from orders a 
      inner join customer b 
	  on a.id_customer = b.id_customer 
      inner join city c on a.id_city = c.id_city
	  group by a.id_customer,c.City_name,YEAR(a.order_date),c.id_city
      having count(distinct(a.id_order)) =1
      ) X
INNER JOIN 
	(select year(o.Order_Date) as Year, c.id_city,c.City_Name as City, 
    count(distinct(o.ID_Customer)) as 'Total_Customers' 
    from orders o
	inner join city c on o.ID_City = c.ID_City
	group by year(o.Order_Date),c.City_Name) y
ON x.id_city = y.id_city and x.year = y.year
where x.year = 2020
order by 1 asc;
END ;

CALL Report10_Yearly_city_churn_rate_customers(2020)


    
