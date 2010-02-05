class Views::Ninjas::Show < Views::Layouts::Application
  def render_content
    ul :class => 'ninja_info' do
      li @ninja.name, :class => 'name'
      li :class => 'status' do
        text "Status: "
        span @ninja.status, :class => @ninja.status
      end
      li :class => 'master' do
        text "Master: "
        link_to @ninja.user.login, @ninja.user
      end
    end
    link_to "Retire this ninja", retire_ninja_path(@ninja), :method => :put if @ninja.active
  end
end
