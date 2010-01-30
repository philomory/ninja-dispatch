class Views::Users::Show < Views::Layouts::Application
  def render_body

    h1 "Profile for #{@user.login}"

    div do
      @user.ninjas.each do |ninja|
        p ninja.name
      end
    end
  end
end