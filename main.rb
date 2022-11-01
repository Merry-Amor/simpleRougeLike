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

message = Message.new
message.welcomeMessage()
message.inputWait()
playerName = gets.chomp!
printf "nice to meet you #{playerName}\n"
while true
  routeNum = rand(1..3)
  message.routeView(routeNum)
  eventlist = []
  for i in 1..routeNum do
    eventcode = rand(1..5)
    printf "#{i}.#{getEvent(eventcode)}\n"
  end
  message.inputWait()
  selectEvent = gets.chomp!

end
