CREATE OR REPLACE FUNCTION get_items(IN plist text, IN locations int[], IN this_user int)
  RETURNS TABLE(store character varying, product character varying, brand character varying, category character varying, id int, price real, size real, unit character varying, ppu real, vegan boolean, p_un boolean, b_un boolean, histlow real, taste int, nutrition int, notes text, location_id int) AS
$BODY$
BEGIN
RETURN QUERY
SELECT store.name AS store, product.name AS product, brand.name AS brand, category.name AS category, item.id AS id, item.price AS price, item.size AS size, unit.name AS unit, item.ppu AS ppu, item.vegan AS vegan, item.product_unavailable AS p_un, item.brand_unavailable AS b_un, item.histlow AS histlow, user_item.taste AS taste, user_item.nutrition AS nutrition, user_item.notes AS notes, location.id AS location_id
FROM item
LEFT JOIN location on location.id = item.location
LEFT JOIN store ON store.id = location.store
LEFT JOIN brand ON brand.id = item.brand
LEFT JOIN product ON product.id = item.product
LEFT JOIN unit ON unit.id = item.unit
LEFT JOIN category ON category.id = product.category
LEFT JOIN user_item ON user_item.item_id = item.id AND user_item.user_id = this_user
WHERE location.id = ANY (locations)
AND product.name = ANY(plist::text[])
AND item.ppu = (SELECT MIN(i2.ppu) FROM item AS i2 WHERE i2.product = product.id) 
ORDER BY store.name, category.name, product.name; END; $BODY$ LANGUAGE plpgsql;
