#! perl -w
# check the available troops
#Используется для фарма когда у тебя больше чнм одна деревня. Войска отправляются из деревни с идентификатором находящемся в первом элементе массива @dorf в файле data.pl
use Switch;
use HTML::Parser;
require 'login.pl';
require 'data.pl';
open BD, "farm_bd1.txt";

#timestamp=1336656239&timestamp_checksum=56821c&b=1&currentDid=40526&t1=3&t4=&t7=&t9=&t2=&t5=&t8=&t10=&t3=&t6=&dname=&x=2&y=142&c=4&s1=ok
	%form1 = ('timestamp' => '', 'timestamp_checksum' => '', 'b' => '', 'currentDid' => '', 't1' => '', 't4' => '', 't7' => '', 't9' => '', 't2' => '', 't5' => '', 't8' => '', 't10' => '', 't3' => '', 't6' => '', 'dname' => '', 'x' =>'', 'y' => '', 'c' => "$type_att", 's1' => 'ok');
	
#redeployHero=&timestamp=1336656381&timestamp_checksum=75351a&id=39&a=20714&c=4&kid=207061&t1=3&t2=0&t3=0&t4=0&t5=0&t6=0&t7=0&t8=0&t9=0&t10=0&t11=0&sendReally=0&troopsSent=1&currentDid=40526&b=2&dname=&x=2&y=142&s1=ok	
	%form2 = ('redeployHero' => '', 'timestamp' => '', 'timestamp_checksum' => '', 'id' => 39, 'a' => '', 'c' => "$type_att", 'kid' => '', 't1' => 0, 't2' => 0, 't3' => 0, 't4' => 0, 't5' => 0, 't6' => 0, 't7' => 0, 't8' => 0, 't9' => 0, 't10' => 0, 't11' => 0, 'sendReally' => '', 'troopsSent' => '', 'currentDid' => '', 'b' => '', 'dname' => '', 'x' =>'', 'y' => '', 's1' => 'ok');

sub farm{
		
	foreach(<BD>){
		chomp $_;
		$a = [split /:/,$_];
		@farm_bd = (@farm_bd, $a);
		}
	#foreach(@farm_bd){
	#	print LOG $_ -> [0],"\t", $_ -> [1], "\t", $_ -> [2], "\t",	$_ -> [3], "\t", $_ -> [4], "\n";
	#}
	
	while(1){
		#print LOG scalar(localtime), 'farm() Сейчас здесь 0', "\n";
		farm_berch();

		foreach(@farm_bd){
			#print LOG scalar(localtime), ' farm() @farm_bd[] = ', $_ -> [4], "\n";
			check_avail_tr();
			if($avail_tr{$_ -> [2]} >= ($_ -> [3])){
				#print LOG scalar(localtime),'farm() ', "$avail_tr{$_ -> [2]} \t",  $_ -> [3], "\n";
				$form1{$_ -> [2]} = ($_ -> [3]);
				$form2{$_ -> [2]} = ($_ -> [3]);
				$form1{'x'} = $_ -> [0];
				$form1{'y'} = $_ -> [1];
				$form2{'x'} = $_ -> [0];
				$form2{'y'} = $_ -> [1];
				print LOG scalar(localtime), ' farm()',
				"\t Возможна отправка ", $_ -> [3], ' ', $_ -> [2], ' на ' , $_ ->[4], " $form1{'x'}:$form1{'y'} \n";
				undef $t;
				$t = send_farm_tr();
				#print LOG scalar(localtime), ' farm()', " $t \n";
				if($t == 200){
					$form1{$_ -> [2]} = '';
					$form2{$_ -> [2]} = 0;
					#print LOG scalar(localtime), 'farm() Сейчас здесь 1', "\n";
					sleep 10;
					} elsif ($t == 400){
						$form1{$_ -> [2]} = '';
						$form2{$_ -> [2]} = 0;
						#print LOG scalar(localtime), 'farm() Сейчас здесь 2', "\n";
						} 
			} else { 
				print LOG scalar(localtime), ' Недостаточно войнов для атаки на ', $_ -> [4],' ', $_ -> [0],':',$_ -> [1]," Сон2 $sleep_time_farm сек\. \n";
				$form1{$_ -> [2]} = '';
				$form2{$_ -> [2]} = 0;
				sleep $sleep_time_farm;
				farm_berch();
				redo;
				}
			#print LOG scalar(localtime), 'farm() Сейчас здесь 3', "\n";	
		}
		#print LOG scalar(localtime), 'farm() Сейчас здесь 4', "\n";	
	}
}

