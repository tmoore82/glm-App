CREATE OR REPLACE FUNCTION insert_new_item(i_location integer, i_p_un boolean, i_brand text, i_b_un boolean, i_category integer, i_price real, i_size real, i_unit integer, i_vegan boolean, i_taste integer, i_nutrition integer, i_notes text, i_user integer)
  RETURNS void AS
$BODY$
BEGIN
	IF i_p_un THEN
		INSERT INTO item (location, product_unavailable, brand, category, price, size, ppu, unit, histlow, vegan)
		VALUES (i_location, true, 16, 14, 0, 0, 0, 7, 0, i_vegan);
	ELSEIF i_b_un THEN
		INSERT INTO item (location, brand_unavailable, brand, category, price, size, ppu, unit, histlow, vegan)
		VALUES (i_location, true, (SELECT brand.id FROM brand WHERE brand.name = i_brand), 14, 0, 0, 0, 7, 0, i_vegan);
	ELSE
		INSERT INTO item (location, brand, category, price, size, ppu, unit, type, histlow, vegan) 
		VALUES (i_category, i_price, i_size, (i_price / i_size), i_unit, i_type, i_price, i_vegan);
	END IF;
	INSERT INTO user_item (user_id, item_id, taste, nutrition, notes)
	VALUES (i_user, i_item, i_taste, i_nutrition, i_notes);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION insert_new_item(integer, boolean, text, boolean, integer, real, real, integer, boolean, integer, integer, text, integer)
  OWNER TO postgres;

