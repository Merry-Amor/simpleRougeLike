require 'nkf'
require 'json'

class Message
  def initialize event
    @event = event
  end

  def viewMessage message
    printf message + "\n"
  end

  def alertNoNumber num
    if num == 1 then
      printf "君が今出来るのは移動先「1」を選ぶか、「status」でステータスを見る事だけだ。\n"
    else
      printf "君が今出来るのは移動先を1〜#{num}で選ぶか、「status」でステータスを見る事だけだ。\n"
    end
  end

  def alertNoNumberBattleComand
    printf "君は今、敵を前にしている。1~4のコマンドを選んで戦うのだ。\n"
  end

  def inputWait
    printf ">"
  end

  def welcomeMessage
    printf "simpleRougeLikeの世界へようこそ。\n"
    printf "君の名前を教えてくれ。\n"
  end

  def enterDungon
    printf "君はダンジョンに足を踏み入れた。\n"
  end

  def routeView routeNum
    case routeNum
    when 1
      printf "君の前にはまっすぐな一本の道が続いている。\n"
    when 2
      printf "君の前に分かれ道が現れた。どちらを選ぶかは君次第だ。\n"
    when 3
      printf "君の前に三叉路が現れた。どの道を選ぶかは君次第だ。\n"
    end
  end

  def reeventlist list
    list.each { |key, value|
      printf "#{key}.#{@event.getEventName(value)}\n"
    }
  end

  def encount
    printf "君の前に敵が立ち塞がる。先に進むには倒すしかない。\n"
  end

  def playerAttack
    printf "君は敵に向けて武器を振るった。\n"
  end

  def dicerollResult name, dice, bonus, total
    printf "#{name}:ころころ……#{dice} + #{bonus} => #{total}\n"
  end

  def playerAttackFail enemyName
    printf "君の攻撃は#{enemyName}によって完全に防がれた。\n"
  end

  def playerAttackSucceess enemyName, result
    printf "君の攻撃は確実に#{enemyName}を傷つけた。#{result}のダメージ！\n"
  end

  def enemyAttackFail enemyName
    printf "君は#{enemyName}の攻撃を完全に防いだ。\n"
  end

  def enemyAttackSucceess enemyName, result
    printf "#{enemyName}の攻撃が君を傷付ける。#{result}のダメージ！\n"
  end

  def getMoney money
    printf "君は敵の屍から#{money}Gの価値のある戦利品を手に入れた。\n"
  end

  def playerBattleFinish
    printf "君は敵の屍を越えて先に進んだ。\n"
  end

  def battleGameOver()
    printf "ついに敵の攻撃が君に致命傷を与えた。君の視界が赤く染まっていく。君の冒険はここで終わってしまった。\n"
  end

end

class Player
  def initialize inputName
    @name = inputName
    @max_hp = 10
    @hp = 10
    @max_mp = 10
    @mp = 10
    @atk = 2
    @atk_bonus = 0
    @mgc = 2
    @mgc_bonus = 0
    @def = 1
    @def_bonus = 0
    @mdef = 0
    @mdef_bonus = 0
    @money = 0
    @items = []
    @equips = []
  end

  def viewStatus
    #実際にはここに消耗品と装備品をIDから名前のリストにする処理を追加する必要あり
    items = @items
    equips = @equips
    printf "==========\n"
    printf "#{@name}\nHP:#{@hp}/#{@max_hp}\nMP:#{@mp}/#{@max_mp}\n攻撃力:#{@atk} + #{@atk_bonus}\n魔法力:#{@mgc} + #{@mgc_bonus}\n防御力:#{@def} + #{@def_bonus}\n魔法防御力:#{@mdef} + #{@mdef_bonus}\n所持金:#{@money} G\n消耗品:#{items}\n装備品:#{equips}\n"
    printf "==========\n"
  end

  def getPlayerName
    return @name
  end

  def getPlayerHP
    return @hp
  end

  def getPlayerMaxHP
    return @max_hp
  end

  def getPlayerMP
    return @mp
  end

  def getPlayerMaxMP
    return @max_mp
  end

  def getPlayerAtk
    return @atk
  end

  def getPlayerAtkBonus
    return @atk_bonus
  end

  def getPlayerDef
    return @def
  end

  def getPlayerDefBonus
    return @def_bonus
  end

  def getItemList
    items = @items #実際にはここに消耗品をIDから名前のリストにする処理を追加する必要あり
    return items
  end

  def hpDamage damage
    @hp -= damage
  end

  def addMoney money
    @money += money
  end
end

class Event
  def initialize util
    @util = util
    @event_list = ["ランダムイベント","エンカウントバトル","消耗品宝箱","装備品宝箱","ショップ","鍛冶屋","キャンプ地"]
    @level = 1
  end

  def setMessage message
    @message = message
  end

  def setPlayer player
    @player = player
  end

  def setBattle battle
    @battle = battle
  end

  def getNumberOfEvent
    return @event_list.length
  end

  def getEventName eventcode
    return @event_list[eventcode - 1]
  end

  def runEvent eventcode
    case eventcode
    when 1

    when 2
      encountBattle()
    when 3

    when 4

    when 5

    when 6

    when 7

    end
  end

  def encountBattle
    @message.encount()
    enemyList = []
    File.open("./data/enemy.json",'r') do |file|
      enemyList = JSON.parse(file.read)
    end
    enemyHash = enemyList[rand(1..enemyList.length) - 1]
    @battle.setEnemy(enemyHash,@level)
    @message.viewMessage(enemyHash["encount_message"])
    result = @battle.battle()
    if result == "lose" then
      gameover()
    end
    @message.playerBattleFinish()

  end

  def gameover()
    # そのうちちゃんと作る
    exit
  end

