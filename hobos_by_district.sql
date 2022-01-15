-- create a subquery for freiburg, transformed on the fly
with freiburg as (
	select 
		name, 
		st_transform(geom, 25832) as geom 
	from osm_nodes 
	where node_type='district'
),
-- filter for only HOBOs, transform and add term info
hobo as (
	select  
		m.id,
		st_transform(location, 25832) as geom,
		t.short
	from metadata m
	join sensors s on s.id=m.sensor_id
	join terms t on t.id=m.term_id
	where s.name='hobo'
),
-- join the district to each hobo
hobo_with_district as (
	select 
		id,
		short,
		name as district,
		freiburg.geom as geom
	
	from hobo
	join freiburg on st_within(hobo.geom, freiburg.geom)
)

-- this is now jsut the overview. We can use various different analysis from here you can uncomment any of the selects below
select * from hobo_with_district

-- count the hobos in each district
-- select district, count(*) from hobo_with_district group by district order by count desc

-- group by district and semenster
--select short, district, count(*) from hobo_with_district 
--group by short, district
--order by short, count desc