sub farm_berch{
		my @res = sender('get', "$url/berichte.php");
		if($res[0] == 200){
			$res = $res[1];
			
			my @s = $res =~ m/class="messageStatus messageStatusUnread".{1,430}class="reportInfo carry full" \/><\/a>\s+?<div>\s+?<a href="berichte\.php\?id=(\w+\|\w+)&amp;t=">Деревня xbb атакует (.{1,40})<\/a>/sg;
			#print LOG scalar(localtime), ' farm_berch() ', "$& \n";
			#print LOG scalar(localtime), ' farm_berch() ', "@s \n";
			while(@s){
				my $a = shift @s;
				my $b = shift @s;
				#print LOG scalar(localtime),' farm_berch() ', " $a $b \n";
				foreach(@farm_bd){
					#print LOG $_ -> [4], "\n";
					if($b eq ($_ -> [4])){
						#print LOG ' farm_berch() ', "$b",' = ', $_ -> [4], ' ', $_ -> [0], ' : ', $_ -> [1], "\n";
						check_avail_tr();
						if($avail_tr{$_ -> [2]} >= ($_ -> [3])){
							#print LOG scalar(localtime),' farm_berch() ', "$avail_tr{$_ -> [2]} \t", $_ -> [3], "\n";
							$form1{$_ -> [2]} = ($_ -> [3]);
							$form2{$_ -> [2]} = ($_ -> [3]);
							$form1{'x'} = $_ -> [0];
							$form1{'y'} = $_ -> [1];
							$form2{'x'} = $_ -> [0];
							$form2{'y'} = $_ -> [1];
							print LOG scalar(localtime), ' farm_berch() ',
							"\t Возможна отправка ", $_ -> [3], ' ', $_ -> [2],' на ', $_ ->[4], " $form1{'x'}:$form1{'y'} \n";
							undef $t;
							$t = send_farm_tr();
							#print LOG scalar(localtime), ' farm()', " $t \n";
							if($t == 200){
								$form1{$_ -> [2]} = '';
								$form2{$_ -> [2]} = 0;
								undef @res;
								@res = sender('get', "$url/berichte.php?id=$a&t=0");
								if($res[0] == 200){
									#print LOG scalar(localtime), ' farm_berch() ', 'Просмотрел отчет 1', "\n";
									}
								#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 0', "\n";	
								sleep 10;
								last;
							} elsif ($t == 400){
								$form1{$_ -> [2]} = '';
								$form2{$_ -> [2]} = 0;
								#shift @farm_bd;
								undef @res;
								@res = sender('get', "$url/berichte.php?id=$a&t=0");
								if($res[0] == 200){
									#print LOG scalar(localtime), ' farm_berch() ', 'Просмотрел отчет 2', "\n";
									}
								}
							#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 1', "\n";		
						} else {
							print LOG scalar(localtime), ' Недостаточно войнов для атаки на ', $_ -> [4], ,' ', $_ -> [ 0],':', $_ -> [1], " Сон2 $sleep_time_farm сек\. \n";
							sleep $sleep_time_farm;
							redo;}
						#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 2', "\n";		
					} else { next;}
					#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 3', "\n";
				}
				#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 4', "\n";
				#next;	
			} #continue {print LOG scalar(localtime), 'farm_berch() Сейчас здесь continue', "\n";}
			#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 5', "\n";
		}
	#print LOG scalar(localtime), 'farm_berch() Сейчас здесь 6', "\n";	
}					

