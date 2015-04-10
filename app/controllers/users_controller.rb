class UsersController < ApplicationController
  #before_action :logged_in_user, only: [:index, :edit, :update, :destroy] removed because i added this in application_controller
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build if logged_in?
    @notifications=@user.notifications
    puts @notifications
    @noti_body= @microposts.pluck(:id).sample
    @body=Micropost.find_by_id(@noti_body)
    # puts @body
    # puts @notif
    @rand=rand(1..7)

    #following is for past/present/future
    @pastcount=Micropost.where(:tag => "moments").where(:user_id=>@user).count
    @presentcount=Micropost.where(:tag => "gratefulness").where(:user_id=>@user).count
    @futurecount=Micropost.where(:tag => "ambitions").where(:user_id=>@user).count
    @totalposts = @pastcount + @futurecount
    if(@pastcount == @futurecount)
      @happycounter = 50
    else
      @pastper = (@pastcount*100/@totalposts*100)
      @pastper=@pastper/100
      @futureper = (@futurecount*100/@totalposts*100)
      @futureper=@futureper/100
      if(@pastper>@futureper)
        @happycounter = 50 - (@pastper-@futureper)
      else
        @happycounter = 50 + (@futureper-@pastper)
      end
    end
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string'  , 'Label')
    data_table.new_column('number'  , 'Value')
    data_table.add_rows(1)
    data_table.set_cell(0, 0, 'Living in' )
    data_table.set_cell(0, 1, @happycounter)
    opts   = { :width => 600, :height => 120, :redFrom => 66, :redTo => 100, :yellowFrom => 33, :yellowTo => 66, :greenFrom => 33, :greenTo => 66,:minorTicks => 5 }
    @chart = GoogleVisualr::Interactive::Gauge.new(data_table, opts)
    #following is for how happy user is
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('number', 'Post')
    data_table.new_column('number', 'Feelings')
    @happy=Micropost.where(:user_id => @user).count
    data_table.add_rows(100)
    ic=0
    @totalwords=0
    Micropost.where(:user_id=>@user).find_each do |microposter|
      @totalwords+=microposter.content.length
      data_table.set_cell(ic, 0,  ic+1)
      if (ic==0)
        happa=microposter.happiness.to_i
      else
        happa=microposter.happiness.to_i
      end

      data_table.set_cell(ic,1, happa)
      ic+=1
    end
    if(ic!=0)
      @avg_post_lenght=@totalwords/ic #sends average post length
    end

    opts = { :width => 400, :height => 240, :title => 'Your Performance', :legend => 'bottom' }
    @chart1 = GoogleVisualr::Interactive::LineChart.new(data_table, opts)

    #sends most used tag
    cg = Micropost.group("tag").where(:tag=>'gratefulness').where(:user_id=>@user).count("tag")
    mo = Micropost.group("tag").where(:tag=>'moments').where(:user_id=>@user).count("tag")
    op = Micropost.group("tag").where(:tag=>'optimism').where(:user_id=>@user).count("tag")
    cs = Micropost.group("tag").where(:tag=>'consolation').where(:user_id=>@user).count("tag")
    le = Micropost.group("tag").where(:tag=>'lessons').where(:user_id=>@user).count("tag")
    ac = Micropost.group("tag").where(:tag=>'actualities').where(:user_id=>@user).count("tag")
    am = Micropost.group("tag").where(:tag=>'ambitions').where(:user_id=>@user).count("tag")
    ip = Micropost.group("tag").where(:tag=>'inspiration').where(:user_id=>@user).count("tag")
    @maxi=[cg,mo,op,cs,le,ac,am,ip].max_by {|x| x.count}

    #feel best with x hours of sleep- sented

    #@happysleep=Micropost.where(:user_id=>@user).group("happiness").order("sleephours DESC").first()
    @happysleep = Micropost.where(:user_id=>@user).where.not(:sleephours => nil).order(happiness: :asc).first().as_json

    #puts(@happysleep)

  end
  def edit
    @user = User.find(params[:id])
  end
  def next
    @micropost.next(self.id).first
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      puts ("submitted")
      flash[:success] = "Welcome to the Confidr!"
      log_in @user #replace with onboarding screen/video or whatever
      redirect_to @user
    else
      puts(@user.errors.full_messages )
      redirect_to :back
    end
  end
    private

      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end
end
