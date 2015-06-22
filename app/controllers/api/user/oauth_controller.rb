# Oauth API for mobile
# 主要參數如下:
# user_id: oauth provider提供的uuid
# access_token: oauth prodier提供的token
# data: 透過access_token及"get_oauth_data"方法取得使用者資料
# user: identity所綁定的使用者，而且需要注意使用者可變更email
# is_portal_user? : 為portal第一階段未綁定密碼
class Api::User::OauthController < Api::Base
  before_action :adjust_provider, only: [:mobile_checkin, :mobile_register]

  # GET /user/1/checkin/:oauth_provider
  def mobile_checkin
    user_id  = checkin_params[:user_id]
    access_token = checkin_params[:access_token]

    data = get_oauth_data(@provider, user_id, access_token)
    return render :json => { :error_code => '000', :description => "Invalid #{params[:oauth_provider].capitalize} account" }, :status => 400 if data.nil? || data['email'].nil?

    identity = Identity.find_by(uid: data['id'], provider: @provider)
    return render :json => { :error_code => '001',  :description => 'unregistered' }, :status => 400 if identity.nil?

    user = identity.user
    return render :json => { :error_code => '002',  :description => 'not binding yet' }, :status => 400 if is_portal_user?(user)

    return render :json => { :result => 'registered', :account => user.email }, :status => 200

  end

  # POST /user/1/register/:oauth_provider
  # 邏輯行為如下:
  # 1. 透過identity查詢使用者是否存在，若使用者不存在則直接建立user
  # 2. 承2，若使用者存在則判斷過去是否為portal oauth，若屬portal使用者即更新密碼
  # 3. 最後建立identity並登入
  # signature data: certificate_serial + user_id + access_token
  def mobile_register
    certificate_serial = register_params[:certificate_serial]
    user_id            = register_params[:user_id]
    password           = register_params[:password]
    access_token       = register_params[:access_token]
    signature          = register_params[:signature]

    return render :json => { :error_code => '002',  :description => 'Password has to be 8-14 characters length' }, :status => 400 if password.nil? || !password.length.between?(8, 14)

    data = get_oauth_data(@provider, user_id, access_token)
    return render :json => { :error_code => '001', :description => "Invalid #{params[:oauth_provider].capitalize} account" }, :status => 400 if data.nil?

    identity = Identity.find_by(uid: data['id'], provider: @provider)
    user = identity.present? ? identity.user : Api::User::OauthUser.find_by(email: data['email'])

    if user.nil?
      user = Api::User::OauthUser.new(register_params)
      user.email = data['email']
      user.agreement = "1"
      user.confirmation_token = Devise.friendly_token
      user.confirmed_at = Time.now.utc

      unless user.save
        logger.debug 'Oauth user not save'
        return render :json => Api::User::INVALID_SIGNATURE_ERROR unless user.errors['signature'].empty?
      end
    end

    if is_portal_user?(user)
      user = Api::User::OauthUser.find(user)
      user.confirmation_token = Devise.friendly_token
      user.confirmed_at = Time.now.utc

      unless user.update(register_params)
        logger.debug 'Oauth portal user not save'
        return render :json => Api::User::INVALID_SIGNATURE_ERROR unless user.errors['signature'].empty?
      end
    else
      return render :json => { :error_code => '003',  :description => 'registered account' }, :status => 400 if identity.present?
    end

    if identity.nil?
      identity = Api::User::Identity.new(register_params.except(:password, :app_key, :os))
      identity.provider = @provider
      identity["user_id"] = user.id
      identity.uid = data['id']

      unless identity.save
        logger.debug 'Oauth identity not save'
        return render :json => Api::User::INVALID_SIGNATURE_ERROR unless identity.errors['signature'].empty?
      end
    end

    token = Api::User::Token.new(id: user.id ,email: data['email'], certificate_serial: certificate_serial)
    token.app_key = register_params[:app_key]
    token.os = register_params[:os]
    token.create_token


    sign_in(:user, user, store: false, bypass: false)
    redirect_to authenticated_root_path
  end

  def get_oauth_data(provider, user_id, access_token)
    begin
      data = RestClient.get('https://www.googleapis.com/oauth2/v1/userinfo', :params => {:access_token => access_token}) if provider == 'google_oauth2'
      data = RestClient.get('https://graph.facebook.com/v2.3/me', :params => {:access_token => access_token}) if provider == 'facebook'
      data = JSON.parse data
      data
    rescue Exception => e
      logger.debug "Invalid oauth token"
      logger.debug e.response
      data = nil
    end
  end

  def is_portal_user?(user)
    user.confirmation_token.nil?
  end

  private

  def register_params
    params.permit(:access_token, :user_id, :password, :certificate_serial, :signature, :app_key, :os)
  end

  def checkin_params
    params.permit(:access_token, :user_id)
  end

  def adjust_provider
    if !['google', 'facebook'].include?(params[:oauth_provider])
      render :file => 'public/404.html', :status => :not_found, :layout => false
    else
      @provider = 'google_oauth2' if params[:oauth_provider] == 'google'

      @provider ||=  params[:oauth_provider]
    end
  end
end