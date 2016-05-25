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

	my $sth = database->prepare('SELECT * FROM get_items(\'{' . $glist . '}\')', { RaiseError => 1} );

	$sth->execute();

	template 'my-list', {
		'items' => $sth->fetchall_hashref('product'),
	};

};

true;
