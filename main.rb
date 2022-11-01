class Message
  def initialize
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
end

class Player
  def initialize inputName
    name = inputName
    hp = 10
    mp = 10
    item = []
    equip = []
  end
end

class Event
  def initialize
  end

  def getEvent eventcode
    case eventcode
    when 1
      return "ランダムイベント"
    when 2
      return "エンカウントバトル"
    when 3
      return "宝箱"
    when 4
      return "レア宝箱"
    when 5
      return "ショップ"
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
    eventcode = rand(1..5)
    printf "#{i}.#{event.getEvent(eventcode)}\n"
    eventlist[i] = eventcode
  end
  message.inputWait()
  selectEvent = gets.chomp!
end
