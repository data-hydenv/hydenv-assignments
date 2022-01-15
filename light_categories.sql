-- This is my solution for the group light by temperature task.
-- You can use (alsmost) the same query, but you will not end up
-- with exactly the same amount of classes and your edges will be different.
-- If you can't manage to build your own, you can use this one but you
-- will obviously not be credited for the according task.

-- get only light measurements
with light as(
	select meta_id, variable_id, tstamp, value as light 
	from raw_data 
	where variable_id=2
),
-- get only temperature measurements
temperature as (
	select meta_id, variable_id, tstamp, value as temperature 
	from raw_data 
	where variable_id=1
),
-- apply YOUR categories
light_cat as (
	select 
		l.meta_id, 
		l.tstamp,
		CASE 
			WHEN l.light < 10.8  THEN 'min'
			WHEN l.light >= 10.8 AND l.light < 215.3 THEN '25%'
			WHEN l.light >= 215.3 AND l.light < 775 THEN 'Median'
			WHEN l.light >= 775 AND l.light < 1980.6 THEN '75%'
			WHEN l.light >= 1980.6 AND l.light < 9644.5 THEN 'max'
			ELSE '>max'
		END as category,
		l.light
	From light l
),
-- compile all others into a records or 'data point'
record as (
	select l.meta_id, l.tstamp, l.light, l.category, t.temperature
	from light_cat l
	join temperature t on t.meta_id=l.meta_id and t.tstamp=l.tstamp
)
-- show all
select * from record order by meta_id, tstamp asc