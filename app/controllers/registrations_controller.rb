class RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource_or_scope)
     new_simulation_url
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :budget, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :budget, :email, :password, :password_confirmation, :current_password)
  end
end
