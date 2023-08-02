	create table category
(
    id number(6,0) primary key,  
    name varchar2(50) not null  
    );
    ni	
select * from category;


create sequence seqcategory start with 5 increment by 5;


insert into category(id, name)
values(seqcategory.nextval, 'Floorcleaner');

insert into category(id, name)
values(seqcategory.nextval, 'Detergent');

insert into category(id, name)
values(seqcategory.nextval, 'Airfreshner');

insert into category(id, name)
values(seqcategory.nextval, 'Dishwasher');



select * from category;


create table products
(
    id number(5,0) primary key,  
    name varchar2(50) not null,
    price number(8,2),
    category_id number(6,0) references category(id)
    );
    
select * from products;

create sequence seqproduct start with 10 increment by 10;


insert into products(id, name, price, category_id)
values(seqproduct.nextval, 'Domex', 300, 5);

insert into products(id, name, price, category_id)
values(seqproduct.nextval, 'Tide', 500, 10);


insert into products(id, name, price, category_id)
values(seqproduct.nextval, 'Odonil', 200.55, 15);


insert into products(id, name, price, category_id)
values(seqproduct.nextval, 'Vim', '150', '15');


select * from Products;


select *
from products p, category c
where p.category_id= c.id
====================================================================================


create table cities
(
    id number(4,0) primary key,   
    name varchar2(30) not null
);


create sequence seqcity;

insert into cities(id, name)
values(seqcity.nextval, 'Mumbai');

insert into cities(id, name)
values(seqcity.nextval, 'Pune');

insert into cities(id, name)
values(seqcity.nextval, 'Nagpur');

insert into cities(id, name)
values(seqcity.nextval, 'Nashik');

insert into cities(id, name)
values(seqcity.nextval, 'Kolhapur');

select * from cities;

=====================================================================================

create table customers
(
    id number(7,0) primary key,  
    name varchar2(50) not null,
    locationid number(4,0),
    email varchar2(100) unique,
    dob date,
    cityid number(4,0) references cities(id)
);

alter table customers drop constraint SYS_C0013832;

alter table customers add foreign key (cityid) references cities(id);

    
select * from customers;

drop sequence seqcust;
create sequence seqcust start with 3 increment by 3;

insert into customers(id, name, locationid, email, dob, cityid)
values(seqcust.nextval,  	,4);

insert into customers(id, name, locationid, email, dob, cityid)
values(seqcust.nextval, 	);

insert into customers(id, name, locationid, email, dob, cityid)
values(seqcust.nextval, 'Shree',113,'test2.gmail','11-04-90',1);

insert into customers(id, name, locationid, email, dob, cityid)
values(seqcust.nextval, 'Neha',115,'test3.gmail','11-02-93',3);

select * from customers;

select * 
from customers c, cities z
where c.cityid = z.id;


======================================================================================

create table transactions
(
    txid number(5,0) primary key,  
    txtime timestamp,
    custid number(7,0) references customers(id),
    prodid number(5,0) references products(id),
    qty number(3)
     );


    
select * from transactions;

select * from products;

create sequence seqtran start with 2 increment by 3;

insert into transactions(txid, txtime, custid, prodid, qty)
values(seqtran.nextval, '20-Jan-05',3,40,2);


insert into transactions(txid, txtime, custid, prodid, qty)
values(seqtran.nextval, '20-Jan-05',3,40,2);
		i
insert into transactions(txid, txtime, custid, prodid, qty)
values(seqtran.nextval, '20-Feb-05',6,10,50);


insert into transactions(txid, txtime, custid, prodid, qty)
values(seqtran.nextval, '22-Feb-05',6,40,40);

insert into transactions(txid, txtime, custid, prodid, qty)
values(seqtran.nextval, '22-Feb-05',6,50,5);



select *
from transactions t, customers c, products p
where t.custid = c.id
and   t.prodid = p.id;

-- customer purchase details
select *
from transactions t, customers c, products p, category cat, city ct
where t.custid = c.id
and   t.prodid = p.id
and   p.category_id = cat.id
and   c.cityid = ct.id;


-- cat wise purchae value and nos of transactions
select cat.name catname, sum(t.qty * p.price) purchasevalue, count(t.txid) totalpurchases
from transactions t, products p, category cat
where t.prodid = p.id
and   p.category_id = cat.id
group by cat.name
order by purchasevalue desc;