end

class Battle
  def initialize player, message, util
    @player = player
    @message = message
    @util = util
  end

  def setEnemy enemyHash, level
    @enemy = enemyHash
    @enemyName = @enemy["name"].to_s + "Lv" + level.to_s
    @enemy_now_hp = @enemy["hp"] * level.to_i
    @enemy_now_mp = @enemy["mp"] * level.to_i
    @enemy_routine = @enemy["routine"]
  end

  def battle
    turn = 0
    lose_flag = false
    while true
      turn += 1
      printf "ターン #{turn}\n"
      while true
        viewPlayerHPMPItem()
        viewEnemyHPMP()
        viewCommand()
        @message.inputWait()
        selectCommand = gets.chomp!
        if selectCommand.to_i == 0 || selectCommand.to_i > 4 then
          @message.alertNoNumberBattleComand
        else
          break
        end
      end
      case selectCommand.to_i
      when 1
        playerAttack()
      when 2
      when 3
      when 4
      end
      if @enemy_now_hp <= 0 then
        break
      end
      enemyCommand()
      if @player.getPlayerHP() <= 0 then
        lose_flag = true
        break
      end
    end

    if (lose_flag) then
      @message.gameOver()
      return "lose"
    end

    @message.viewMessage(@enemy["subjugation_message"])
    @message.getMoney(@enemy["drop_money"])
    @player.addMoney(@enemy["drop_money"])
    return "win"

  end

  def viewPlayerHPMPItem()
    printf "#{@player.getPlayerName()} HP:#{@player.getPlayerHP()}/#{@player.getPlayerMaxHP()} MP:#{@player.getPlayerMP()}/#{@player.getPlayerMaxMP()} 消耗品:#{@player.getItemList()}\n"
  end

  def viewEnemyHPMP
    printf "#{@enemyName} HP:#{@enemy_now_hp} MP:#{@enemy_now_mp}\n"
  end

  def viewCommand
    printf "1.攻撃 2.魔法攻撃 3.防御 4.消耗品使用\n"
  end

  def playerAttack
    @message.playerAttack()

    playerResultArr = @util.diceroll(@player.getPlayerAtk)
    playerResult = playerResultArr.inject(:+) + @player.getPlayerAtkBonus
    @message.dicerollResult("#{@player.getPlayerName()}の攻撃ロール", playerResultArr, @player.getPlayerAtkBonus, playerResult)

    enemyResultArr = @util.diceroll(@enemy["def"])
    enemyResult = enemyResultArr.inject(:+) + @enemy["def_bonus"]
    @message.dicerollResult("#{@enemyName}の防御ロール", enemyResultArr, @enemy["def_bonus"], enemyResult)

    result = playerResult - enemyResult

    if result <= 0 then
      @message.playerAttackFail(@enemyName)
    else
      @message.playerAttackSucceess(@enemyName,result)
      @enemy_now_hp -= result
    end
  end

  def enemyCommand
    command = @enemy_routine[rand(1..@enemy_routine.length) - 1]
    case command
    when "A"
      enemyAttack()
    when "N"
      @message.viewMessage(@enemy["nothing_message"])
    end
  end

  def enemyAttack
    @message.viewMessage(@enemy["attack_message"])

    enemyResultArr = @util.diceroll(@enemy["atk"])
    enemyResult = enemyResultArr.inject(:+) + @enemy["atk_bonus"]
    @message.dicerollResult("#{@enemyName}の攻撃ロール", enemyResultArr, @enemy["atk_bonus"], enemyResult)

    playerResultArr = @util.diceroll(@player.getPlayerDef)
    playerResult = playerResultArr.inject(:+) + @player.getPlayerDefBonus
    @message.dicerollResult("#{@player.getPlayerName()}の防御ロール", playerResultArr, @player.getPlayerDefBonus, playerResult)

    result = enemyResult - playerResult

    if result <= 0 then
      @message.enemyAttackFail(@enemyName)
    else
      @message.enemyAttackSucceess(@enemyName,result)
      @player.hpDamage(result)
    end
  end



end

class Util
  def diceroll num
    dice = []
    if num == 0
      return [0]
    end
    for i in 1..num do
      dice.push(rand(1..6))
    end
    return dice
  end
end

util = Util.new
event = Event.new(util)
message = Message.new(event)
event.setMessage(message)
message.welcomeMessage()
message.inputWait()
playerName = gets.chomp!
player = Player.new(playerName)
event.setPlayer(player)
battle = Battle.new(player,message,util)
event.setBattle(battle)
message.enterDungon()
while true
  routeNum = rand(1..3)
  message.routeView(routeNum)
  eventlist = {}
  for i in 1..routeNum do
    eventcode = rand(1..event.getNumberOfEvent())
    printf "#{i}.#{event.getEventName(eventcode)}\n"
    eventlist[i] = eventcode
  end
  while true
    message.inputWait()
    selectEvent = gets.chomp!
    selectEvent = NKF.nkf('-w -Z4', NKF.nkf('--katakana -w', selectEvent)).upcase
    if selectEvent == 'STATUS' then
      player.viewStatus()
      message.reeventlist(eventlist)
    elsif selectEvent.to_i > routeNum || selectEvent.to_i <= 0 then
      message.alertNoNumber(routeNum)
      message.reeventlist(eventlist)
    else
      break
    end
  end
  event.runEvent(eventlist[selectEvent.to_i])
end
