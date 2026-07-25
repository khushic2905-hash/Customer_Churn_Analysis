use Customerchurn_db;
select *
from customer_churn_dataset;

--overview of data--
select top 10 *
from customer_churn_dataset;

--checking the datatype--
select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'customer_churn_dataset';

exec sp_help 'customer_churn_dataset';

--check for nulls--
select 
sum(case when Gender is null then 1 else 0 end) as Gender,
sum(case when Tenure is null then 1 else 0 end) as Tenure,
sum(case when MonthlyCharges is null then 1 else 0 end) as MonthlyCharges,
sum(case when ContractType is null then 1 else 0 end) as ContractType,
sum(case when InternetService is null then 1 else 0 end) as InternetService,
sum(case when TotalCharges is null then 1 else 0 end) as TotalCharges,
sum(case when TechSupport is null then 1 else 0 end) as TechSupport,
sum(case when Churn is null then 1 else 0 end) as churn
from customer_churn_dataset;

--check for duplicates--
select CustomerID
from customer_churn_dataset
group by CustomerID
having count(*)>1;

--checking for negatives--
select CustomerID 
from customer_churn_dataset
where age<=0 or
Tenure<0 or MonthlyCharges<0 
or TotalCharges<0 or TechSupport<0 
or Churn<0;

--which age group customers are churn--
select Age,COUNT(Churn) as churned_age_groups
from customer_churn_dataset
group by Age
having count(churn) = 1
order by Age;
--Mostly people of age above 60 till 80-83 years of age are having more churning rate.

select top 10 *
from customer_churn_dataset;
--which gender has high monthly charges--
select Gender,round(MAX(MonthlyCharges),2) as high_month_charge
from customer_churn_dataset
group by Gender
order by max(MonthlyCharges) desc;
--although, both are paying nearly equal high month charge of Rs 119 but females are paying slighly high i.e Rs 119.96.

--customers who got tech support--
select TechSupport, count(*) AS Total_Customers
from customer_churn_dataset
group by TechSupport;

--time period and churn--
select Tenure,count(Churn) as count_of_churn_tenure
from customer_churn_dataset
group by Tenure
having count(Churn) = 1
order by Tenure desc;

--churn rate--
select sum(case when churn =1 then 1 else 0 end)*100/count(CustomerID) as churn_rate
from customer_churn_dataset;
--88% is the churned rate

--how many cutomers have churned--
select COUNT(CustomerID) as Churned_Customers
from customer_churn_dataset
where Churn = 1;
--883 customers have churned

--which contract type has highest churn rate--
select ContractType,
sum(case when churn = 1 then 1 end)*100.0/COUNT(CustomerID) as churn_rate
from customer_churn_dataset
group by ContractType
order by churn_rate DESC;
--month-to-month:100%
--two-year:77%
--one-year:75%

--which internet service has highest churn rate--
select InternetService,
sum(case when churn = 1 then 1 end)*100.0/COUNT(CustomerID) as churn_rate
from customer_churn_dataset
group by InternetService
order by churn_rate DESC;
--DSL:84.42%
--Fibre optic:82.53%
select top 10* from customer_churn_dataset;

--what is the average total charges by contract type--
select ContractType, round(avg(TotalCharges),2) as avg_total_charges
from customer_churn_dataset
group by ContractType;
--month-to-month:1448.49
--two-year:1303.3
--one-year:1396.29

--top 10 customers with highest total charges--
select top 10 *
from customer_churn_dataset
order by TotalCharges desc;

--ranking customers by total charges within each contract type--
select CustomerID,
TotalCharges,
ContractType,
rank() over(partition by ContractType order by TotalCharges desc) as customer_rank
from customer_churn_dataset;

--customers whose monthly charges are above overall average--
select *
from customer_churn_dataset
where MonthlyCharges>
(select AVG(MonthlyCharges) as avg_month_charges
from customer_churn_dataset);





