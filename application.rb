K_FACTOR = 32

module EloTest
  class Player
    attr_accessor :name, :war_cry, :rating, :wins, :looses

    def initialize(options = {})
      @name = options[:name]
      @rating = 100
      @war_cry = options[:war_cry]
      @wins = 0
      @looses = 0
    end

    def presentation
      puts "meu nome é #{@name}! #{@war_cry}"
    end
  end

  class Combat
    attr_reader :player1, :player2
    attr_accessor :title, :prize

    def initialize(player1, player2, title = 'guerra de dedão', prize = 'pacote de jujubas')
      @title   = title
      @prize   = prize
      @player1 = player1
      @player2 = player2
    end

    def annoucement
      puts "\n\nAqui, hoje!" \
            "\nImperdível #{@title}" \
            "\n\nPremio: #{@prize}"
    end

    def ready?
      puts "\n\n\n"
      puts '#' * 60
      puts "Player1 (#{@player1.rating} pts) says: #{@player1.war_cry}"
      puts '#' * 60
      puts "Player2 (#{@player2.rating} pts) says: #{@player2.war_cry}"
      puts '#' * 60
    end

    def fight!
      # transform rating
      r1 = (10**(@player1.rating / 400))
      r2 = (10**(@player2.rating / 400))

      # expected score
      e1 = r1 / (r1 + r2)
      e2 = r2 / (r1 + r2)

      # actual score
      if winner == 1
        puts "WINNER: #{@player1.name}"
        @player1.wins   += 1
        @player2.looses += 1
        s1 = 1
        s2 = 0
      else
        puts "WINNER: #{@player2.name}"
        @player2.wins   += 1
        @player1.looses += 1
        s2 = 1
        s1 = 0
      end

      # new ratings
      new_r1 = r1 + K_FACTOR * (s1 * e1)
      new_r2 = r2 + K_FACTOR * (s2 * e2)

      @player1.rating = (@player1.rating + new_r1).round(1)
      @player2.rating = (@player2.rating + new_r2).round(1)

      puts '#' * 60
      puts 'NEW RATINGS\n\n'
      puts "Player1 (#{@player1.rating} pts) says: #{@player1.war_cry}"
      puts '#' * 60
      puts "Player2 (#{@player2.rating} pts) says: #{@player2.war_cry}"
    end

    def winner
      [0, 1].sample
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  player1 = EloTest::Player.new(name: 'chapolin colorado', war_cry: 'secar e explodir!')
  player2 = EloTest::Player.new(name: 'capitão cueca', war_cry: 'viva la cueca!')

  20.times do
    puts 'APRESENTAÇÃO DOS COMPETIDORES'
    player1.presentation
    player2.presentation

    combat = EloTest::Combat.new(player1, player2)
    combat.annoucement

    puts 'PREPARADOS?'
    combat.ready?

    puts "3...2...1.. FIGHT!!!!!!!\n\n\n"
    combat.fight!
  end

  puts "\n\nNOW, AFTER 100 MATCHES!"
  puts player1.name.to_s
  puts "l: #{player1.looses}\t w: #{player1.wins}\t r: #{player1.rating}"
  puts player2.name.to_s
  puts "l: #{player2.looses}\t w: #{player2.wins}\t r: #{player2.rating}"
end
