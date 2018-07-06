#!perl -w

# В отличии от /bot1/build.pl строит здания и войска по очереди

require "login.pl";
#require "ua.pl";
open STR1, "+>str1.htm";
#open CONT1, "+>cont1.txt";
#open STR2, "+>str2.txt";
#open CONT2, "+>cont2.txt";

#if($login_true eq 200){
#	print LOG $login_true, " OK \n";
#	build();
#	} elsif ($login_true eq 700){ captcha($f = 'build');
#		} elsif ($login_true eq 400){
#			print LOG 'build()', " Вход не осуществлен \t $login_true \n";
			#login();
#			}
	
sub build {
	while(@build){
		$build = shift @build;
		print LOG 'build()', " $build, \n";
		if($build =~ m/^t/){
			build_army($build);
			} else {
				chek_build_2();
				chek_build_1();			
				$t = chek_build_4();
				if($t eq 400){redo;}
			}
	} 
	print LOG scalar(localtime)," Все здания выполнены \n";
}

sub chek_build_1 {
		my @res = sender('get', "$url/dorf1.php");
		if($res[0] eq 200){
			$res = $res[1];
			#print STR1 'chek_build_1()', " $res[0] \n $res \n";
				#$res_str = $res->as_string;
				#print STR1 $res_str;
				#print CONT1 $res_ok;
			if ($res =~ m/class="boxes buildingList">.+?id="timer\d+">(\d+:\d+:\d+)</s){
				@time = split(':',$1);
				$sec = $time[0]*3600;
				$sec += $time[1]*60;
				$sec += $time[2];
				print LOG scalar(localtime)," Все строители заняты. Сон на $sec сек\.\n";
				sleep $sec;
				chek_build_1();
				} else {
					$res =~ m/id="res".+?class="r1".+?>(\d+)\/\d+</s;
						$now_build[0] = $1;
					$res =~ m/id="res".+?class="r2".+?>(\d+)\/\d+</s;
						$now_build[1] = $1;
					$res =~ m/id="res".+?class="r3".+?>(\d+)\/\d+</s;
						$now_build[2] = $1;
					$res =~ m/id="res".+?class="r4".+?>(\d+)\/\d+</s;
						$now_build[3] = $1;
					#foreach(@now_build){
					#	print LOG '@now_build', " $_ \n";}
					#return 200;
					}	
			}
}
		
sub chek_build_2 {	
		my @res = sender('get', "$url/build.php?id=$build");
		if($res[0] eq 200){
			$res = $res[1];
			#print STR1 'chek_build_2()', " $res[0] \n $res \n";
			#print CONT1 $res_ok;
			$res =~ m/class="titleInHeader">\s*(.+?)\s*</s;
			$name_build = $1;
			#print LOG 'chek_build_2', " $name_build \n";
		
		$res =~ m/class="showCosts">.+?class="r1".+?\/>(\d+)<\//s;
			$res_build[0] = $1;
		$res =~ m/<div class="showCosts">.+?class="r2".+?\/>(\d+)<\//s;
			$res_build[1] = $1;
		$res =~ m/<div class="showCosts">.+?class="r3".+?\/>(\d+)<\//s;
			$res_build[2] = $1;
		$res =~ m/<div class="showCosts">.+?class="r4".+?\/>(\d+)<\//s;
			$res_build[3] = $1;	
			
		#foreach(@res_build){
		#	print LOG 'chek_build_2 ', " $_ \n";}
		#return $res;	
		}
}

sub chek_build_4() {
	if(($now_build[0] >= $res_build[0]) && ($now_build[1] >= $res_build[1]) && ($now_build[2] >= $res_build[2]) && 
			($now_build[3] >= $res_build[3])){
		my @res = sender('get', "$url/build.php?id=$build");
		if($res[0] eq 200){
			$res = $res[1];
			#print STR1 'chek_build_4()', " $res[0] \n $res \n";	
		if($build <= 18){$url_2 = "dorf1"} else {$url_2 = "dorf2";}
			if($res =~ m/class="build".+?'$url_2\.php\?a=$build&amp;c=(\w+)'/){
		#if($res =~ m/class="build".+?onclick="window.location.href\s*=\s*'$url_2\?(.+?)'/){
			#my @par = split /&amp;/, $1;
			#foreach(@par){											набросок постройки зданий с нуля
			#	($w, $ww) = split /=/, $_;
			#	my %par = ($w => $ww);
			#	}
				#print LOG 'chek_build_4()'," c = $1 \n";
				#print LOG 'chek_build_4()'," $1 \n";
				@res = sender('get', "$url/$url_2.php?a=$build&c=$1");
				#@res = sender('get', "$url/$1");
				if($res[0] eq 200){
					$res = $res[1];
					#print STR2 $res_str;
					#print CONT2 $res_ok;
					#chek_build();
					if($res =~ m/class="boxes buildingList">.+?$name_build/s){
					print LOG scalar(localtime)," Здание $build успешно строится \n";
					#return 200;
					} else {print LOG scalar(localtime), " Ошибка передачи параметров \n";
						return 400;
						}
				} 
			}
		}
	} else {
		print LOG scalar(localtime)," Недостаточно ресурсов Сон на 1200 сек\.\n";
		sleep 1200;
		chek_build_1();
		chek_build_4();
		}
}

sub build_army($){
	
}

sub build_argv($){
		$build = $_[0];
		print STDOUT 'build', " $build, \n";
		chek_build_2();
		chek_build_1();			
		$t = chek_build_4();
		if($t eq 400){redo;}
}

if(@ARGV){
	build_argv($ARGV[0]);
	} else {
		build();
		}					
		#if($res =~ m/class="contractLink">.+?Ресурсов будет достаточно (\d+\.\d+\.) в (\d+:\d+)</s){
		#	@time = split(':',$1);
		#	$sec = $time[0]*3600;
		#	$sec += $time[1]*60;
		#	$sec += $time[2];
		#				print LOG scalar(localtime)," Ресурсов будет достаточно $1 в $2\. Сон на $sec сек\.\n";
		#				sleep $sec;
		#				chek_build_1();
		#				} elsif {
		#					$res_ok =~ m/class="contractLink">.+?href = '(dorf\d+.php\?a=\d+&amp;id=$build&amp;c=\w+)';/s;
		#					$b_q = $1
		#					print LOG $b_q, "\n";
		#					return(200, $b_q);
		#					} else {chek_build_2()};
		#		}	
	#		else {	
	#	$res_ok1 =~ m/id="res".+?class="r1".+?>(\d+)\/\d+</s;
	#		$now_build[0] = $`1;
	#	$res_ok1 =~ m/id="res".+?class="r2".+?>(\d+)\/\d+</s;
	#		$now_build[1] = $1;
	#	$res_ok1 =~ m/id="res".+?class="r3".+?>(\d+)\/\d+</s;
	#		$now_build[2] = $1;
	#	$res_ok1 =~ m/id="res".+?class="r4".+?>(\d+)\/\d+</s;
	#		$now_build[3] = $1;
	#		}
		