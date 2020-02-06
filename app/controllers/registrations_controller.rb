class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      render json: resource, status: :created, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: resource.errors.to_json, status: :unauthorized
    end
  end

  def update
    resource = current_user
    resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = resource.update(account_update_params)
    if resource_updated

      render json: resource, status: :ok, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: resource.errors.to_json, status: :unauthorized
    end
  end
end
