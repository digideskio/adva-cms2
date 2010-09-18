class User::Confirmations::New < User::Form
  def to_html
    h2 :'.title'
    super
  end

  def fields
    form.input :email
  end

  def form_arguments
    [resource, { :as => resource_name, :url => confirmation_path(resource_name) }]
  end
end