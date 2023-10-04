ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :country, :score

  filter :name
  filter :country

  filter :score_gt, as: :number
  filter :score_lt, as: :number


  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :country, :score]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  def by_score_range

  end
end
