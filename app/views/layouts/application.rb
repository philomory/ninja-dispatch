class Erector::Widget
  include ActionController::UrlWriter
end

class Views::Layouts::Application < Erector::Widgets::Page
  
  attr_accessor :template_content
  
  def body_content
    div :class => 'user_bar' do
      render_userbar
    end
    div :class => 'flash' do
      render_flash
    end
    div :class => 'content' do
      render_content
    end
  end
  
  def render_flash
    p flash[:notice], :style => 'color: green'
  end
  
  def render_userbar
    render :partial => 'users/user_bar'
  end
  
  def render_content
    text raw @template_content
  end
  
end