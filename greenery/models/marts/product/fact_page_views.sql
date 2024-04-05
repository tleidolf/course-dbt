with

events as (
	select * from  {{ ref('stg_postgres__events') }}
),


order_items as (
	select * from  {{ ref('stg_postgres__order_items') }}
),

session_timing_agg as (
	select * from  {{ ref('int_session__timings') }}
)

select
	e.session_id,
    e.user_id,
    coalesce(e.product_id, oi.product_id) as product_id,
    session_started_at,
    session_ended_at,
    sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_views,
    sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts,
    sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkouts,
    sum(case when e.event_type = 'package_shipped' then 1 else 0 end) as packages_shipped,
    datediff('minute', session_started_at, session_ended_at) as session_length_minutes

from events e
left join order_items oi
	on oi.order_id = e.order_id
left join session_timing_agg s
	on s.session_id = e.session_id
group by 1,2,3,4,5
