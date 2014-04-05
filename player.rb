class Player

  DIRECTION = [:forward, :left, :right, :backward]
  
  def initialize
    @enemy_directions = {}
  end
  
  def rescue_adjacent
    DIRECTION.each do |d|
      if @warrior.feel(d).captive? and ! @enemy_directions[d]
        @warrior.rescue!(d) unless @action_taken
        @action_taken = true
      end
    end
  end
  
  def bind_adjacent
    DIRECTION.each do |d|
      if @warrior.feel(d).enemy?
        @warrior.bind!(d) unless @action_taken
        @enemy_directions[d] = true
        @action_taken = true
      end
    end
  end
  
  def fight_adjacent
    DIRECTION.each do |d|
      if @warrior.feel(d).enemy? or ( @warrior.feel(d).captive? and @enemy_directions[d] )
        @warrior.attack!(d) unless @action_taken
        @action_taken = true
      end
    end
  end
  
  def rest
    if @warrior.health < 20 && ! is_under_attack?
      @warrior.rest! unless @action_taken
      @action_taken = true
    end
  end
  
  def is_under_attack?
    @warrior.health < @previous_health
  end

  def find_stairs
    unless @action_taken
      @warrior.walk!(@warrior.direction_of_stairs)
      @enemy_directions = {}
      @action_taken = true
    end
  end
  
  def play_turn(warrior)
    @warrior = warrior
    @action_taken = false
    
    rest

    rescue_adjacent
    
    bind_adjacent
    
    fight_adjacent
    
    
    find_stairs
    
    @previous_health = warrior.health
  end
end