sub check_avail_tr {
	undef %avail_tr;
	my @res = sender("get", "$url/dorf1.php?newdid=$dorf[0]");
		if($res[0] eq 200){
			$res = $res[1];
			$pars = HTML::Parser -> new($res);
			#while($t = $res =~ m/class="boxes villageList units">.+?class="unit u(\w+)".+?class="num">(\d+)</gs){
			while($res =~ m/class="unit u(\w+)".+?class="num">(\d+)</gs){
				print LOG 'check_avail_tr() ', "$1", ' = ', "$2 \n";
				switch($1){
					case 21 {$avail_tr{t1} = $2;}
					case 22 {$avail_tr{t2} = $2;}
					case 24 {$avail_tr{t4} = $2;}
					case 25 {$avail_tr{t5} = $2;}
					case 26 {$avail_tr{t6} = $2;}
					case "hero" {$avail_tr{t11} = $2;}
					else {$avail_tr{"u$1"} = $2;}
					}
				
				#print LOG 'check_avail_tr() ', "$1",' = ',"$2 \n";				
			}
			#foreach(keys %avail_tr){
			#	print LOG '%avail_tr ', "$_", ' = ', "$avail_tr{$_} \n";}
		}
}

sub check_avail_tr_alt {
	undef %avail_tr;
	my @res = sender("get", "$url/build.php?id=39");
		if($res[0] eq 200){
			$res = $res[1];
			if($res =~ m/<a href="spieler.php?uid=15198">/g){
				$res =~ m/\G.+?<tbody class="units last">.+?<td class="unit(| none)">(\d+)<\/td>.+?<td class="unit(| none) last">0<\/td>/;
			#while($t = $res =~ m/class="boxes villageList units">.+?class="unit u(\w+)".+?class="num">(\d+)</gs){
				while($res =~ m/class="unit u(\w+)".+?class="num">(\d+)</gs){
				#print LOG 'check_avail_tr() ', "$1", ' = ', "$2 \n";
				switch($1){
					case 21 {$avail_tr{t1} = $2;}
					case 22 {$avail_tr{t2} = $2;}
					case 24 {$avail_tr{t4} = $2;}
					case 25 {$avail_tr{t5} = $2;}
					case "hero" {$avail_tr{t11} = $2;}
					else {$avail_tr{"u$1"} = $2;}
					}
				
				#print LOG 'check_avail_tr() ', "$1",' = ',"$2 \n";				
				}
			}
			#foreach(keys %avail_tr){
			#	print LOG '%avail_tr ', "$_", ' = ', "$avail_tr{$_} \n";}
		}
}

