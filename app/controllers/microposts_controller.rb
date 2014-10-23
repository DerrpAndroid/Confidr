class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    response = Unirest.post "http://sentiment.vivekn.com/api/text/",
                            headers:{
                                "Content-Type" => "application/x-www-form-urlencoded"
                            },
                            parameters:{
                                "txt" => @micropost.content
                            }
    @micropost.senti=response.body['result']['sentiment']
    if @micropost.save
      flash[:success] = "Micropost created!"
      puts response.body['result']['sentiment']
      redirect_to current_user
    else
      render 'users/show'
    end
  end

  def destroy
  end
  private

  def micropost_params
    params.require(:micropost).permit(:content,:title,:tag,:senti)
  end
end