# Project 1 answers

### How many users do we have?
Answer:130 
'''
select count(*)
from dev_db.dbt_aleidolf03yahoocom.stg_postgres__users
'''

### On average, how many orders do we receive per hour?
Answer:7.53 
'''
SELECT COUNT(order_id) / (DATEDIFF('second', MIN(created_at), MAX(created_at)) / 3600) AS avg_orders_per_hour
FROM dev_db.dbt_aleidolf03yahoocom.stg_postgres__orders
'''

### On average, how long does an order take from being placed to being delivered?
Answer:93 hours

'''
SELECT AVG(DATEDIFF('second', created_at, delivered_at)) / 3600 AS avg_delivery_time_hours
FROM dev_db.dbt_aleidolf03yahoocom.stg_postgres__orders
WHERE delivered_at IS NOT NULL;
'''

### How many users have only made one purchase? Two purchases? Three+ purchases?
Answer:25,28,34


'''
SELECT COUNT(user_id) AS single_purchase_users
FROM (
    SELECT user_id, COUNT(DISTINCT order_id) AS total_purchases
    FROM table_name
    GROUP BY user_id
    HAVING total_purchases = 1 --change to 2 , 3
) AS user_purchases;

'''

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

### On average, how many unique sessions do we have per hour?
Answer:16.32
'''
SELECT AVG(unique_sessions_per_hour) AS average_unique_sessions_per_hour
FROM (
    SELECT DATE_TRUNC('hour', created_at) AS hour_start,
           COUNT(DISTINCT session_id) AS unique_sessions_per_hour
    FROM dev_db.dbt_aleidolf03yahoocom.stg_postgres__events
    GROUP BY hour_start
) uni_session
'''