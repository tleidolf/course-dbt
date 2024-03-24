select 
	session_id, 
    event_id,
	user_id,
	page_url,
	created_at,
	event_type, 
	order_id,
	product_id 
from {{source('postgres', 'events')}}