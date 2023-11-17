# Counting in a SQL Select based on the Column Value

I often want to count the number of a specify value in a column. I can do that in the `where` clause if it is only one value, but if I want to count more than one it doesn't work. Instead, you can filter in the `select` clause.

```sql
select Department,
  count(case Position when 'Manager' then 1 else 0 end) as Managers,
  count(case Position when 'Employee' then 1 else 0 end) as Employees,
  count(case Position when 'Contractor' then 1 else 0 end) as Contractors
from Employees
group by Department
order by Department
```
