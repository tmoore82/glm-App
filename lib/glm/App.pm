package glm::App;

use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Auth::Extensible;

use Template;

our $VERSION = '0.1';

our @locations = (1, 2, 3);

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

	my $glist = param "glist";
	my $newList = param "newList";
	my @newList = split(',',$newList);

	my $sth_glist = database->prepare('SELECT * FROM get_items(\'{' . $glist . '}\')', { RaiseError => 1} );

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

	my $locations = join(",",@locations);

	my $sth_locations = database->prepare('SELECT * FROM get_locations(\'{' . $locations . '}\')', { RaiseError => 1} );

	$sth_locations->execute();

	my $sth_brand = database->prepare('SELECT * FROM brand', { RaiseError => 1} );

	$sth_brand->execute();

	my $sth_units = database->prepare('SELECT * FROM unit', { RaiseError => 1} );

	$sth_units->execute();

	my $sth_types = database->prepare('SELECT * FROM type', { RaiseError => 1} );

	$sth_types->execute();

	template 'update-item', {
		'locations' => $sth_locations->fetchall_hashref('id'),
		'brands' => $sth_brand->fetchall_hashref('id'),
		'units' => $sth_units->fetchall_hashref('id'),
		'types' => $sth_types->fetchall_hashref('id'),
		'i_id' => $id,
		'i_store' => $store,
		'i_product' => $product,
		'i_brand' => $brand,
		'i_category' => $category,
		'i_price' => $price,
		'i_size' => $size,
		'i_unit' => $unit,
	};

};
true;
