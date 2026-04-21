-- Daily Revenue Trends
SELECT
    time_of_day,
    ROUND(AVG(hourly_revenue), 2) AS avg_revenue
FROM (
    SELECT
        transaction_date,
        time_of_day,
        SUM(revenue) AS hourly_revenue
    FROM (
        SELECT
            transaction_date,
            EXTRACT(HOUR FROM transaction_time) AS time_of_day,
            transaction_qty * unit_price AS revenue
        FROM
            coffee_data
    )
    GROUP BY
        time_of_day,
        transaction_date
    ORDER BY
        transaction_date,
        time_of_day
)
GROUP BY
    time_of_day
ORDER BY
    time_of_day;

-- Top 10 Best Selling Products
SELECT
    product_detail,
    SUM(transaction_qty) AS no_of_sales
FROM
    coffee_data
GROUP BY
    product_detail
ORDER BY
    no_of_sales DESC
LIMIT
    10;

-- Top 5 Items Per Category by Revenue
SELECT
    product_category,
    product_detail AS product_name,
    total_revenue,
    revenue_rank
FROM (
    SELECT
        product_category,
        product_detail,
        SUM(transaction_qty * unit_price) AS total_revenue,
        RANK() OVER(
            PARTITION BY product_category
            ORDER BY SUM(transaction_qty * unit_price) DESC
        ) AS revenue_rank
    FROM
        coffee_data
    GROUP BY
        product_detail,
        product_category
)
WHERE
    revenue_rank <= 5;

-- Average Order Value Per Day
SELECT
    ROUND(AVG(transaction_qty * unit_price), 2) AS average_order_value
FROM
    coffee_data


