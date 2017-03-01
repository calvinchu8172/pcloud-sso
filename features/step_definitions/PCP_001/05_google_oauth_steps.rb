# Given(/^a user visits home page$/) do
#   visit unauthenticated_root_path
# end

Given(/^the user was not a Google member$/) do
  set_google_omniauth
end

Given(/^the user was a Google member$/) do
  @user = TestingHelper.create_and_confirm
  @identity = FactoryGirl.create(:identity, user_id: @user.id, provider: "google_oauth2", uid: "1234")
  set_google_omniauth(@user.email)
end

When(/^the user click sign in with Google link and grant permission$/) do
  find(".btn-round.google").click
end

When(/^the user click sign in with Google link and not grant permission$/) do
  set_invalid_google_omniauth
  find(".btn-round.google").click
end

When(/^the user click sign in with Google link$/) do
  find(".btn-round.google").click
end

# Then(/^the user should see oauth feature "(.*?)" message$/) do |message|
#   expect(page.body).to have_content(message)
# end

# When(/^the user grant permission$/) do
#   # do nothing
# end

# When(/^the user visits profile page$/) do
#   # find("a.member").click
#   click_on "Profile"
# end

# Then(/^the omniauth user should not see change password link$/) do
#   expect(page).to have_no_link I18n.t("labels.change_password")
# end

# Then(/^the user will redirect to Terms of Use page$/) do
#   expect(page.current_path).to eq("/oauth/new")
# end

# Then(/^redirect to Welcome page$/) do
#   expect(page.current_path).to eq("/")
# end

# When(/^the user click Terms of Use page$/) do
#   find(:xpath, ".//input[@id='user_agreement']").set(true)
#   click_button "Confirm"
# end

# Then(/^the user should login$/) do
#   expect(page).to have_link I18n.t("labels.sign_out")
# end

# Then(/^redirect to My Devices\/Search Devices page$/) do
#   expect(page.current_path).to eq("/discoverer/index")
#   expect(page).to have_content("Successfully authenticated from Facebook account.")
# end

# Then(/^the user will redirect to editing password page$/) do
#   expect(page.current_path).to eq("/users/password/edit")
# end

# When(/^the user doesn't click Terms of Use page$/) do
#   find(:xpath, ".//input[@id='user_agreement']").set(false)
#   click_button "Confirm"
# end

# Then(/^user will stay in Terms of Use page$/) do
#   expect(page.current_path).to eq("/oauth/new")
# end

# Then(/^the user will see the warning message "(.*?)"$/) do |message|
#   expect(page.body).to have_content(message)
# end

def set_google_omniauth(email = "personal@example.com", opts = {})
  default = {provider: :google_oauth2,
             uuid:      "1234",
             google_oauth2: {
                         email: email,
                         gender: "male",
                         first_name: "eco",
                         last_name: "work",
                         name: "ecowork",
                         locale: "en"
                       }
            }

  credentials = default.merge(opts)
  provider = credentials[:provider]
  user_hash = credentials[provider]

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      "uid" => credentials[:uuid],
      "provider" => credentials[:provider],
      "info" => {
        "email" => user_hash[:email],
        "first_name" => user_hash[:first_name],
        "last_name" => user_hash[:last_name],
        "name" => user_hash[:name]
      },
      "extra" => {
        "raw_info" => {
          "gender" => user_hash[:gender],
          "locale" => user_hash[:locale]
        }
      }
  })
end

def set_invalid_google_omniauth(opts = {})

  credentials = { provider: :google_oauth2,
                  invalid: :invalid_crendentials
                 }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]

end
