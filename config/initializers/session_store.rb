# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ninja_dispatch_session',
  :secret      => '29ac82ca3536988520ef896c7626265c78a0495753c69e72e33817118d864a75f3c23c2c01614c31e8729372937d3f108bbbed340cac21ae86228a79046c4ced'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
