{{ config(materialized='table') }}

WITH raw_data AS (
    SELECT * FROM ecommerce_dwh.dbo.users_raw
)

SELECT 
    user_id,
    TRIM(full_name) AS full_name,
    LOWER(email) AS email,
    -- TRY_CAST, eğer veri tarihe dönüşmüyorsa hata vermek yerine NULL döndürür.
    -- Böylece tüm sürecin çökmesini engelleriz.
    TRY_CAST(registration_date AS DATE) AS registration_date
FROM raw_data
WHERE email IS NOT NULL 
  AND registration_date IS NOT NULL -- Tarihi bozuk olanları da şimdilik eliyoruz