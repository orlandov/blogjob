package BlogJob;

use Catalyst::Runtime 5.80;
use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
                Authentication
                Markdown
                Session
                Session::Store::FastMmap
                Session::State::Cookie
                Static::Simple/;
our $VERSION = '0.01';
# __PACKAGE__->config->{Plugin::Authentication}{realms}{openid}{extension_args} = [
#     'http://openid.net/extensions/sreg/1.1',
#     {
#         required => 'email',
#         optional => [ qw( fullname nickname timezome ) ]
#     }
# ];
__PACKAGE__->config->{Plugin::Authentication} = {
    use_session => 1,
    default_realm => 'openid',
    realms => {
        openid => {
            credential => {
                class => 'OpenID',
                store => {
                    class => 'OpenID'
                }
             },
             extensions => {
                'http://openid.net/extensions/sreg/1.1' => 1
             },
             extension_args => [
                 'http://openid.net/extensions/sreg/1.1',
                 {
                     required => 'email,timezone',
                     optional => 'fullname,nickname,timezone'
                 }
             ]
         }
    }   
};
__PACKAGE__->setup();

1;
