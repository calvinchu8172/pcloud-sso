class PersonalController < ApplicationController
  before_action :authenticate_user!

  def index

    @pairing = Pairing.owner.where(user_id: current_user.id)
    if @pairing.empty?
      @paired = false
      flash[:alert] = I18n.t("warnings.no_pairing_device") if current_user.sign_in_count > 1
      redirect_to "/discoverer/index"
    end
  end

  def profile
    @language = @locale_options.has_value?(current_user.language) ? @locale_options.key(current_user.language) : "English"
  end

  protected
    def get_info(pairing)
      device = pairing.device
      info_hash = Hash.new
      info_hash[:model_name] = device.product.model_name
      info_hash[:firmware_version] = device.firmware_version
      if device.ddns
        info_hash[:class_name] = "blue"
        # remove ddns domain name last dot
        info_hash[:title] = device.ddns.hostname + "." + Settings.environments.ddns.chomp('.')
        info_hash[:ip] = device.ddns.get_ip_addr
        info_hash[:date] = device.ddns.updated_at.strftime("%Y/%m/%d")
      else
        info_hash[:class_name] = "gray"
        info_hash[:title] = I18n.t("warnings.not_config")
        info_hash[:ip] = device.session.hget :ip
      end
      info_hash
    end
    helper_method :get_info
end
