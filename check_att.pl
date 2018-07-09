#!perl -w

#use strict;
use threads;

require "login.pl";
require "data.pl";
#require "mailto.pl";

sub mplay($){
	qx{mplayerc.exe $_[0]};
}

sub check_attak(){
	while(1){
		#check_scouts();
		undef $att;
		foreach(@dorf){
			my @resp = check_attak_one($_);
			#foreach(@resp){
			#	print 'check_attak() @resp = ', $_ , "\n";
			#}
			if($resp[0] == 200){
				print LOG scalar(localtime), ' check_attak() Нападение на ', $_ , ' через ', $resp[1], "\n";
				$att = 1;
				$alarm = threads -> create(\&mplay, 'sirena.mp3');
			} elsif($resp[0] == 400){
				print LOG scalar(localtime), ' check_attak() Нет нападений на ', $_, "\n";
			} elsif($resp[0] == 500){
				print LOG scalar(localtime), ' check_attak()  Ошибка связи с сервером', "\n"
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

sub check_attak_one($){
	#while(1){
		#check_scouts();
		#foreach(@dorf){
			#$targ = $_[0];
			print LOG 'check_attak_one() ', "$_[0] \n";
			undef my @res;
			@res = sender('get', "$url/dorf1.php?newdid=$_[0]");
			if($res[0] == 200){
				my $res = $res[1];
				#print LOG scalar(localtime), ' chek_attak_one() sender() вернул', " $res[0] \n";
				#print STR scalar(localtime), ' chek_attak_one() sender() вернул', " $res[0] \n $res[1] \n";

				#if($res eq 200){ print LOG $rec, " OK \n";
				my $tree = HTML::TreeBuilder -> new_from_content($res);
				my $table = $tree -> look_down( _tag => 'table', id => 'movements');
				if(defined $table){
					print $table -> as_HTML, "\n";
					@tr = $table -> look_down(_tag => 'tr');
					if(@tr){
						foreach(@tr){
							#print $_ -> as_HTML, "\n";
							$div = $_ -> look_down(_tag => 'div', class => 'mov');
							if(defined $div){
								# att1(a1) - нападение на вас  , att2(a2) - вы нападаете, att3(a3) - нападение на ваш оазис, def1(d1) - ваши возвращающиеся войска
								$span = $div -> look_down(_tag => 'span', class => 'a2'); #qr/a1|a3/
								if(defined $span){
									print $span -> as_text, "\n";
									print $span -> attr('class'), "\n";
									$span1 = $_ ->look_down(_tag => 'span', class => 'timer');
									my $timer = $span1 -> as_text;
									#print $resp, "\n";
									print LOG scalar(localtime), ' check_attak_one() Нападение через ', "$timer \n";
									return (200, $timer);
									#qx{mplayerc.exe sirena.mp3};
								} else {
									print LOG scalar(localtime), ' check_attak_one() нет значения', "\n";
									return @ret =(400);
								}
							}
						}
					}
				} else {
						#print LOG scalar(localtime), ' check_attak_one() Нет передвижений войск', "\n";
						return @ret = (400);
				}
			} else {
				#print LOG scalar(localtime), ' check_attak_one(). Ошибка связи с сервером',  "\n";
				return @ret = (500);
				}
			
		#}
	#}	
}

sub check_scouts{
	my @res = sender('get', "$url/berichte.php?t=0");
	if($res[0] == 200){
		my $res = $res[1];
		my $tree = HTML::TreeBuilder -> new_from_content($res);
		#if($res =~ m/class="messageStatus messageStatusUnread".{1,90}class="iReport iReport19".{1,210}<a href="berichte\.php\?id=(\w+\|\w+)&amp;t=3">/s){
		#if($res =~ m/class="messageStatus messageStatusUnread".{1,90}class="iReport iReport19"/s){
		my $tbody = $tree -> look_down(_tag => 'tbody');
		#if($tbody){print " TBODY $tbody", "\n";}
		my @tr = $tbody -> look_down(_tag => 'tr');
		if(@tr){
			foreach(@tr){
				undef my $img;
				#$img = $_ -> look_down(_tag => 'img', class => 'iReport iReport14 ');
				$img = $_ -> look_down(_tag => 'img', class => qr/^iReport iReport19\s?$/);
				if(defined $img){
					#print 'img: ', $img -> as_HTML, "\n";
					undef $img;
					$img = $_ -> look_down(_tag => 'img', class => 'messageStatus messageStatusUnread');
					if(defined $img){
						print LOG scalar(localtime), 'check_scouts() Кто-то разведывает', "\n";
						$alarm = threads -> create(\&mplay, '1.mp3');
					}
				}
			}
		}
				
	} else {print LOG scalar(localtime), ' check_scouts() Ошибка запроса', "\n"}
}


#sleep 900;
check_attak();
