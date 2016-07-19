CREATE OR REPLACE FUNCTION get_locations(IN ids int[])
RETURNS TABLE(id INT, name CHARACTER VARYING) AS
$BODY$
BEGIN
RETURN QUERY
SELECT location.id AS id,
	store.name AS name
FROM location
LEFT JOIN store ON store.id = location.store
WHERE location.id IN (ids); END; $BODY$ 
LANGUAGE plpgsql
