class Views::Users::Show < Views::Layouts::Application
  def render_content

    h1 "Profile for #{@user.login}"

    div :class => 'ninjas' do
      @user.ninjas.each do |ninja|
        div :class => :ninja, :id => ninja.id do
          link_to ninja.name, ninja
        end
      end
      (3-@user.ninjas.size).times do |index|
        div :class => :ninja, :id => "empty-ninja-#{index}" do
          Views::Ninjas::EmptyNinja.new(:user => @user, :parent => @parent).to_s
        end
      end
    end
    br
    link_to "Ancestors", @parent.user_ancestors_url(@user)
    
  end
end