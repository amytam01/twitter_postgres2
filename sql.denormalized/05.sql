/*
 * Calculates the hashtags that are commonly used for English tweets containing the word "coronavirus"
 */

SELECT '#' || hashtag AS tag, COUNT(*) AS count
FROM (
	SELECT DISTINCT
	data ->> 'id' as tweet_id,
	jsonb_array_elements(COALESCE(data -> 'entities' -> 'hashtags', '[]') || COALESCE(data -> 'extended_tweet' -> 'entities' -> 'hashtags', '[]')) ->> 'text' AS hashtag
	FROM tweets_jsonb
	WHERE to_tsvector('english', COALESCE((data -> 'extended_tweet' ->> 'full_text'), (data ->> 'text'))) @@ to_tsquery('english', 'coronavirus') AND data ->> 'lang' = 'en'
) t

GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

