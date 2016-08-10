class Oauth2::ApplicationsController < Doorkeeper::ApplicationsController
  include CheckUserConfirmation
  include HttpBasicAuthenticate
  include Locale
  include Theme

end
