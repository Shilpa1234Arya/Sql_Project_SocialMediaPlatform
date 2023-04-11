                                            ## Advanced SQL Mandatory Project ##
                                            
 Use id_clone   -- (Using ig_clone data Base)                                           

1) -- Create an ER diagram or draw a schema for the given database.
-- Attached ER diagram in Zip file.

2) -- We want to reward the user who has been around the longest, Find the 5 oldest users.users ?

Select username from users
order by Created_at asc
limit 5;

3) -- To understand when to run the ad campaign, figure out the day of the week most users register on? 

Select DayName from (Select dayname(created_at)  as DayName, count(id) from users
Group by dayname(created_at)
order by count(id) desc
Limit 1) as Days_registration;

4.) -- To target inactive users in an email ad campaign, find the users who have never posted a photo.

Select u.username from users u LEFT JOIN photos p on u.id = p.user_id
where p.id is null;


5.) -- Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

Select u.username -- , photo_likes.photo_id, photo_likes.Number_of_likes
from (select photo_id, count(photo_id) as Number_of_likes from likes 
group by photo_id order by Number_of_likes desc limit 1) as photo_likes
inner join photos p on p.id = photo_likes.photo_id 
inner join users u on u.id = p.user_id;


6.) -- The investors want to know how many times does the average user post.

-- Assumption 1 : avg user post with respect to the user who have posted atleat 1 photo
Select count(id)/count(distinct(user_id)) as Average_user_post from photos;

-- Assumption 2 : avg user post with respect to Total users
SELECT (SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users);


7.) -- A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

Select tag_name from (Select tag_id, tag_name, count(tag_id) as tag_used from Photo_tags pt
join tags t on pt.tag_id = t.id
group by tag_id order by tag_used desc
limit 5) as Most_used_hashtag;


8.) -- To find out if there are bots, find users who have liked every single photo on the site.

Select username from (select l.user_id , u.username, count(l.photo_id) as photos_liked 
from likes l inner join users u on u.id = l.user_id
group by l.user_id, u.username
having photos_liked = (select Count(id) from photos)) as liked_every_photo;


9.) -- To know who the celebrities are, find users who have never commented on a photo.

Select U.username from users U
left join comments C on C.user_id = U.id
where C.id is null;


10.) -- Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.

-- Never commented
Select U.username as user_name  from users U
left join comments C on C.user_id = U.id
where C.id is null
union 
-- Commented on every photo
Select username from (select  u.username, count(l.photo_id) as photos_liked   
from likes l inner join users u on u.id = l.user_id
group by l.user_id, u.username
having photos_liked = (select Count(id) from photos)) as comment_on_every_photo;




