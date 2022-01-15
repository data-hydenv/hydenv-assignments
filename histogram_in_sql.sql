-- You will have to adjust to your number of bins and your edges to use this histogram
-- There is a little 'flaw' in the histogram. Thus, you have to be sure how to read it.
-- Every statistical analysis tool like R, or programming language like Python calculate
-- histograms based on some convention what the edges mean (lower, higher, center) and if they are inclusive.
-- SQL does not have that and thus you need to come up with your own.
select 
	'Edges' as description,
	min(value), -- meaning: min({x | x > 10})
	percentile_disc(0.25) within group (order by value asc) as "25%",
	percentile_disc(0.5) within group (order by value asc) as "Median",
	percentile_disc(0.75) within group (order by value asc) as "75%",
	max(value) -- meaning: max({x | x <= 10000 })
from raw_data 
where variable_id=2 
and value > 10 and value <= 10000
UNION
-- try to understand how I came up with the numbers below!
-- that is the important part.
SELECT
	'Count' as description,
	sum(case when value < 10.8 then 1 else 0 end) as "min",
	sum(case when value >= 10.8 and value < 215.3 then 1 else 0 end) as "25%",
	sum(case when value >= 215.3 and value < 775 then 1 else 0 end) as "Median",
	sum(case when value >= 775 and value < 1980.6 then 1 else 0 end) as "75%",
	sum(case when value >= 1980.6 and value < 9644.5 then 1 else 0 end) as "max"
from raw_data
where variable_id=2