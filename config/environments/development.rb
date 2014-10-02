# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
SITE_URL="esys.educacionchiapas.gob.mx"
REPORTS_DIR = "#{RAILS_ROOT}/app/reports"
SITE_EMAIL="plataforma.era@gmail.com"
CICLO_ESCOLAR="2013-2014"
BACKUPS_DIR="/home/era"
FECHA_FINAL_REGISTRO="2014-12-31"
FECHA_FINAL_DIAGNOSTICO="2014-12-31"
FECHA_FINAL_PROYECTO="2014-03-01"
CLAVE_SEGURIDAD="h9jqwo8h7s"