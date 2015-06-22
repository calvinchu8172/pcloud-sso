When(/^client send a POST request to \/user\/1\/confirmation$/) do
  path = '//' + Settings.environments.api_domain + "/user/1/confirmation"

  email = @user ? @user.email : "example@ecoworkinc.com"
  post path, email: email

end