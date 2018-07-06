#!perl -w

require "login.pl";
#require "mailto.pl";

sub check_attak {
	if(defined @dorf){check_attak_match()} else {check_attak_one()}	
}

sub check_attak_one{
	while(1){
			check_scouts();
			my @res = sender('get', "$url/dorf1.php");
			if($res[0] == 200){
				my $res = $res[1];
				#print LOG scalar(localtime), ' chek_attak_one() sender() вернул', " $res[0] \n";
				#print STR scalar(localtime), ' chek_attak_one() sender() вернул', " $res[0] \n $res[1] \n";
		
				#if($res eq 200){ print LOG $rec, " OK \n";
				#if($res_ok =~ m/id="movements"/g){
				
				if($res =~ m/class="troopMovements header"/){
					#print LOG 'Сейчас здесь 1', "\n";
					while($res =~ m/class="([ad]\d+)">.+?id="timer\d+">(\d+:\d+:\d+)</gs){
						#print LOG $&, "\n";
						if($1 eq 'a1' or $1 eq 'a3'){
							# att1(a1) - нападение на вас  , att2(a2) - вы нападаете, att3(a3) - на падение на ваш оазис, def1(d1) - ваши возвращающиеся войска
							print LOG scalar(localtime)," Нападение через: $2 \t Сон1 $sleep_time_chek_yes сек\. \n";
							@time = split(':',$2);
							$sec = $time[0]*3600;
							$sec += $time[1]*60;
							$sec += $time[2];
							if($sec < 3000){
								#print LOG "Сон1 $sec сек\. \n";
								#sleep($sec);
								#send_mail("$1 attack $2");
								qx{mplayerc.exe 1.mp3};
								}
							sleep $sleep_time_chek_yes;
						} else {
							print LOG scalar(localtime), " Пока не нападают \t Сон2 $sleep_time_chek_no сек\. \n";
							sleep $sleep_time_chek_no;
							}
					}
				} else {print LOG scalar(localtime), " Нет передвижения войск \t Сон2 $sleep_time_chek_no сек\. \n";
						sleep $sleep_time_chek_no;
					}
			}
		}
}


sub check_attak_match{
	while(1){
		check_scouts();
		undef $att;
		foreach(@dorf){
			print LOG 'check_attak_match() ', "$_ \n";
			undef @res;
			@res = sender('get', "$url/dorf1.php?newdid=$_");
			if($res[0] == 200){
				my $res = $res[1];
				#print LOG scalar(localtime), ' chek_attak_match() sender() вернул', " $res[0] \n";
				#print STR scalar(localtime), ' chek_attak_match() sender() вернул', " $res[0] \n $res[1] \n";
					
				#if($res eq 200){ print LOG $rec, " OK \n";
				#if($res_ok =~ m/id="movements"/g){
				#if($res =~ m/class="a1">(\d+)&nbsp;.+?id="timer\d+">(\d+:\d+:\d+)</s){
				while($res =~ m/class="(a\d+)">(\d+)&nbsp;.+?id="timer\d+">(\d+:\d+:\d+)</gs){
					#print LOG $&, "\n";
					if(($1 eq 'a1') or ($1 eq 'a3')){	
						# att1(a1) - нападение на вас  , att2(a2) - вы нападаете, def1(d1) - ваши возвращающиеся войска
						print LOG scalar(localtime)," $_ $2 нападение через: $3 \t Сон1 $sleep_time_chek_yes сек\. \n";
						@time = split(':',$3);
						$sec = $time[0]*3600;
						$sec += $time[1]*60;
						$sec += $time[2];
						#if($sec < 3000){
							print LOG "Сон1 $sec сек\. \n";
							#sleep($sec);
							send_mail("$2 attack $3");
							qx{mplayerc.exe 1.mp3};
						#	}
						$att = 200;	
						sleep 5;
					} 
				}
				unless($att){
					print LOG scalar(localtime), " $_ Пока не нападают \n";
					sleep 5;
					}	
			}		
		}
		if($att){
			sleep $sleep_time_chek_yes;
			} else {
				print LOG scalar(localtime), " Сон2 $sleep_time_chek_no сек\. \n";
				sleep $sleep_time_chek_no;
				}
	}
}

sub check_scouts{
	my @res = sender('get', "$url/berichte.php?t=3");
		if($res[0] == 200){
			my $res = $res[1];
			#if($res =~ m/class="messageStatus messageStatusUnread".{1,90}class="iReport iReport19".{1,210}<a href="berichte\.php\?id=(\w+\|\w+)&amp;t=3">/s){
			if($res =~ m/class="messageStatus messageStatusUnread".{1,90}class="iReport iReport19"/s){
				print LOG scalar(localtime), ' check_scouts() Кто-то разведывает деревню', "\n";
				qx{mplayerc.exe 1.mp3};
				sleep 10;
			} else {print LOG scalar(localtime), ' check_scouts() Разведчиков не обнаружено', "\n";
					sleep 10;
				}
		} else {print LOG scalar(localtime), ' check_scouts() Ошибка запроса', "\n";}
}
#sleep 900;
check_attak();
