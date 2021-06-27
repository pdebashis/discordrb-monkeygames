cd /home/acerlaptop/Production/discordrb-monkeygames 
pid=`ps -ef | grep run.rb | grep -v grep | awk '{print $2}'`

kill $pid

sleep 2
nohup ruby run.rb &
