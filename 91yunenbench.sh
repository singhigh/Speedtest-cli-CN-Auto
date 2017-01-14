#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

echo "Input host provider here [default:Enter]"
read hostp
echo "Now test starts, it may take 20 or more minutes..."
#===============================以下是各类要用到的函数========================================
#teddey的besh测试网络下载和IO用到的
get_opsy() {
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    speedtest=$(wget -4O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    ipaddress=$(ping -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    nodeName=$2
    if   [ "${#nodeName}" -lt "8" ]; then
        echo -e "$2\t\t\t\t$ipaddress\t\t$speedtest" | tee -a $logfilename
    elif [ "${#nodeName}" -lt "13" ]; then
        echo -e "$2\t\t\t$ipaddress\t\t$speedtest" | tee -a $logfilename
    elif [ "${#nodeName}" -lt "24" ]; then
        echo -e "$2\t\t$ipaddress\t\t$speedtest" | tee -a $logfilename
    elif [ "${#nodeName}" -ge "24" ]; then
        echo -e "$2\t$ipaddress\t\t$speedtest" | tee -a $logfilename
    fi
}



speed() {
    speed_test 'http://cachefly.cachefly.net/100mb.test' 'CacheFly'
    speed_test 'http://speedtest.tokyo.linode.com/100MB-tokyo.bin' 'Linode, Tokyo, JP'
    speed_test 'http://speedtest.singapore.linode.com/100MB-singapore.bin' 'Linode, Singapore, SG'
    speed_test 'http://speedtest.london.linode.com/100MB-london.bin' 'Linode, London, UK'
    speed_test 'http://speedtest.frankfurt.linode.com/100MB-frankfurt.bin' 'Linode, Frankfurt, DE'
    speed_test 'http://speedtest.fremont.linode.com/100MB-fremont.bin' 'Linode, Fremont, CA'
    speed_test 'http://speedtest.dal05.softlayer.com/downloads/test100.zip' 'Softlayer, Dallas, TX'
    speed_test 'http://speedtest.sea01.softlayer.com/downloads/test100.zip' 'Softlayer, Seattle, WA'
    speed_test 'http://speedtest.fra02.softlayer.com/downloads/test100.zip' 'Softlayer, Frankfurt, DE'
    speed_test 'http://speedtest.sng01.softlayer.com/downloads/test100.zip' 'Softlayer, Singapore, SG'
    speed_test 'http://speedtest.hkg02.softlayer.com/downloads/test100.zip' 'Softlayer, HongKong, CN'
}


io_test() {
    (LANG=en_US dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}
#=================teddey用到的函数结束=================================================

#=================以下是我自己写的网络mtr和ping用到的函数==============================

#测试来路路由
mtrgo(){
	mtrurl=$1
	nodename=$2
	echo "===Test of MTR from [$nodename] to the server starts===" | tee -a $logfilename
	mtrgostr=$(curl -s "$mtrurl")
	#echo $mtrgostr >> $logfilename
	echo $mtrgostr > mtrlog.log
	mtrgostrback=$(curl -s -d @mtrlog.log "http://test.91yun.org/traceroute.php")
	rm -rf mtrlog.log
	echo -e $mtrgostrback | awk -F '^' '{printf("%-2s\t%-16s\t%-35s\t%-30s\t%-25s\n",$1,$2,$3,$4,$5)}' | tee -a $logfilename
	echo -e "=== [$nodename] route test ends===\n\n" | tee -a $logfilename	
}

#测试回程路由
mtrback(){
	echo "===Test of MTR to [$2] start===" | tee -a $logfilename
	mtr -r -c 10 $1 | tee -a $logfilename
	echo -e "===Test of MTR to [$2] stop===\n\n" | tee -a $logfilename	

}

#测试全国ping值
ping_test(){
	echo "===Ping test from mainland china begins===" | tee -a $logfilename
	pingurl="http://www.ipip.net/ping.php?a=send&host=$1&area%5B%5D=china"
	pingstr=$(curl -s "$pingurl")
	#echo $pingstr >> $logfilename
	echo $pingstr > pingstr.log
	pingstrback_all=$(curl -s -d @pingstr.log "http://test.91yun.org/ping.php?ping")
	pingstrback=$(curl -s -d @pingstr.log "http://test.91yun.org/ping.php")
	rm -rf pingstr.log
	echo "===all ping start===" >> $logfilename
	echo -e $pingstrback_all | awk -F '^' '{printf("%-3s\t%-30s\t%-15s\t%-20s\t%-3s\t%-7s\t%-7s\t%-7s\t%-3s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' >> $logfilename	
	echo -e "===all ping end===\n\n" >> $logfilename
	echo "===ping show===" >> $logfilename
	echo -e $pingstrback | awk -F '^' '{printf("%-10s\t%-10s\t%-30s\t%-10s\t%-30s\t%-30s\t%-30s\n",$1,$2,$3,$4,$5,$6,$7)}' | tee -a $logfilename
	echo -e "===ping show end===\n\n" >> $logfilename
	echo "===Ping test from mainland china ends===" | tee -a $logfilename
	
}

#测试跳板ping
#参数1,ping的地址
#参数2,描述
testping()
{
	echo "{start testing $2 ping}" | tee -a $logfilename
	ping -c 10 $1 | tee -a $logfilename
	echo "{end testing}" | tee -a $logfilename
}
#==========================自用函数结束========================================



#安装需要的依赖库
prewget()
{
	[[ -f /etc/redhat-release ]] && os='centos'
	[[ ! -z "`egrep -i debian /etc/issue`" ]] && os='debian'
	[[ ! -z "`egrep -i ubuntu /etc/issue`" ]] && os='ubuntu'
	[[ "$os" == '' ]] && echo 'Error: Your system is not supported to run it!' && exit 1

	if [ "$os" == 'centos' ]; then
		#yum -y install make gcc gcc-c++ gdb mtr wget curl automake autoconf time perl-Time-HiRes python perl virt-what
		yum -y install mtr curl
	else
		apt-get update
		#apt-get -y install curl  mtr perl python virt-what automake autoconf time make gcc gdb
		apt-get -y install curl mtr
	fi
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	tram=$( free -m | awk '/Mem/ {print $2}' )
	swap=$( free -m | awk '/Swap/ {print $2}' )
	up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
	opsy=$( get_opsy )
	arch=$( uname -m )
	lbit=$( getconf LONG_BIT )
	host=$hostp
	up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
	kern=$( uname -r )
	ipv6=$( wget -qO- -t1 -T2 ipv6.icanhazip.com )
	IP=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
	IPaddr=$(curl -s myip.ipip.net | awk -F '：' '{print $3}')
	if [ "$IP" == "" ]; then
		IP=$(curl -s ip.cn | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
		IPaddr=$(curl -s ip.cn | awk -F '：' '{print $3}')	
	fi
	backtime=`date +%Y%m%d`
	logfilename="test91yun.log"

}
#查看虚拟化技术
virt()
{
	if [ "$os" == 'centos' ]; then
		yum -y install virt-what
	else
		apt-get update
		apt-get -y install virt-what
	fi
	
	#查看虚拟化技术：
	# wget http://people.redhat.com/~rjones/virt-what/files/virt-what-1.12.tar.gz
	# tar zxvf virt-what-1.12.tar.gz
	# cd virt-what-1.12/
	# ./configure
	# make && make install
	vm=`virt-what`
	# cd ..
	# rm -rf virt-what*	
}


#系统基本信息
systeminfo()
{

	#覆盖已有文件
	echo "====Log starts here====" > $logfilename

	#把系统信息写入日志文件
	echo "===Basic Info===" | tee -a $logfilename
	echo "CPU:$cname" | tee -a $logfilename
	echo "cores:$cores" | tee -a $logfilename
	echo "freq:$freq" | tee -a $logfilename
	echo "ram:$tram" | tee -a $logfilename
	echo "swap:$swap" | tee -a $logfilename
	echo "uptime:$up" | tee -a $logfilename
	echo "OS:$opsy" | tee -a $logfilename
	echo "Arch:$arch ($lbit Bit)" | tee -a $logfilename
	echo "Kernel:$kern" | tee -a $logfilename
	echo "ip:$IP" | tee -a $logfilename
	echo "ipaddr:$IPaddr" | tee -a $logfilename
	echo "host:$hostp" | tee -a $logfilename
	echo "uptime:$up" | tee -a $logfilename
	echo "vm:$vm" | tee -a $logfilename
	echo "he:$he" | tee -a $logfilename
	echo -e "\n\n" | tee -a $logfilename

}


#带宽测试
bdtest()
{
	if [ "$os" == 'centos' ]; then
		yum -y install python
	else
		apt-get update
		apt-get -y install python
	fi
	echo "===Port Speed Test starts===" | tee -a $logfilename
	wget --no-check-certificate https://raw.githubusercontent.com/91yun/speedtest-cli/master/speedtest_cli.py 1>/dev/null 2>&1
	python speedtest_cli.py --share | tee -a $logfilename
	echo -e "===Port Speed Test ends here==\n\n" | tee -a $logfilename
	rm -rf speedtest_cli.py
}


#下载测试
dltest()
{
	echo "===Now we start inbound test===" | tee -a $logfilename
	next
	if  [ -e '/usr/bin/wget' ]; then
		echo -e "Node Name\t\t\tIPv4 address\t\tDownload Speed" | tee -a $logfilename
		echo "===star ipv4 download===" >> $logfilename
		speed && next
		echo -e "===end ipv4 download===\n\n" >> $logfilename
	else
		echo "Error: wget command not found. You must be install wget command at first."
		exit 1
	fi
}


#IO测试
iotest()
{
	echo "===Now we start IO Test===" | tee -a $logfilename
	io1=$( io_test )
	io2=$( io_test )
	io3=$( io_test )
	ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
	[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
	ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
	[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
	ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
	[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
	ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
	ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
	echo "I/O speed(1st run) : $io1" | tee -a $logfilename
	echo "I/O speed(2nd run) : $io2" | tee -a $logfilename
	echo "I/O speed(3rd run) : $io3" | tee -a $logfilename
	echo "Average I/O: $ioavg MB/s" | tee -a $logfilename
	echo ""
}


#开始测试来的路由
tracetest()
{
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=274&ip=$IP" "ChinaTelecomGuangzhou"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=100&ip=$IP" "ChinaTelecomShanghai"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=20&ip=$IP" "ChinaTelecomXiamenCN2"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=12&ip=$IP" "ChinaUnicomChongqin"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=356&ip=$IP" "ChinaMobileShanghai"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=160&ip=$IP" "CERNETBeijing"
}


#开始测试回程路由
backtracetest()
{
	mtrback "14.215.116.1" "ChinaTelecomGuangzhou"
	mtrback "101.227.255.45" "ChinaTelecomShanghai"
	mtrback "117.28.254.129" "ChinaTelecomXiamen (CN2)"
	mtrback "113.207.32.65" "ChinaUnicomChongqin"
	mtrback "183.192.160.3" "ChinaMobileShanghai"
	mtrback "202.205.6.30" "CERNETBeijing"
}


#开始进行PING测试
pingtest()
{
	ping_test $IP
}


#开始测试跳板ping
gotoping()
{
	echo "===Bounce Server Ping Test Starts here===" | tee -a $logfilename
	testping speedtest.tokyo.linode.com Linode-Japan
	testping hnd-jp-ping.vultr.com Vultr-Japan
	testping 192.157.214.6 Budgetvm-LosAngeles
	testping downloadtest.kdatacenter.com kdatacenter-KoreaSK
	testping 210.92.18.1 StarryKorea-KT
	echo "===Bounce Server Ping Test Ends here===" | tee -a $logfilename
}


benchtest()
{

	if [ "$os" == 'centos' ]; then
		yum -y install make gcc gcc-c++ gdbautomake autoconf time perl-Time-HiRes python perl
	else
		apt-get update
		apt-get -y install perl python automake autoconf time make gcc gdb
	fi
	
	# Download UnixBench5.1.3
	if [ -s UnixBench5.1.3.tgz ]; then
		echo "UnixBench5.1.3.tgz [found]"
	else
		echo "UnixBench5.1.3.tgz not found!!!download now..."
		if ! wget -c http://lamp.teddysun.com/files/UnixBench5.1.3.tgz; then
			echo "Failed to download UnixBench5.1.3.tgz, please download it to ${cur_dir} directory manually and try again."
			exit 1
		fi
	fi
	tar -xzf UnixBench5.1.3.tgz
	cd UnixBench/

	#Run unixbench
	make
	echo "===开始测试bench===" | tee -a ../${logfilename}
	./Run
	benchfile=`ls results/ | grep -v '\.'`
	cat results/${benchfile} >> ../${logfilename}
	echo "===bench测试结束===" | tee -a ../${logfilename}	
	cd ..
	rm -rf UnixBench5.1.3.tgz UnixBench
}


#上传文件
updatefile()
{
	resultstr=$(curl -s -T $logfilename "http://test.91yun.org/logfileupload.php")
	echo -e $resultstr | tee -a $logfilename
}

simple_test()
{
	prewget
	systeminfo
	bdtest
	iotest
	pingtest
	updatefile
}

normal_test()
{
	prewget
	virt
	systeminfo
	bdtest
	dltest
	iotest
	tracetest
	backtracetest
	pingtest
	gotoping
	updatefile
	
}

all_test()
{
	prewget
	virt
	systeminfo
	bdtest
	dltest
	iotest
	tracetest
	backtracetest
	pingtest
	gotoping
	benchtest
	updatefile
	
}




action=$1
[ -z $1 ] && action=n
case "$action" in
s)
    simple_test
    ;;
a)
    all_test
    ;;
n)
    normal_test
    ;;
*)
    echo "Arguments error! [${action} ]"
    echo "Usage: `basename $0` {s | n| a}"
    ;;
esac
