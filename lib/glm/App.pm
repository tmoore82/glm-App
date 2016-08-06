package glm::App;

use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Auth::Extensible;

use Template;

our $VERSION = '0.1';

our @locations = (1, 2, 3);

our $this_user = 3;

our $sesh_glist = '';

our $sesh_newList = '';

get '/logout' => sub {

	app->destroy_session;
	set_flash('You are logged out.');
	redirect '/';

};

get '/' => sub {
#get '/' => require_login sub {
	
	my $sth = database->prepare('SELECT name FROM product', { RaiseError => 1 });
	$sth->execute();
	
	template 'create_list', {
		'products' => $sth->fetchall_hashref('name'),
	};

};

post '/my-list' => sub {
#post '/my-list' => require_login sub {

	my $glist = '';
	my $newList = '';

	if (param('glist') eq 'empty') {
		$glist = $sesh_glist;
		$newList = $sesh_newList;
	} else {
		$glist = param "glist";
		$newList = param "newList";
	}

	my @newList = split(',',$newList);
	my $locations = join(",",@locations);

	my $sth_glist = database->prepare('SELECT * FROM get_items(\'{' . $glist . '}\',\'{' . $locations . '}\',' . $this_user .')', { RaiseError => 1} );

	$sth_glist->execute();

	my $sth_newList = database->prepare('SELECT addItems(\'{' . $newList . '}\')', { RaiseError => 1} );

	$sth_newList->execute();

	my $sth_catList = database->prepare('SELECT * FROM get_no_assoc(\'{' . $glist . $newList . '}\')', {RaiseError => 1} );

	$sth_catList->execute();

	template 'my-list', {
		'items' => $sth_glist->fetchall_hashref('product'),
		'newItems' => \@newList,
		'noAssoc' => $sth_catList->fetchall_hashref('names'),
	};

};

get '/my-list' => sub {
	template 'my-list-after-update', {};
};

get '/update-item' => sub {
#get '/update-item' => require_login sub {

	my $id = param "id";	
	my $store = param "store";
	my $product = param "product";
	my $brand = param "brand";
	my $category = param "category";
	my $price = param "price";
	my $size = param "size";
	my $unit = param "unit";
	my $ppu = param "ppu";
	my $vegan = param "vegan";
	my $p_un = param "p_un";
	my $b_un = param "b_un";
	my $histlow = param "histlow";	
	my $taste = param "taste";
	my $nutrition = param "nutrition";
	my $notes = param "notes";
	my $location = param "location";
	my $is_new = param "is_new";

	my $locations = join(",",@locations);

	my $sth_locations = database->prepare('SELECT * FROM get_locations(\'{' . $locations . '}\')', { RaiseError => 1 } );

	$sth_locations->execute();

	my $sth_brand = database->prepare('SELECT * FROM brand', { RaiseError => 1 } );

	$sth_brand->execute();

	my $sth_categories = database->prepare('SELECT * FROM category', { RaiseError => 1 } );

	$sth_categories->execute();

	my $sth_units = database->prepare('SELECT * FROM unit', { RaiseError => 1 } );

	$sth_units->execute();

	my $sth_types = database->prepare('SELECT * FROM type', { RaiseError => 1 } );

	$sth_types->execute();

	template 'update-item', {
		'locations' => $sth_locations->fetchall_hashref('id'),
		'brands' => $sth_brand->fetchall_hashref('id'),
		'categories' => $sth_categories->fetchall_hashref('id'),
		'units' => $sth_units->fetchall_hashref('id'),
		'types' => $sth_types->fetchall_hashref('id'),
		'i_item' => $id,
		'i_store' => $store,
		'i_product' => $product,
		'i_brand' => $brand,
		'i_category' => $category,
		'i_price' => $price,
		'i_size' => $size,
		'i_unit' => $unit,
		'i_ppu' => $ppu,
		'i_vegan' => $vegan,
		'i_p_un' => $p_un,
		'i_b_un' => $b_un,
		'i_histlow' => $histlow,
		'i_taste' => $taste,
		'i_nutrition' => $nutrition,
		'i_notes' => $notes,
		'i_location' => $location,
		'is_new' => $is_new,
	};

};

post '/process-item' => sub {
#post '/process-item' => require_login sub {

	my $is_new = param "is_new";	
	my $item = param "item";	
	my $product = param "product";	
	my $location = param "location";
	my $p_un = param "p_un";
	my $brand = param "brand";
	my $b_un = param "b_un";
	my $category = param "category";
	my $price = param "price";
	my $size = param "size";
	my $unit = param "unit";
	my $vegan = param "vegan";	
	my $type = param "type";
	my $histlow = param "histlow";	
	my $taste = param "taste";
	my $nutrition = param "nutrition";
	my $notes = param "notes";
	my $user = $this_user;

	if ($is_new) {
		my $sth_new = database->prepare('SELECT * FROM insert_new_item(' . $product. ',' . $location . ',' . $p_un . ',' . $brand . ',' . $b_un . ',' . $category . ',' . $price . ',' . $size . ',' . $unit . ',' . $vegan . ',' . $taste . ',' . $nutrition . ',' . $notes . ',' . $user . ')', { RaiseError => 1 } );

		$sth_new->execute();

	} else {
		my $sth_update = database->prepare('SELECT * FROM update_x_item(' . $item . ',' . $location . ',' . $p_un . ',' . $brand . ',' . $b_un . ',' . $category . ',' . $price . ',' . $size . ',' . $unit . ',' . $histlow . ',' . $vegan . ',' . $taste . ',' . $nutrition . ',' . $notes . ',' . $user . ')', { RaiseError => 1 } );

		$sth_update->execute();
	}

	redirect '/my-list';
	
};

true;