-- top 2 selling categories
select *
from(
    select rownum idx, catname, purchasevalue
    from (
            select cat.name catname, sum(t.qty * p.price) purchasevalue
            from transactions t, products p, category cat
            where t.prodid = p.id
            and   p.category_id = cat.id
            group by cat.name
            order by purchasevalue desc
        )
    )
where idx <= 2;




-- top 2 selling products
select *
from(
    select rownum idx, prodname, purchasevalue
    from (
            select p.name prodname, sum(t.qty * p.price) purchasevalue
            from transactions t, products p
            where t.prodid = p.id
            group by p.name
            order by purchasevalue desc
        )
    )
where idx <= 2;





-- city wise sales and top 2 cities
select *
from(
    select rownum idx, cityname, purchasevalue
    from (
            select ct.name cityname, sum(t.qty * p.price) purchasevalue
            from transactions t, customers c, products p, city ct
            where t.custid = c.id
            and   t.prodid = p.id
            and   c.cityid = ct.id
            group by ct.name
            order by purchasevalue desc
        )
    )
where idx <= 2;



select to_date(to_char(t.txtime, 'dd-Mon-yy')) txdate, t.qty * p.price sales
from transactions t, products p
where t.prodid = p.id;

-- daily sales
select txdate, sum(sales) sumsales
from (
        select to_date(to_char(t.txtime, 'dd-Mon-yy')) txdate, t.qty * p.price sales
        from transactions t, products p
        where t.prodid = p.id
    )
group by txdate;


select txdate, to_number(to_char(txdate, 'dd')),  sales
from (
        select to_date(to_char(t.txtime, 'dd-Mon-yy')) txdate, t.qty * p.price sales
        from transactions t, products p
        where t.prodid = p.id
    );
    
select round((to_number(to_char(txdate, 'ddd')) / 7),0) week,  sales
from (
        select to_date(to_char(t.txtime, 'dd-Mon-yy')) txdate, t.qty * p.price sales
        from transactions t, products p
        where t.prodid = p.id
    ); 
    
-- weekly sales    
select week, sum(sales)
from (
    select round((to_number(to_char(txdate, 'ddd')) / 7),0) week,  sales
    from (
            select to_date(to_char(t.txtime, 'dd-Mon-yy')) txdate, t.qty * p.price sales
            from transactions t, products p
            where t.prodid = p.id
        )
    )
group by week
order by week;



-- monthly sales    
select short_month, sum(sales)
from (
    select to_char(txdate, 'yyyy-mon') short_month,  sales
    from (
            select to_date(to_char(t.txtime, 'dd-Mon-yy')) txdate, t.qty * p.price sales
            from transactions t, products p
            where t.prodid = p.id
        )
    )
group by short_month
order by short_month;



-- city wise product wise sales
select ct.name cityname, p.name prodname, sum(t.qty * p.price) purchasevalue
from transactions t, customers c, products p, city ct
where t.custid = c.id
and   t.prodid = p.id
and   c.cityid = ct.id
group by ct.name, p.name
order by ct.name, p.name;


-- city wise category wise sales
select ct.name cityname, cat.name catname, sum(t.qty * p.price) purchasevalue
from transactions t, customers c, products p, city ct, category cat
where t.custid = c.id
and   t.prodid = p.id
and   c.cityid = ct.id
and   p.category_id = cat.id
group by ct.name, cat.name
order by ct.name, cat.name;


-- category wise, product wise, city wise sales
select cat.name catname, p.name prodname, ct.name cityname, sum(t.qty * p.price) purchasevalue
from transactions t, customers c, products p, city ct, category cat
where t.custid = c.id
and   t.prodid = p.id
and   c.cityid = ct.id
and   p.category_id = cat.id
group by cat.name, p.name, ct.name
order by cat.name, p.name, ct.name;


-- category wise, city wise sales along with subtotals
select cat.name catname, ct.name cityname, sum(t.qty * p.price) purchasevalue
from transactions t, customers c, products p, city ct, category cat
where t.custid = c.id
and   t.prodid = p.id
and   c.cityid = ct.id
and   p.category_id = cat.id
group by rollup(cat.name, ct.name)
order by cat.name, ct.name;

-- formatted subtotals
select nvl(catname, 'GrandTotal'), nvl(cityname, ' ') cityname, purchasevalue
from (
    select cat.name catname, ct.name cityname, sum(t.qty * p.price) purchasevalue
    from transactions t, customers c, products p, city ct, category cat
    where t.custid = c.id
    and   t.prodid = p.id
    and   c.cityid = ct.id
    and   p.category_id = cat.id
    group by rollup(cat.name, ct.name)
    order by cat.name, ct.name
    );