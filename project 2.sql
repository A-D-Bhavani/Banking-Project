create database bank;

use bank

select * from bank
-----finding total loan applications------
select count(1) as 'total_loan_appln' from bank
------total funded amount--------
select sum(loan_amount)/1000000 as 'total_funded_amt in millions' from bank
------total payment received-------
select sum(total_payment)/1000000 as 'total_payment_rcvd in millions' from bank
--------average interest rate based on purpose-------
select distinct purpose,round(avg(int_rate)*100,0) as 'percentage wise loan purpose' from bank
group by purpose
order by purpose desc
-------average DTI group by month-------
select year(issue_date) as 'year',month(issue_date)as 'month', round(avg(dti),2)*100 as 'percent_of_avg_DTI' from bank
group by year(issue_date),month(issue_date)
order by month(issue_date) asc;

------GOOD LOAN VS BAD LOAN

-----finding good loan based on :1- good loan percent those who are fully and timely paid,
------2-good loan count those who are fully and timely paid,
------3-good loan amount rcvd those who are fully and timely paid.

                                    --good loan count & amount

-- good loan count
select count(*) as total_good_loan_count from bank
where loan_status in ('fully paid','current')

---good loan percentage
select count(case when loan_status in('fully paid','current') then id end)*100/count(id) as 'total_good_loan_percebtage'from bank

----good loan total amount
select concat(cast(sum(total_payment)/1000000 as int),' ','millions') as 'good_loan_total_amount' from bank
where loan_status in('fully paid','current')

                                   --bad loan count & amount

-----bad loan count---
select count(*) as total_good_loan_count from bank
where loan_status in ('charged off')
----bad loan percentage----
select count(case when loan_status ='charged off' then id end)*100/count(id) as bad_loan_percentage from bank
------bad loan amount
select concat(cast(sum(total_payment)/1000000 as int),' ','millions' )as total_bad_loan_amount from bank
where loan_status in('charged off')


---------------------

use bank
with a as(
select year(issue_date) as 'year',
       month (issue_date)as 'month',
	   sum(total_payment) as 'currentmonthpayment'
	   from bank
	   where year(issue_date)=2021
	   group by 
       month (issue_date),
	   year(issue_date)
	   ),
b as (
      select *, lag(currentmonthpayment) over (order by month) as 'previousmonthpayment' from a)
	  
	  select *, (currentmonthpayment-previousmonthpayment) as 'monthovermonthpayment' from b

------------- calculating month to month avg inters_rate ------------------
select * from bank
with a as(
select year(issue_date)as 'year',
       month(issue_date) as 'month',
	   round(avg(int_rate)*100,2) as 'avg_int_rate'
from bank
      where year(issue_date)=2021
	  group by 
	  year(issue_date),
	  month(issue_date)
),
b as (
     select *,lag(avg_int_rate) over (order by month) as 'previousmonthavg_int' from a)

	 select * , round(avg_int_rate - previousmonthavg_int,2) as 'monthovermonth_avgint' from b
    









