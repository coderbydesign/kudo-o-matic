class UserDecorator < Draper::Decorator
  delegate_all

  def name
    if object.restricted?
      'Hidden'
    else
      object.name
    end
  end
end
