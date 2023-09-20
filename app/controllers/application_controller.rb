class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後、ルートパスに飛ばす
  def after_sign_in_path_for(source)
    root_path
  end

  # 新規登録後、ルートパスに飛ばす
  def after_sign_up_path_for(source)
    root_path
  end

  private

    # カスタムパラメーター（ユーザーネーム）を許可
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(sign_up, keys: [:name])
    end

end
