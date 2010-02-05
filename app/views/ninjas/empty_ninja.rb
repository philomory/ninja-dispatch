class Views::Ninjas::EmptyNinja < Erector::Widget
  needs :user, :parent
  def content
    puts "User: #{@user.inspect}"
    puts "Current_user: #{@parent.current_user.inspect}"
    if @user == @parent.current_user
      link_to "Train a Ninja!", new_user_ninja_path(@user)
    else
      nil
    end
  end
end