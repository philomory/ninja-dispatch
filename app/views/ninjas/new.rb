class Views::Ninjas::New < Views::Layouts::Application
  def render_content
    h1 'Train a Ninja'
    form_for([:user,@ninja]) do |ninja_form|
      ninja_form.error_messages
      p do
        ninja_form.label :name, "Name"
        br
        ninja_form.text_field :name
      end
      p do
        ninja_form.submit "Train Ninja"
      end
    end
  end
end
