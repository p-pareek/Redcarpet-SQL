#1 What is the count of purchases per month (excluding refunded purchases)?


Ans:
select Date(purchase_time), count(gross_transaction_value)

     from transactions

     group by purchase_time,gross_transaction_value

     order by purchase_time,gross_transaction_value;

#2 How many stores receive at least 5 orders/transactions in October 2020?

Ans: Insufficient Data

#3 For each store, what is the shortest interval (in min) from purchase to refund time?
Ans:
ALTER table transactions

ADD COLUMN shortest_interval int AS (

    CASE

    WHEN refund_time is NULL THEN '-'

    ELSE DATEDIFF(hour, refund_time,purchase_time) as DateDiff END
);

#4 What is the gross_transaction_value of every store’s first order?
Ans:
select (store_id),sum(gross_transaction_value)

     from transactions

     group by store_id, gross_transaction_value

     order by store_id, gross_transaction_value;

#5 What is the most popular item name that buyers order on their first purchase?


Ans:
select (item_name)

     from items

     group by store_id, item_name

     order by store_id, item_name;

#6 Create a flag in the transaction items table indicating whether the refund can be processed or not. The
condition for a refund to be processed is that it has to happen within 72 of Purchase time. Expected
Output: Only 1 of the three refunds would be processed in this case
Ans:
ALTER TABLE transactions

ADD COLUMN refund VARCHAR(25) AS (

    CASE WHEN refund_time is NULL THEN '-'
 
   WHEN refund_time < purchase_time THEN "Error"
 
   WHEN DATEDIFF(refund_time,purchase_time) > 72 THEN "late" ELSE "accepted" END

);


Select purchase_time,refund_time,DateDiff(hour, purchase_time,refund_time) as DateDiff,refund from transactions;



#7. Create a rank by buyer_id column in the transaction items table and filter for only the second purchase per
buyer. (Ignore refunds here)
Expected Output: Only the second purchase of buyer_id 3 should the output
Ans:
WITH rankings AS (

SELECT buyer_id,

       purchase_time,

       RANK() OVER(PARTITION BY buyer_id ORDER BY purchase_time ASC ) Rank

FROM transactions

ORDER BY buyer_id,

         Rank )

SELECT buyer_id,purchase_time

FROM rankings

WHERE Rank = 2;



ALTER TABLE transactions ADD COLUMN rank_id INT

AS (RANK() OVER ( PARTITION BY ID ORDER BY ptime ASC ));