sub send_farm_tr{
	undef @res;	
	my @res = sender('get', "$url/build.php?tt=2&id=39&newdid=$dorf[0]");
	if($res[0] == 200){
		$res = $res[1];
		#print LOG scalar(localtime), ' send_farm_tr()', " $res[0] \n ";
		#print STR scalar(localtime), ' send_farm_tr()', " $res[0] \n $res \n";
		$res =~ m/name="timestamp".+?value="(\d+)"/s;
			$form1{'timestamp'} = $1;
		$res =~ m/name="timestamp_checksum".+?value="(\w+)"/s;
			$form1{'timestamp_checksum'} = $1;
		$res =~ m/name="b".+?value="(\d+)"/s;
			$form1{'b'} = $1;
		$res =~ m/name="currentDid".+?value="(\d+)"/s;
			$form1{'currentDid'} = $1;
			$form2{'currentDid'} = $1;	
			
		#foreach(keys %form1){
		#	print LOG 'send_farm_tr() %form1 ', "$_", ' = ', "$form1{$_} \n";}
		undef @res;		
		@res = sender('post', "$url/build.php?id=39&tt=2&newdid=$dorf[0]", \%form1);
		if($res[0] == 200){
			$res = $res[1];
			#print LOG scalar(localtime), ' send_farm_tr()', " $res[0] \n";
			#print STR scalar(localtime), ' send_farm_tr()', " $res[0] \n $res \n";
			if($res !~ m/class="error"/){
				$res =~ m/name="timestamp"\s+value="(\d+)"/;
					$form2{'timestamp'} = $1;
				$res =~ m/name="timestamp_checksum"\s+value="(\w+)"/;
					$form2{'timestamp_checksum'} = $1;
				$res =~ m/name="a"\s+value="(\d+)"/;
					$form2{'a'} = $1;
				$res =~ m/name="kid"\s+value="(\d+)"/;
					$form2{'kid'} = $1;
				$res =~ m/name="sendReally"\s+value="(\d+)"/;
					$form2{'sendReally'} = $1;
				$res =~ m/name="troopsSent"\s+value="(\d+)"/;
					$form2{'troopsSent'} = $1;
				$res =~ m/name="b"\s+value="(\d+)"/s;
					$form2{'b'} = $1;		
			
				#foreach(keys %form2){
				#	print LOG 'send_farm_tr() %form2 ', "$_", ' = ', "$form2{$_} \n";}	
				undef @res;
				@res = sender('post', "$url/build.php?id=39&tt=2&newdid=$dorf[0]", \%form2);
				if($res[0] eq 200){
					$res = $res[1];
					if($res =~ m/id="build" class="gid16"/){
						print LOG scalar(localtime), ' send_farm_tr()', ' Успешно отправлены ', $_ -> [3],' ', $_ -> [2], ' на ', $_ ->[4], " $form1{'x'}:$form1{'y'} \n";
						return 200;
					}
				} else {
					print LOG 'send_farm_tr()'," Ошибка отправки $how_much[0] $type_t[0] на $form2{'x'}.:.$form2{'y'} \n";
					sleep 30;
					send_farm_tr();
					}
			} else {
				print LOG scalar(localtime), " Деревня с координатами $form1{'x'}:$form1{'y'} не существует \n";
				return 400;
				}
		}
	}
	
}

sub farm_argv($$$$){
		#select STDOUT;
		check_avail_tr();
		if($avail_tr{$_[2]} >= $_[3]){
			print STDOUT "$avail_tr{$_[2]} \t $_[3] \n";
			$form1{'x'} = $_[0];
			$form1{'y'} = $_[1];
			$form2{'x'} = $_ -> [0];
			$form2{'y'} = $_ -> [1];
			$form1{$_[2]} = $_[3];
			$form2{$_[2]} = $_[3];	
			print STDOUT 'farm_argv()', "\t can attack $_[3] $_[2] to $form1{'x'}:$form1{'y'} \n";
				#" Возможна отправка $how_much[$i] $type_t[$i] на $form1{'dname'} \n";
			undef $t;	
			$t = send_farm_tr();
			print STDOUT 'farm_argv()', " $t \n";
			if($t == 200){
				print STDOUT 'farm_argv() attack sent', " \n";
				} elsif ($t == 400){
					print STDOUT 'farm_argv() village does not exist', " \n";
					} 
		} else { 
				print STDOUT 'It is not enough warriors to attack', "\n";
				}
}	

if(@ARGV){
	if($#ARGV == 3){
		foreach(@ARGV){	
			print STDOUT '@ARGV',"\t $_ \n";
			}
		farm_argv($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3]);
	} else {
		print STDOUT 'Wrong number of parameters', "\n";
		print LOG scalar(localtime),' farm.pl Неверное количество параметров', "\n";
		exit;
		}
} else {
	if(($#x eq $#y) && ($#x eq $#type_t) && ($#x eq $#how_much)){
		#print LOG 'farm.pl OK', "\n";
		farm();
		} else {
			print STDOUT 'Not equal to the number of parameters', "\n";
			print LOG scalar(localtime),' farm.pl Не равное количество аргументов для farm()', "\n";
			exit;
			}
	}	
	
