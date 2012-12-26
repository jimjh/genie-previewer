base_path = 'aladdin/render/templates/'
%w(template header image problem multi short table navigation).each { |f| require base_path + f }
