package glm::App;

use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Auth::Extensible;

use Template;

our $VERSION = '0.1';

get '/logout' => sub {

	app->destroy_session;
	set_flash('You are logged out.');
	redirect '/';

};

# get '/' => sub {
get '/' => require_login sub {
	
	my $sth = database->prepare('SELECT name FROM product', { RaiseError => 1 });
	$sth->execute();
	
	template 'create_list', {
		'products' => $sth->fetchall_hashref('name'),
	};

};

# post '/my-list' => sub {
post '/my-list' => require_login sub {

	my $glist = param "glist";
	#my @split_glist = split(/,/,$glist);

	#foreach my $item (@split_glist) {
	#	$item = '\'' . $item . '\'';
	#}

	#my $joined_glist = join(',',@split_glist);
	# return $joined_glist;

	#my $sth = database->prepare('SELECT store.name AS store, product.name As product, brand.name AS brand, category.name AS category, item.price AS price, item.size AS size, unit.name AS unit, item.ppu AS ppu FROM item LEFT JOIN location ON location.id = item.location LEFT JOIN store ON store.id = location.store LEFT JOIN brand ON brand.id = item.brand LEFT JOIN product ON product.id = item.product LEFT JOIN unit ON unit.id = item.unit LEFT JOIN category ON category.id = product.category WHERE location.id IN (1,2,3) AND product.name IN (' . $joined_glist . ') AND item.ppu = ( SELECT MIN(ppu) FROM item AS i2 WHERE i2.product = product.id) ORDER BY store.name, category.name, product.name', { RaiseError => 1 });

	my $sth = database->prepare('SELECT * FROM get_items(\'{' . $glist . '}\')', { RaiseError => 1} );

	$sth->execute();

	template 'my-list', {
		'items' => $sth->fetchall_hashref('product'),
	};

};

true;
