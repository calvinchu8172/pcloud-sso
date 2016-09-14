
# This module using methods of Warden::Test::Helpers such as "login_as", "logout",
# about these methods please check https://github.com/hassox/warden/wiki/Testing,
# about including Warden::Test::Helpers please check features/support/warden.rb.

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
    # the "login_as" method is a method of Warden::Test::Helpers,
    # about "login_as" method please check https://github.com/hassox/warden/wiki/Testing,
    login_as(user, scope: :user)
  end

  def self.create_and_confirm(user = nil)
    user = user.nil? ? FactoryGirl.create(:user) : user
    user.confirmed_at = Time.now.utc
    user.confirmation_token = Devise.friendly_token
    user.confirmation_sent_at = Time.now.utc
    user.save
    user
  end

  def self.create_device(product_id = nil)
    create_product_table if Product.count == 0

    product_id ||= Product.first.id
    device = FactoryGirl.create(:device, product_id: product_id)
    device.save
    ip = "127.0.0.1"
    device.update_ip_list ip
    device.session['ip'] = ip
    device.session['xmpp_account'] = 'd' + device.mac_address.gsub(':', '-') + '-' + device.serial_number.gsub(/([^\w])/, '-')
    device.module_version['upnp'] = 2
    device.module_version['package'] = 1
    device.module_list << 'package'
    device.module_list << 'upnp'
    device.module_list << 'ddns'
    device
  end

  def self.create_product_table
    Product.create(id: 26, name: "NSA310S", model_class_name: "NSA310S", asset_file_name: "device_icon_gray_1bay.png", asset_content_type: "image/png", asset_file_size: 2497, asset_updated_at:  "2014-10-04 12:28:07", pairing_file_name: "animate_1bay.gif", pairing_content_type: "image/gif", pairing_file_size: 9711, pairing_updated_at: "2014-10-04 12:28:08")
    Product.create(id: 27, name: "NSA320S", model_class_name: "NSA320S", asset_file_name: "device_icon_gray_2bay.png", asset_content_type: "image/png", asset_file_size: 2412, asset_updated_at:  "2014-10-04 12:28:37", pairing_file_name: "animate_2bay.gif", pairing_content_type: "image/gif", pairing_file_size: 10116, pairing_updated_at: "2014-10-04 12:28:37")
    Product.create(id: 28, name: "NSA325", model_class_name: "NSA325", asset_file_name: "device_icon_gray_2bay.png", asset_content_type: "image/png", asset_file_size: 2412, asset_updated_at:  "2014-10-04 12:29:05", pairing_file_name: "animate_nsa325.gif", pairing_content_type: "image/gif", pairing_file_size: 12266, pairing_updated_at: "2014-10-04 12:29:06")
    Product.create(id: 29, name: "NSA325 v2", model_class_name: "NSA325 v2", asset_file_name: "device_icon_gray_2bay.png", asset_content_type: "image/png", asset_file_size: 2412, asset_updated_at:  "2014-10-04 12:29:41", pairing_file_name: "animate_2bay.gif", pairing_content_type: "image/gif", pairing_file_size: 10116, pairing_updated_at: "2014-10-04 12:29:41")
    Product.create(id: 30, name: "NAS540", model_class_name: "NAS540", asset_file_name: "device_icon_gray_4bay.png", asset_content_type: "image/png", asset_file_size: 2631, asset_updated_at:  "2014-10-04 12:29:59", pairing_file_name: "animate_4bay.gif", pairing_content_type: "image/gif", pairing_file_size: 9495, pairing_updated_at: "2014-10-04 12:29:59")
    Domain.create(domain_name: Settings.environments.ddns) if Domain.count == 0
  end

  def self.create_device_and_xmpp
    device = create_device
    xmpp_user = XmppUser.find_or_create_by(username: device.session['xmpp_account'], password: 'password')
    xmpp_user.session = device.id
    device
  end

  def self.create_and_signin
    user = create_and_confirm
    signin_user(user)
    user
  end
  def self.create_pairing(user_id, device = nil)
    device ||= create_device
    pairing = FactoryGirl.create(:pairing, user_id: user_id, device_id: device.id)
    pairing
  end

  def self.create_invitation(user, device, share_point = "fake_share", permission = "RW", expire_count = 5)
    cloud_id = user.encoded_id
    invitation_key =  cloud_id + share_point + device.id.to_s + Time.now.to_s
    #加密
    #require 'digest/hmac'
    #Digest::HMAC.hexdigest(invitation_key, "hash key", Digest::SHA1)
    invitation_key = Digest::HMAC.hexdigest(invitation_key, "hash key", Digest::SHA1).to_s
    invitation = Invitation.new( :key => invitation_key, :share_point => share_point, :permission => permission, :device_id => device.id, :expire_count => expire_count )
    invitation.save
    invitation
  end

  def self.create_ddns(device, ip)
    device.ddns = Ddns.create(
      device_id: device.id,
      ip_address: ip,
      domain_id: Domain.first.id,
      hostname: "test_hostname_#{device.id}"
      )
  end

  def self.create_app_signined_tokens_for_user(user_id)
    auth_token_str = SecureRandom.urlsafe_base64(nil, false)
    auth_token = Redis::Value.new("user:#{user_id}:authentication_token:#{auth_token_str}")
    auth_token.value = (DateTime.now + Api::User::AUTHENTICATION_TOKEN_TTL).to_s
    ### set the redis expire time of authentication token
    auth_token.expireat(auth_token.value.to_i)

    account_token_str = SecureRandom.urlsafe_base64(nil, false)
    account_token_key = "user:#{user_id}:account_token:#{account_token_str}"
    account_token = Redis::HashKey.new(account_token_key)
    account_token.bulk_set('expire_at' => (DateTime.now + Api::User::ACCOUNT_TOKEN_TTL).to_s, 'authentication_token' => auth_token_str)
    ### set the redis expire time of account token
    account_token.expireat(account_token.get('expire_at').to_i)
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

When(/^the user click on "(.*?)"$/) do |link_or_button|
  click_on link_or_button
end

When(/^the user have other devices$/) do
  @other_paired = TestingHelper.create_pairing(@user.id)
end

Given(/^the user have a paired device$/) do
  @user = TestingHelper.create_and_signin
  @pairing = TestingHelper.create_pairing(@user.id)
end

When(/^the user's session is expired$/) do 
  # the "logout" method is a method of Warden::Test::Helpers,
  # about "logout" method please check https://github.com/hassox/warden/wiki/Testing,
  logout
end

When(/^the user want to click link without cancel$/) do
  find("h1.header_h1_rwd > a").click
  find("a.member").click
  find("a.sign_out").click
  find("a.btn_tab_color1").click
  find("a.btn_tab_color2").click
end

Given(/^the device has "(.*?)" module$/) do |module_name|
  expect(@device.find_module_list.include?(module_name)).to be(true)
end

Then(/^the user will redirect to My Devices page$/) do
  expect(page.current_path).to eq "/personal/index"
end

def wait_server_response(time = 5)
  sleep time.to_i
end