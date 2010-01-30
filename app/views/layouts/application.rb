class Views::Layouts::Application < Erector::Widgets::Page
  
  attr_accessor :template_content
  
  def body_content
    render_userbar
    render_body
  end
  
  def render_userbar
    render :partial => 'users/user_bar'
  end
  
  def render_body
    text raw @template_content
  end
  
end