CREATE OR REPLACE FUNCTION update_x_item(i_item integer, i_location integer, i_p_un boolean, i_brand text, i_b_un boolean, i_category integer, i_price real, i_size real, i_unit integer, i_histlow real, i_vegan boolean, i_taste integer, i_nutrition integer, i_notes text, i_user integer)
  RETURNS void AS
$BODY$
BEGIN
IF i_p_un THEN
UPDATE item 
SET location = i_location,
product_unavailable = true,
brand = 16,
category = 14,
price = 0,
size = 0,
ppu = 0,
unit = 7,
histlow = 0,
vegan = i_vegan
WHERE id = i_item;
ELSEIF i_b_un THEN
UPDATE item 
SET location = i_location,
brand_unavailable = true,
brand = (SELECT brand.id FROM brand WHERE brand.name = i_brand),
category = 14,
price = 0,
size = 0,
ppu = 0,
unit = 7,
histlow = 0,
vegan = i_vegan
WHERE id = i_item;
ELSE
UPDATE item 
SET location = i_location,
brand = (SELECT brand.id FROM brand WHERE brand.name = i_brand),
category = i_category,
price = i_price,
size = i_size,
ppu = (i_price / i_size), 
unit = i_unit,
type = i_type,
histlow = (CASE WHEN (histlow <> 0 AND i_histlow < histlow) THEN i_histlow ELSE histlow END),
vegan = i_vegan
WHERE id = i_item;
END IF;
IF (SELECT EXISTS(SELECT 1 FROM user_item WHERE user_id = i_user AND item_id = i_item)) THEN
UPDATE user_item
SET taste = i_taste,
nutrition = i_nutrition,
notes = i_notes
WHERE user_id = i_user AND item_id = i_item;
ELSE
INSERT INTO user_item (user_id, item_id, taste, nutrition, notes) 
VALUES (i_user, i_item, i_taste, i_nutrition, i_notes);
END IF;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION update_x_item(integer, integer, boolean, text, boolean, integer, real, real, integer, real, boolean, integer, integer, text, integer)
  OWNER TO postgres;

