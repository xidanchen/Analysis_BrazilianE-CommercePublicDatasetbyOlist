# geolocation data
USE olistpublic;
select*from geolocation;
# zip_code column is not unique, 17972 cases having same zip_code
select geolocation_zip_code_prefix
from geolocation
group by geolocation_zip_code_prefix
having count(geolocation_zip_code_prefix) > 1;

/* select geolocation_zip_code_prefix
from geolocation
where geolocation_zip_code_prefix = 01001
; */
# gelocation_lat is not unique
select geolocation_lat
from geolocation
group by geolocation_lat
having count(geolocation_lat) > 1;

# geolocation_lng is not unique
select geolocation_lng
from geolocation
group by geolocation_lng
having count(geolocation_lng) > 1;

# any replication? same address?
select geolocation_lng, geolocation_lat
from geolocation
group by geolocation_lng, geolocation_lat
having count(*) > 1;

select *
from geolocation
where geolocation_lng = -46.639292 and geolocation_lat = -23.545621;

select *
from geolocation
where geolocation_zip_code_prefix = 01037
order by geolocation_lng;

# most orders/customers come from sp sao paulo, is there area/region differences in sp sao paulo?
select geolocation_state, geolocation_city, count(*)
from geolocation
group by geolocation_state, geolocation_city
order by count(*) desc
;

# use tableau for further analysis. visualization with maps will be more intuitive
select geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, count(*)
from geolocation
where geolocation_city = 'sao paulo' and geolocation_state = 'SP'
group by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng
order by count(*) desc
;


select *, count(*)
from geolocation
group by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng
having count(*) > 1
order by count(*) desc
;


