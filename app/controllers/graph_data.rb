module GraphData

  def graph_1_1(period, start_date, end_date)
    @columns_name = "註冊數量"
    @columns      = [["時間"],["Google註冊數量"],["Facebook註冊數量"],["裝置配對數量"]]
    @data1        = User.select("date(created_at) as create_date","#{period} as time_axis","count(*) as value_count").where(created_at: start_date..end_date).group(period).order(:created_at)
    @data2        = Identity.select("date(created_at) as create_date","#{period} as time_axis", "count(*) as value_count").where(created_at: start_date..end_date).group(period).order(:created_at)
    @data3        = Device.select("date(created_at) as create_date","#{period} as time_axis", "count(*) as value_count").where(created_at: start_date..end_date).group(period).order(:created_at)
    return [@columns_name, @columns, @data1, @data2, @data3]
  end

  def graph_1_2(period, start_date, end_date)
    @columns_name = "Oauth註冊數量"
    @columns      = [["時間"],["Google註冊數量"],["Facebook註冊數量"]]
    @data1        = Identity.select("date(created_at) as create_date","#{period} as time_axis", "count(*) as value_count").where(created_at: start_date..end_date, provider: "google_oauth2").group(period).order(:created_at)
    @data2        = Identity.select("date(created_at) as create_date","#{period} as time_axis", "count(*) as value_count").where(created_at: start_date..end_date, provider: "facebook").group(period).order(:created_at)
    return [@columns_name, @columns, @data1, @data2]
  end

  def graph_1_3(period, start_date, end_date)
    # @columns_name = ""
    # @columns      = []
    # @data1        =
    # @data2        =
    # @data3        =
    # return [@columns_name, @columns, @data1, @data2, @data3]
  end

  def graph_3_3(period, start_date, end_date)
    @columns_name = "帳號與設備數量統計表"
    @columns = [["帳號配對裝置數"],["帳號數"]]
    pairings = Pairing.joins(device: :product)
    user_pairing_amount = Pairing.joins(device: :product).select('user_id', 'count(*) as pairing_count').group('user_id')
    value_hash = {}
    user_pairing_amount.each do |item|
      value_hash[item['pairing_count']] = 0 if value_hash[item['pairing_count']].blank?
      value_hash[item['pairing_count']] = value_hash[item['pairing_count']] + 1
    end
    @data1 = []
    value_hash.map do | user_pairing_device_count ,user_count |
      @data1 << { 'product_model' => user_pairing_device_count, 'value_count' => user_count }
    end
    return [@columns_name, @columns, @data1]
  end

  def graph_5_1(period, start_date, end_date)
    @columns_name = "使用分享功能的NAS總數量 & NAS總數量 (依Model區分)"
    @columns = [["Model"],["使用分享功能的NAS數量"],["NAS數量"]]
    accepted_users = AcceptedUser.joins(invitation: { device: :product })
    pairings = Pairing.joins(device: :product)
    @data1 = accepted_users.select('model_class_name as product_model', 'count(distinct device_id) as value_count').group('model_class_name')
    @data2 = pairings.select('model_class_name as product_model', 'count(*) as value_count').group('model_class_name')
    return [@columns_name, @columns, @data1, @data2]
  end

  def graph_5_2(period, start_date, end_date)
    @columns_name = "使用分享功能的NAS數量 & 分享人數 (依Model區分)"
    @columns = [["Model"],["使用分享功能的NAS數量"],["分享人數"]]
    accepted_users = AcceptedUser.joins(invitation: { device: :product })
    @data1 = accepted_users.select('model_class_name as product_model', 'count(distinct device_id) as value_count').group('model_class_name')
    @data2 = accepted_users.select('model_class_name as product_model', 'count(*) as value_count').group('model_class_name')
    return [@columns_name, @columns, @data1, @data2]
  end

  def graph_5_3(period="month(created_at)", start_date="2015-9-01", end_date="2015-11-01")
    @columns_name = "沒有NAS的被邀請者人數"
    @columns      = [["型號"],["沒有NAS的被邀請者人數"]]
    @data1 = Array.new
    #row[0] = name , row[1] = count
    sql = 'SELECT  `products`.name as `name` ,count( `accepted_users`.user_id )
            FROM `accepted_users`
              INNER JOIN `invitations` ON `accepted_users`.invitation_id =  `invitations`.id
              INNER JOIN `devices` ON  `invitations`.device_id = `devices`.id
              INNER JOIN `products` ON `devices`.product_id  = `products`.id
            WHERE `user_id` NOT IN ( SELECT `user_id` from `pairings` where 1 )
            GROUP BY name'
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array.each do |row|
      @data1 << { 'product_model' => row[0] , 'value_count' => row[1] }
    end
    return [@columns_name, @columns, @data1]
  end

  def graph_5_4(period="month(created_at)", start_date="2015-9-01", end_date="2015-11-01")
    @columns_name = "NAS 分享次數"
    @columns      = [["型號"],["分享次數"]]
    @data1 = Array.new
    #row[0] = name , row[1] = count
    sql = 'SELECT `products`.name as \'name\' ,  count( `invitations`.id ) as \'sum\'
            FROM `invitations`
              JOIN `devices` on `invitations`.device_id = `devices`.id
              JOIN `products` on `devices`.product_id = `products`.id
            WHERE 1
            GROUP BY name'
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array.each do |row|
      @data1 << { 'product_model' => row[0] , 'value_count' => row[1] }
    end
    return [@columns_name, @columns, @data1]
  end

  def graph_5_5(period="month(created_at)", start_date="2015-9-01", end_date="2015-11-01")
    @columns_name = "NAS 分享資料夾使用人數-邀請成功"
    @columns      = [["型號"],["分享資料夾使用人數-邀請成功"]]
    @data1 = Array.new
    #row[0] = name , row[1] = count
    sql = 'SELECT `products`.name as `name` , count( `accepted_users`.user_id ) as count
            FROM `accepted_users`
              INNER JOIN `invitations` ON `accepted_users`.invitation_id =  `invitations`.id
              INNER JOIN `devices` ON  `invitations`.device_id = `devices`.id
              INNER JOIN `products` ON `devices`.product_id  = `products`.id
            WHERE `accepted_users`.status = 1
            GROUP BY name'
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array.each do |row|
      @data1 << { 'product_model' => row[0] , 'value_count' => row[1] }
    end
    return [@columns_name, @columns, @data1]
  end

end