# = Class: ifttt::web
# Sets up a uwsgi based web server for the Wikimedia IFTTT service
class ifttt::web(
    $workers_per_core = 4,
) {
    require ifttt::base

    uwsgi::app { 'ifttt':
        service_settings => '--die-on-term --autoload',
        settings         => {
            uwsgi => {
                plugins     => 'python',
                'wsgi-file' => "${ifttt::base::source_path}/app.py",
                callable    => 'app',
                master      => true,
                chdir       => $ifttt::base::source_path,
                http-socket => '0.0.0.0:8080',
                venv        => $ifttt::base::venv_path,
                processes   => $facts['processorcount'] * $workers_per_core,
            }
        }
    }
}
