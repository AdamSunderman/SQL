#Written By Adam Sunderman - 7/25/2017

#1 Find all films with maximum length or minimum rental duration (compared to all other films). 
#In other words let L be the maximum film length, and let R be the minimum rental duration in the table film. You need to find all films that have length L or duration R or both length L and duration R.
#You just need to return attribute film id for this query. 

select film_id as `Film IDs that are Max Length or Min Rental Duration` from film  
where length=( select length from film order by length desc limit 1)
or rental_duration=(select rental_duration from film order by rental_duration limit 1);

#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).

select col1.name as 'Catagories', count(col2.name) as 'Ed Chase Roles' 
from(
	select name from category
) as col1
left join( 
	select c.name from category c
	inner join film_category fc on fc.category_id=c.category_id
	inner join film_actor fa on fa.film_id=fc.film_id
	inner join actor a on a.actor_id=fa.actor_id
	where a.first_name="Ed" AND a.last_name="Chase"
) as col2 on col1.name=col2.name 
group by col1.name;

#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

select a.actor_id as 'Actor ID', concat(a.first_name,' ',a.last_name) as 'Actor Name', ifnull(c4.act_sum,0) as 'Sum of Sci-Fi Film Lengths' from actor a 
left join(
	select c3.actor_id, sum(c3.length) as act_sum from(
		select f.film_id as fid, f.length as length, c1.film_id as fid2, c1.actor_id from film f
		inner join film_category fc on fc.film_id=f.film_id
		inner join category c on c.category_id=fc.category_id
		left join ( 
			select fa.film_id, fa.actor_id from film_actor fa
		) as c1 on f.film_id=c1.film_id where c.name="Sci-Fi"
	) as c3 where c3.actor_id in (
			select actor_id from actor group by actor_id order by actor_id
	)group by c3.actor_id
)as c4 on a.actor_id=c4.actor_id
group by a.actor_id, c4.act_sum;

#4 Find the first name and last name of all actors who have never been in a Sci-Fi film

select distinct concat(a.first_name, ' ', a.last_name) as `Actors Not In Sci-Fi Films` from actor a
inner join film_actor fa on fa.actor_id=a.actor_id
inner join film f on f.film_id=fa.film_id
inner join film_category fc on fc.film_id=f.film_id
inner join category c on c.category_id=fc.category_id where c.name<>'Sci-Fi'
order by `Actors Not In Sci-Fi Films`;

#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

select distinct f.title as `Films with KIRSTEN PALTROW & WARREN NOLTE` from film f 
where f.film_id in ( 
	select fa.film_id from film_actor fa where fa.actor_id=(
		select actor_id from actor where first_name="KIRSTEN" and last_name="PALTROW")
) and f.film_id in( 
	select fa2.film_id from film_actor fa2 where fa2.actor_id=(
		select actor_id from actor where first_name="WARREN" and last_name="NOLTE")
) order by `Films with KIRSTEN PALTROW & WARREN NOLTE` desc;


