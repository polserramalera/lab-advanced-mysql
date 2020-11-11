use publications;
select * from sales;
select * from titleauthor;
select * from titles;

/*STEP 1: Calculate the royalty of each sale for each author and the advance for each author and publication*/
select t.title_id as title,
ta.au_id as author,
round(t.advance * ta.royaltyper/100) as advance,
round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
inner join titleauthor ta
on t.title_id=ta.title_id
inner join sales s
on t.title_id=s.title_id;

/*Step 2: Aggregate the total royalties for each title and author*/

select title, author, sum(sales_royalty) as total_royalties, advance from 
(select t.title_id as title, 
ta.au_id as author, 
round(t.advance * ta.royaltyper/100) as advance,
round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
inner join titleauthor ta
on t.title_id=ta.title_id
inner join sales s
on t.title_id=s.title_id) tr
group by title,author;

/*Step 3: Calculate the total profits of each author*/

select author, total_royalties + advance as total_income from
(select title, author, sum(sales_royalty) as total_royalties, advance from 
(select t.title_id as title, 
ta.au_id as author, 
round(t.advance * ta.royaltyper/100) as advance,
round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
inner join titleauthor ta
on t.title_id=ta.title_id
inner join sales s
on t.title_id=s.title_id) tr
group by tr.title,tr.author) rev
group by author
order by total_income desc 
limit 3;

/*CHALLENGE 2* ALTERNATIVE SOLUTION */

/*STEP 2*/

DROP TEMPORARY TABLE ROYALTIES;
CREATE TEMPORARY TABLE ROYALTIES
select t.title_id as title,
ta.au_id as author,
round(t.advance * ta.royaltyper/100) as advance,
round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
from titles t
inner join titleauthor ta
on t.title_id=ta.title_id
inner join sales s
on t.title_id=s.title_id;
select *
from ROYALTIES
group by author, title;

/*STEP 3*/
DROP TEMPORARY TABLE REVENUES;
CREATE TEMPORARY TABLE REVENUES
select r.title, r.author, sum(r.sales_royalty) as total_royalties, r.advance 
from ROYALTIES r
group by r.title,r.author;
select  author, total_royalties + advance as total_income
from REVENUES
group by author
order by total_income desc
limit 3;





 