class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end


      wday_num = (@todays_date + x).wday
      
      if wday_num >= 7
        wday_num = wday_num - 7
      end
      # wday = wdays[(@todays_date + x).wday]
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[wday_num] }

      @week_days.push(days)
    end

  end
end


# plansの中身
# [<id=>3,plan=>テックキャンプ,date=>4/9>,<id=>4,plan=>旅行,date=>4/10>]

# today_plans
# [ 旅行]

# days{month=>4,date=>4,plans=>[]}

# @week_days
# [{month=>4,date=>4,plans=>[]},{month=>4,date=>5,plans=>[]},{month=>4,date=>6,plans=>[]},
# {month=>4,date=>7,plans=>[]},{month=>4,date=>8,plans=>[]},{month=>4,date=>9,plans=>[ テックキャンプ]},{month=>4,date=>10,plans=>[旅行]}]