class Views::Users::Ancestors < Views::Layouts::Application
  def render_content
    render :partial => 'sortable/table'
  end
end