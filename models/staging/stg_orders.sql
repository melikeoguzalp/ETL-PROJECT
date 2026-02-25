{{ config(materialized='table') }}

WITH raw_orders AS (
    SELECT * FROM ecommerce_dwh.dbo.orders_raw
)

SELECT 
    order_id,
    user_id,
    TRY_CAST(order_date AS DATE) AS order_date,
    UPPER(status) AS status, -- Durumları (Completed, Pending vb.) hep büyük harf yapalım
    -- Negatif tutarları (kirli veri!) 0 ile değiştirelim veya mutlak değerini alalım:
    CASE 
        WHEN total_amount < 0 THEN ABS(total_amount) 
        ELSE total_amount 
    END AS total_amount
FROM raw_orders
WHERE order_id IS NOT NULL