{{ config(materialized='table') }}

WITH raw_events AS (
    SELECT * FROM ecommerce_dwh.dbo.events_raw
)

SELECT 
    event_id,
    user_id,
    LOWER(event_type) AS event_type,
    TRY_CAST(event_timestamp AS DATETIME) AS event_timestamp,
    page_url
FROM raw_events
WHERE event_id IS NOT NULL