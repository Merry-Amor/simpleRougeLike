require 'nkf'

class Message
  def initialize
    @event = Event.new
  end

  def alertNoNumber num
    if num == 1 then
      printf "あなたが今出来るのは移動先「1」を選ぶか、「status」でステータスを見る事だけだ。\n"
    else
      printf "あなたが今出来るのは移動先を1〜#{num}で選ぶか、「status」でステータスを見る事だけだ。\n"
    end
  end

  def inputWait
    printf ">"
  end

  def welcomeMessage
    printf "simpleRougeLikeの世界へようこそ。\n"
    printf "あなたの名前を教えてください。\n"
  end

  def enterDungon
    printf "あなたはダンジョンに足を踏み入れた。\n"
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
end

class Player
  def initialize inputName
    @name = inputName
    @hp = 10
    @mp = 10
    @atk = 1
    @atk_bonus = 0
    @mgc = 1
    @mgc_bonus = 0
    @def = 0
    @def_bonus = 0
    @mdef = 0
    @mdef_bonus = 0
    @items = []
    @equips = []
  end

  def viewStatus
    #実際にはここに消耗品と装備品をIDから名前のリストにする処理を追加する必要あり
    items = @items
    equips = @equips
    printf "==========\n"
    printf "#{@name}\nHP:#{@hp}\nMP:#{@mp}\n攻撃力:#{@atk} + #{@atk_bonus}\n魔法力:#{@mgc} + #{@mgc_bonus}\n防御力:#{@def} + #{@def_bonus}\n魔法防御力:#{@mdef} + #{@mdef_bonus}\n消耗品:#{items}\n装備品:#{equips}\n"
    printf "==========\n"
  end
end

class Event
  def initialize
  end

  def getEventName eventcode
    case eventcode
    when 1
      return "ランダムイベント"
    when 2
      return "エンカウントバトル"
    when 3
      return "消耗品宝箱"
    when 4
      return "装備品宝箱"
    when 5
      return "ショップ"
    when 6
      return "鍛冶屋"
    when 7
      return "キャンプ地"
    end
  end

end

message = Message.new
event = Event.new
message.welcomeMessage()
message.inputWait()
playerName = gets.chomp!
player = Player.new(playerName)
message.enterDungon()
while true
  routeNum = rand(1..3)
  message.routeView(routeNum)
  eventlist = {}
  for i in 1..routeNum do
    eventcode = rand(1..7)
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
end
