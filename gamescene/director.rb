require_relative 'enemy'
require_relative 'showTimePoint'

module EnemyDirector
  class Director
    def initialize
      $goal_flg = 0 #グローバル変数

      ## to show and reduce food ##
      @food = Food.new(7)
      ## end ##

      ## to show time and point and add point ##
      @showTimePoint = TimePoint.new(0.5, @food)
      ## end ##

      rand_x = [25, 125, 225, 325, 425, 525]  #6レーン
      @rand_x = rand_x

      # @enemy_monkey    = Enemy.new(rand_x[rand(6)], 0, "images/monky_2.png")
      # @enemy_snake     = Enemy.new(rand_x[rand(6)], 0, "images/snake_2.png")
      # @enemy_elephant  = Enemy.new(rand_x[rand(6)], 0, "images/elephant_2.png")
      # @enemy_crocodile = Enemy.new(rand_x[rand(6)], 0, "images/crocodile_2.png")
      # @enemy_gorilla   = Enemy.new(rand_x[rand(6)], 0, "images/gorilla_2.png")


      @enemy_menbers = []

      @enemy_menbers << Enemy.new(rand_x[rand(6)], 0, "images/monky_enemy.png")
      @enemy_menbers << Enemy.new(rand_x[rand(6)], 0, "images/snake_enemy.png")
      @enemy_menbers << Enemy.new(rand_x[rand(6)], 0, "images/elephant_enemy.png")
      @enemy_menbers << Enemy.new(rand_x[rand(6)], 0, "images/crocodile_enemy.png")
      @enemy_menbers << Enemy.new(rand_x[rand(6)], 0, "images/gorilla_boss_enemy.png")

      temp = []
      @enemy = []
      @enemy_menbers.each do |enemy_member|
        10.times do
          temp << enemy_member
        end
        @enemy << temp
        temp = []
      end
      p @enemy
      ## end ##
      @bg_img = Image.load("images/game_background.jpg")

      @enemy_level = 0
      @ball_enemy_dxdy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      @ball_enemy_dxdy_old = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      @i = 0
      @enemy_shown = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      @j = 1
    end

    def play(ball_xy)
      ## change for debug ##
      # Window.draw(0, 0, @bg_img)
      ## end ##
      Window.decide #背景の描画予約


      ## show
      @food.draw_food
      ## end ##

      ## show time and point ##
      # @showTimePoint.add_point(5) # <- test
      score = @showTimePoint.draw_time_point
      # p "score",score
      ## end ##

      # if $goal_flg == 0 then
        i = 0
        @enemy[@enemy_level].each do |emy|

        # @enemy[@enemy_level].each do |emy|
          @ball_enemy_dxdy[i] = check_ball(emy.draw(@rand_x[@j]), ball_xy)
          @j += 1
          @j = 0 if @j > 5
          
          # p @ball_enemy_dxdy[i]
          i += 1
        end
        # @enemy_menbers[@enemy_level].draw
      #end
      i = 0
      @ball_enemy_dxdy.each do |bedd|
        if bedd * @ball_enemy_dxdy_old[i] < 0
          @enemy[@enemy_level][i].show_mode = 1
          @showTimePoint.add_point(10)
          @enemy_shown[i] = 0
        else
          @enemy[@enemy_level][i].show_mode = 0
        end
        i += 1
      end
      @ball_enemy_dxdy_old = @ball_enemy_dxdy.dup

      add_enemy

      

      return score
    end

    def upgrade_enemy
      if @enemy_level < 5
        @enemy_level += 1
      end
    end

    def check_ball(enemy_xy, ball_xy_list)
      # ball_enemy_dxdy = []
      ball_xy_list.each do |ball_xy|
        if enemy_xy[0] == ball_xy[0]
          if enemy_xy[1] < ball_xy[1] # enemty is upside
            return 1
          else
            return -1
          end
        else
          return 0
        end
      end
    end

    def add_enemy
      # @enemy_shown = []
      i = 0
      @enemy[@enemy_level].each do |emy|
        p emy.show_mode 
        if emy.show_status < 1
          emy.show_mode = 1
          @enemy_shown[i] = 1
        end
        i += 1
      end
      # p @enemy_shown
    end
  end
end
