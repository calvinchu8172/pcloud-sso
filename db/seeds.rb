# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'development'

  Product.create(id: 26, name: "NSA310S", model_class_name: "NSA310S", asset_file_name: "device_icon_gray_1bay.png", asset_content_type: "image/png", asset_file_size: 2497, asset_updated_at:  "2014-10-04 12:28:07", pairing_file_name: "animate_1bay.gif", pairing_content_type: "image/gif", pairing_file_size: 9711, pairing_updated_at: "2014-10-04 12:28:08")
  Product.create(id: 27, name: "NSA320S", model_class_name: "NSA320S", asset_file_name: "device_icon_gray_2bay.png", asset_content_type: "image/png", asset_file_size: 2412, asset_updated_at:  "2014-10-04 12:28:37", pairing_file_name: "animate_2bay.gif", pairing_content_type: "image/gif", pairing_file_size: 10116, pairing_updated_at: "2014-10-04 12:28:37")
  Product.create(id: 28, name: "NSA325", model_class_name: "NSA325", asset_file_name: "device_icon_gray_2bay.png", asset_content_type: "image/png", asset_file_size: 2412, asset_updated_at:  "2014-10-04 12:29:05", pairing_file_name: "animate_nsa325.gif", pairing_content_type: "image/gif", pairing_file_size: 12266, pairing_updated_at: "2014-10-04 12:29:06")
  Product.create(id: 29, name: "NSA325 v2", model_class_name: "NSA325 v2", asset_file_name: "device_icon_gray_2bay.png", asset_content_type: "image/png", asset_file_size: 2412, asset_updated_at:  "2014-10-04 12:29:41", pairing_file_name: "animate_2bay.gif", pairing_content_type: "image/gif", pairing_file_size: 10116, pairing_updated_at: "2014-10-04 12:29:41")
  Product.create(id: 30, name: "NAS540", model_class_name: "NAS540", asset_file_name: "device_icon_gray_4bay.png", asset_content_type: "image/png", asset_file_size: 2631, asset_updated_at:  "2014-10-04 12:29:59", pairing_file_name: "animate_4bay.gif", pairing_content_type: "image/gif", pairing_file_size: 9495, pairing_updated_at: "2014-10-04 12:29:59")
  Domain.create(domain_name: Settings.environments.ddns)
  Api::Certificate.create(serial: "example_serial", content:"-----BEGIN CERTIFICATE-----
  MIIGTzCCBDegAwIBAgICEAAwDQYJKoZIhvcNAQELBQAwgbExCzAJBgNVBAYTAlRX
  MQ8wDQYDVQQIDAZUYWl3YW4xEDAOBgNVBAcMB0hzaW5DaHUxIjAgBgNVBAoMGVp5
  WEVMIGNvbW11bmljYXRpb24gY29ycC4xGzAZBgNVBAsMEkNsb3VkIEFwcGxpYW5j
  ZSBCQzEYMBYGA1UEAwwPbXlaeVhFTENsb3VkIENBMSQwIgYJKoZIhvcNAQkBFhVj
  bG91ZGFkbUB6eXhlbC5jb20udHcwHhcNMTQxMDE0MDYwMjA5WhcNMTgxMDE0MDYw
  MjA5WjCBsDELMAkGA1UEBhMCVFcxDzANBgNVBAgMBlRhaXdhbjEQMA4GA1UEBwwH
  SHNpbkNodTEiMCAGA1UECgwZWnlYRUwgY29tbXVuaWNhdGlvbiBjb3JwLjENMAsG
  A1UECwwEQ0FCQzElMCMGA1UEAwwcbXlaeVhFTENsb3VkIGludGVybWVkaWF0ZSBD
  QTEkMCIGCSqGSIb3DQEJARYVY2xvdWRhZG1Aenl4ZWwuY29tLnR3MIICIjANBgkq
  hkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA3QNj4mwsBv49Zh7pDi1PDr0/HH9koD0J
  2rgLtUcr6vfoHiVrITSjPUMg0dK7ipRCajBbVJ+9Yq9kfs7ocBJjinhWqSrnzNUz
  nswqPTSw2aj0Xxau8f60GFmx74qDGPQeVkWWumXCZYdahUJOKADv2rvbcqsggd2p
  JE6hACuC7xco9W4Arvf+nNazrZjWwRy2y5hSjPe6IN8Y2gmufwRW8J9nzU1T72ox
  jMYbPMN38t2TAMTUIAZ08soRPdSj4Aj2hp/1cn4W7FECyJ3s+DGflHS96YqAPHsi
  fnqi/KsqIZ3c5xxCMsfuG7RFz8LNmf/GDxhotwktC965qgNxbr8xTNMreraAfKab
  njLaVkpNIVqlICjbZFTvPnwG1pJmnlluO0BkYp6t+f7d3/InQPyAkkiYoWmrj2yX
  wVTajWyRGSaD5T6rA/XIctZojrjDhjFoj9cnLBFScJLKTmqPOIOZKSL4uiKvrfqa
  YTO3ss8ggKvLceBSRx1dpmA3VwlvO4j5LEuL1S4dlXgyDGm8X/GSUcQ5kaPmqc6f
  CvbHuII+cnu+Kjbq18MSo4kjibnl2sfCCG7G2KsXsP5CDFHNWPr7JaOXLp7oumqv
  xSRklTwgl8etJBaKV7hV7tc8yEzmjxgbgqnC+H+wfpdQvgd1ZK3esHwEn3OD7zEp
  s14uS7Uc17MCAwEAAaNwMG4wHQYDVR0OBBYEFNBx+rl/NYLomZsDoTPHWCkHSH4m
  MB8GA1UdIwQYMBaAFO5whKEaDw2m/1Or3EfYXg8K12T6MAwGA1UdEwQFMAMBAf8w
  CwYDVR0PBAQDAgEGMBEGCWCGSAGG+EIBAQQEAwIBBjANBgkqhkiG9w0BAQsFAAOC
  AgEAG6+F5l8Mru6/R7y18W9H1zFBE6oQU+YiuI5PoUjdkjcKVFHOsgKifsyfJ4J/
  bVNvYhkijvDux139c3+JWm/SkxegTvRDl/SVwfe+XjE2wzMjgj/3ZNu/ZL92fAGh
  tXUuzkoCV5GzXeVsebgV+HoPkvIzrK+4ezyufyLr9PwuYYw20Ck0xr97IdvWVCbI
  gbHSjebUpKJ1/aV19wwpXrgw+VMSTe8Lrpt7WUxOinHBJ/zXrTYBqJyMhiklvDk5
  kfB99I3o01FZUuaegG2dnZC76Vtt4oGtkZx9SC/zLT/1coBCXsjPm/R54USfnU0r
  UgRKCX8g/s2tho1OHvDmoJyHI53oXEkFavA8lFk2nQfkalvLdKOMl0alApUE0ln2
  Lbe0aMOYnSzjXwROXhHa609xM5hDfobi7AxR6anvCZYldog4Hv8P7Mbo+Kx97+op
  ZuKh+4dcYPAe2yFn2lPxKGzlZvmw8yspVz3dPiGsKcY/kiAbdMq25mI90JP+/WrE
  tIgz6pXx38PwJah89///v9t70AKZCwjjOzm1fUFPMJKFAJD61Ua3iZY1Ek52L1dQ
  1nwKx710Ciup7F1PQFUky5JP7MD9HmE+cIbs5Df8rNrgSqjF3uDjASrA9qM91kkF
  znf3QDjNYZvULC96M8LxgZzvs/m1+ddXYNJ/lqDz4/3CovA=
  -----END CERTIFICATE-----
  ")

end


if Rails.env == 'test'

  sql = 'DROP DATABASE IF EXISTS mongooseim;'
  ActiveRecord::Base.connection.execute(sql)
  sql = 'CREATE DATABASE mongooseim;'
  ActiveRecord::Base.connection.execute(sql)
  sql = 'USE mongooseim;'
  ActiveRecord::Base.connection.execute(sql)
  sql = " CREATE TABLE `users` (
      `username` varchar(250) NOT NULL,
      `password` text NOT NULL,
      `pass_details` text,
      `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`username`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8; "
  ActiveRecord::Base.connection.execute(sql)

  sql = " CREATE TABLE `last` (
      `username` varchar(250) NOT NULL,
      `seconds` int(11) NOT NULL,
      `state` text NOT NULL,
      `last_signin_at` int(11),
      PRIMARY KEY (`username`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8; "
  ActiveRecord::Base.connection.execute(sql)
end
