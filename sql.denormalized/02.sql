/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */

SELECT '#' || hashtag AS tag, COUNT(*) AS count
FROM (
	SELECT DISTINCT
	data ->> 'id',
	jsonb_array_elements(COALESCE(data -> 'entities' -> 'hashtags', '[]') || COALESCE(data -> 'extended_tweet' -> 'entities' -> 'hashtags', '[]')) ->> 'text' AS hashtag
	FROM tweets_jsonb
	WHERE (data -> 'entities' -> 'hashtags') @> '[{"text":"coronavirus"}]' OR (data -> 'extended_tweet'-> 'entities' -> 'hashtags') @> '[{"text":"coronavirus"}]') t
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

