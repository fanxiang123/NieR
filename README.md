# README

查看是否成功
EDITOR=vim rails credentials:edit

生成密钥
rails secret

允许assets
rake assets:precompile


class Api::V2::IntegralsController < ApplicationAppController

  swagger_controller :integral, 'v2积分系列接口'

  swagger_api :get_integral do
    summary 'v2查看积分'
    param :form, 'conversion_name', :string, :required, '当前平台/else为通用平台'
    param :header, 'User-token', :string, :required, 'User-token'
    param :header, 'Authorization', :string, :required, 'auth_token'
  end
  def get_integral
    e_user = check_user_token

    conversion = Conversion.find_by(conversion_name: params[:conversion_name])

    unless conversion.present?
      conversion = Conversion.find_by(conversion_name: 'else')
    end

    if e_user != 'false'
      num = total_integral(e_user.id)
      e_user.e_integral = num
      e_user.save

      user_conversion = Integral.find_by_sql(" select
        (select count(*) from integrals where i_type = 0 and e_user_id =
        #{e_user.id} and created_at>='#{Time.now.midnight}' and created_at<=
        '#{1.day.since.beginning_of_day}')as user_sign_num,
        (select count(*) from integrals where i_type = 5 and e_user_id =
        #{e_user.id}')as share_app_num,
        (select count(*) from integrals where i_type = 1 and e_user_id =
        #{e_user.id} and created_at>='#{Time.now.midnight}' and created_at<=
        '#{1.day.since.beginning_of_day}')as transcribe_num,
        (select count(*) from integrals where i_type = 2 and e_user_id =
        #{e_user.id} and created_at>='#{Time.now.midnight}' and created_at<=
        '#{1.day.since.beginning_of_day}')as advertis_num")

      conversion_mod = ConversionModel.new(num, conversion, user_conversion[0])

    else
      user_conversion = nil
      conversion_mod = ConversionModel.new(0, conversion, user_conversion)
    end

    render json: Result.new(0000, '', conversion_mod), status: 200
  rescue Exception => err
    logger.error "查看积分:#{err.message}"
    render json: {code: 4444, msg: '服务错误' + err.message}, status: 200
  end

end

