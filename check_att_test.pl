#!perl -w

#use strict;

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
				print STR scalar(localtime), ' chek_attak_one() sender() вернул', " $res[0] \n $res[1] \n";

				#if($res eq 200){ print LOG $rec, " OK \n";
				#if($res_ok =~ m/id="movements"/g){
				if($res =~ m/class="troopMovements header"/){
					#print LOG 'Сейчас здесь 1', "\n";
					while($res =~ m/class="([ad]\d+)">.+?id="timer\d+">(\d+:\d+:\d+)</gs){
						#print LOG $&, "\n";
						if($1 eq 'a1' or $1 eq 'a3'){
							# att1(a1) - нападение на вас  , att2(a2) - вы нападаете, att3(a3) - нападение на ваш оазис, def1(d1) - ваши возвращающиеся войска
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
				
				#my $tree = HTML::TreeBuilder -> new();
				my $tree = HTML::TreeBuilder -> new_from_content($res);
				#$tree ->parse_content($res);
				my @aaa = $tree -> guts();
				foreach (@aaa){
					print $_, "\n";
				
				#while($res =~ m/class="([ad]\d+)">.+?id="timer\d+">(\d+:\d+:\d+)</gs){
				#	#print LOG $&, "\n";
				#	if(($1 eq 'a1') or ($1 eq 'a3')){	
				#		# att1(a1) - нападение на вас  , att2(a2) - вы нападаете, def1(d1) - ваши возвращающиеся войска
				#		# att3(a3) - нападение на оазис
				#		print LOG scalar(localtime)," $_ нападение через: $2 \t Сон1 $sleep_time_chek_yes сек\. \n";
				#		@time = split(':',$3);
				#		$sec = $time[0]*3600;
				#		$sec += $time[1]*60;
				#		$sec += $time[2];
				#		#if($sec < 3000){
				#			#print LOG "Сон1 $sec сек\. \n";
				#			#sleep($sec);
				#			#send_mail("$2 attack $3");
				#			qx{mplayerc.exe 1.mp3};
				#		#	}
				#		$att = 200;	
				#		sleep 5;
				#	} 
				#}
				#unless($att){
				#	print LOG scalar(localtime), " $_ Пока не нападают \n";
				#	sleep 5;
				#	}
				
				
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
}

sub check_scouts{
	#my @res = sender('get', "$url/berichte.php?t=3");
		#if($res[0] == 200){
			#open AT, 'berichte.htm';
			my $tree = HTML::TreeBuilder -> new_from_file('berichte.htm');
			#my $aaa = $tree -> guts();
			#$tree -> look_down(_tag => 'ul', id => 'outOfGame');
			@aaa = $tree -> descendants();
			@dd = $tree -> find_by_tag_name('tr');
			foreach(@dd){
				print 'dd', ' = ', $_, "\n";
				@tt = $_ -> content_list();
				print @tt, "\t";
				print "\n";
				if(@tt == 2){
					foreach(@tt){
						$_ -> 
					}
				}
				#%e = %$_;
				#foreach(keys %e){
				#	#print $_, ' = ', $e{$_}, "\n";
				#	if($_ eq 'parent'){
				#		%r = %$e{$_};
				#		foreach(keys %r){
				#			print $_, ' = ', $r{$_}, "\n"; 
				#		}
				#	}
				#}
				#print "\n";
			}
			#@cont = $dd -> content_list();
			#foreach(@cont){print $_, "\n";}
			#print "\n";
			#foreach(@cont){
			#	%e = %$_;
			#	foreach(keys %e){
			#		print $_, ' = ', $e{$_}, "\n";
			#	}
			#	print "\n";
			#}
			#%q = %$dd;
			#foreach(keys %q){
				#print $_, ' = ', $q{$_}, "\n";
			#	if($_ eq '_parent'){
			#		$w = $q{$_};
			#		%w = %$w;
			#		foreach(keys %w){print $_, ' = ', $w{$_}, "\n"}
			#	}
				#if($_ eq '_content'){
				#	$h = $q{$_};
				#	print $h, "\n";
				#	@u = @$h;
				#	foreach(@u){print $u[$_], "\n"}
				#	}
				
			#}
			#print $dd, "\n";
			#foreach (@aaa){print $_, "\n"}
			#print $aaa, "\n";
			#%ss = %$aaa;
			#foreach (keys %ss){
			#	print $ss{$_}, "\n";}
			#my $tree = HTML::TreeBuilder -> pars_content($res);
		#}
}

#sleep 900;
#check_attak();
check_scouts();