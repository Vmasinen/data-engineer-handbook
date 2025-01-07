Task_1:
******************
-- A query to deduplicate `game_details` from Day 1 so there's no duplicates

with game_details_rn as (
select  *,
	    row_number() over (partition by game_id, team_id, player_id ) as row_num --applying row_number() window function to assign a row number based on game_id, team_id, player_id
from game_details )
select game_id
    , team_id
    , team_abbreviation
    , team_city
    , player_id
    , player_name
    , nickname
    , start_position
    , comment
    , min
    , fgm
    , fga
    , fg_pct
    , fg3m
    , fg3a
    , fg3_pct
    , ftm
    , fta
    , ft_pct
    , oreb
    , dreb
    , reb
    , ast
    , stl
    , blk
    , "TO" AS turnovers
    , pf
    , pts
    , team_id
    , plus_minus
from game_details_rn
where row_num = 1; --by applying row_num=1 filter we are eliminating the duplicate records