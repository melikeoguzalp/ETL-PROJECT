{{ config(materialized='table') }}

WITH users AS (
    SELECT * FROM {{ ref('stg_users') }}
),
orders AS (
    SELECT 
        user_id,
        COUNT(order_id) as total_orders,
        SUM(total_amount) as total_spent
    FROM {{ ref('stg_orders') }}
    GROUP BY user_id
),
events AS (
    SELECT 
        user_id,
        COUNT(event_id) as total_actions
    FROM {{ ref('stg_events') }}
    GROUP BY user_id
)

SELECT 
    u.user_id,
    u.full_name,
    u.email,
    COALESCE(o.total_spent, 0) as total_spent,
    COALESCE(o.total_orders, 0) as total_orders,
    COALESCE(e.total_actions, 0) as total_interactions
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN events e ON u.user_id = e.user_id
WHERE o.total_spent > 500 -- Sadece 500 birimden fazla harcayanları VIP sayalım