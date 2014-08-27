include Warden::Test::Helpers
Warden.test_mode!

module TestingHelper
  def self.setup_test_email
    # make your delivery state to 'test' mode
    ActionMailer::Base.delivery_method = :test
    # make sure that actionMailer perform an email delivery
    ActionMailer::Base.perform_deliveries = true
    # clear all the email deliveries, so we can easily checking the new ones
    ActionMailer::Base.deliveries.clear
  end
  def self.signin_user(user)
    login_as(user, scope: :user)
  end
  def self.create_and_confirm
    user = FactoryGirl.create(:user)
    user.confirm!
    user.save
    user
  end
  def self.create_device
    device = FactoryGirl.create(:device)
    device.save
    device
  end
  def self.create_and_signin
    user = create_and_confirm
    signin_user(user)
    user
  end
  def self.create_device_session
    device = create_device
    device_session = FactoryGirl.create(:device_session, device_id: device.id)
    device_session.save
    device_session
  end
  def self.create_pairing_session
    device_session = create_device_session
    user = create_and_signin
    pairing_session = FactoryGirl.create(:pairing_session, user_id: user.id,
      device_id: device_session.device.id)
    pairing_session.save
    pairing_session
  end
end

# Click submit button
When(/^the user click "(.*?)" button$/) do |button|
  click_button button
end

# Click link
When(/^the user click "(.*?)" link$/) do |link|
  click_link link
end

When(/^the user finished the pairing$/) do
  @pairing = create_pairing(@device_session, @user)
end

# set pairing, need current @device_session & @user
def create_pairing(device_session, user)
  device_id = device_session.device.id
  user_id = user.id
  pairing = FactoryGirl.create(:pairing, user_id: user_id, device_id: device_id)
  pairing.save
  pairing
end

def wait_server_response
  sleep(5)
end