/*
=========================================
Marketing Campaign Performance Analysis
Tools: MySQL, Power BI
=========================================
*/


-- 1. Overall Marketing Performance

SELECT 
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversion,
    SUM(cost) AS total_cost,
    SUM(revenue) AS total_revenue
FROM camp_performance;



-- 2. Campaign Revenue Analysis

SELECT 
    c.campaign_name,
    SUM(conversions) AS total_conversion,
    SUM(revenue) AS total_revenue
FROM camp_performance p
JOIN campaign c
    ON p.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY total_revenue DESC;



-- 3. Channel Engagement & Revenue Analysis

SELECT 
    ch.channel_name,
    SUM(p.impressions) AS total_impressions,
    SUM(p.clicks) AS total_clicks,
    SUM(p.conversions) AS total_conversion,
    SUM(p.revenue) AS total_revenue
FROM camp_performance p
JOIN channels ch
    ON p.channel_id = ch.channel_id
GROUP BY ch.channel_name
ORDER BY total_revenue DESC;



-- 4. Click-Through Rate (CTR) Analysis

SELECT 
    ch.channel_name,
    ROUND(SUM(p.clicks) / SUM(p.impressions) * 100, 2) AS ctr_percentage
FROM camp_performance p
JOIN channels ch
    ON p.channel_id = ch.channel_id
GROUP BY ch.channel_name
ORDER BY ctr_percentage DESC;



-- 5. Conversion Rate Analysis

SELECT 
    c.campaign_name,
    ROUND(SUM(p.conversions) / SUM(p.clicks) * 100, 2) AS conversion_rate
FROM camp_performance p
JOIN campaign c
    ON p.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY conversion_rate DESC;



-- 6. Return on Investment (ROI) Analysis

SELECT 
    c.campaign_name,
    ROUND((SUM(p.revenue) - SUM(p.cost)) / SUM(p.cost) * 100, 2) AS roi_percentage
FROM camp_performance p
JOIN campaign c
    ON p.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY roi_percentage DESC;



-- 7. Revenue & Conversion Trend Analysis

SELECT 
    d.month,
    SUM(p.conversions) AS total_conversion,
    SUM(p.revenue) AS total_revenue
FROM camp_performance p
JOIN dates d
    ON p.date_id = d.date_id
GROUP BY d.month
ORDER BY d.month DESC;



-- 8. Top Campaign Performance by Channel

SELECT 
    channel_name,
    campaign_name,
    revenues,
    rank_position
FROM (
        SELECT 
            ch.channel_name,
            c.campaign_name,
            SUM(p.revenue) AS revenues,
            DENSE_RANK() OVER(
                PARTITION BY ch.channel_name
                ORDER BY SUM(p.revenue) DESC
            ) AS rank_position
        FROM camp_performance p
        JOIN campaign c
            ON p.campaign_id = c.campaign_id
        JOIN channels ch
            ON p.channel_id = ch.channel_id
        GROUP BY ch.channel_name, c.campaign_name
) ranked_campaigns;



-- 9. Revenue per Click (RPC) Analysis

SELECT 
    c.campaign_name,
    ROUND(SUM(p.revenue) / SUM(p.clicks), 2) AS rpc
FROM camp_performance p
JOIN campaign c
    ON p.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY rpc DESC;



-- 10. Campaign Revenue Consistency Analysis

SELECT 
    c.campaign_name,
    STDDEV(p.revenue) AS revenue_stddev
FROM camp_performance p
JOIN campaign c
    ON p.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY revenue_stddev;