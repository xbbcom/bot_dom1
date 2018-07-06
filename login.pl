#!perl -w
require "data.pl";
require "mailto.pl";
require "ua.pl";
open STR, "+>str.htm";
#open CONT, "+>cont.txt";
open LOG, "+>>log.txt";
select LOG;
$| = 1;

sub sender($$;$){
	
	($metod, $t_url) = @_;
	#print LOG 'sender() ', "$metod, $t_url \n";
	if(defined $_[2]){
		$par = $_[2];
		$x = 3;
		#print LOG scalar(localtime), ' sender()',' передал три параметра ua()', " $metod, $t_url, $par \n";
		#print STR scalar(localtime), ' sender()',' передал три параметра ua()', " $metod, $t_url, $par \n";
		@res = undef;
		@res = ua($metod, $t_url, $par);
		#print LOG scalar(localtime), ' sender()',' ua() вернул', " $res[0] \n";
		#print STR scalar(localtime), ' sender()',' ua() вернул', " $res[0] \n $res[1] \n";
		} else {
			$x = 2;
			#print LOG scalar(localtime), ' sender()',' передал два параметра ua()', " $metod, $t_url \n";
			#print STR scalar(localtime), ' sender()',' передал два параметра ua()', " $metod, $t_url \n";
			@res = ua($metod, $t_url);
			#print LOG scalar(localtime), ' sender()',' ua() вернул', " $res[0] \n";
			#print STR scalar(localtime), ' sender()',' ua() вернул', " $res[0] \n $res[1] \n";
			}
	if($res[0] == 200){
		$res = $res[1];
		#print LOG 'sender()'," Первая попытка входа. $res[0] \n";
		#print STR 'sender()'," Первая попытка входа. $res[0] \n $res[1] \n";
		$t = captcha($res, "sender_0");	
		if( $t == 400){
           # что-то зделать при появлении капчи
		} elsif ($t == 200){
				$t = chek_login($res);
				#print LOG 'chek_login() 1 вернул ', "$t \n";
				if($t == 200){
					print LOG scalar(localtime), ' sender()', " Успешный вход 1 \n";
					#print STR scalar(localtime), ' sender() Успешный вход 1',"\n $res \n";
					#$login_true = 200;
					return(200, $res);
					} elsif($t == 400){
						print LOG scalar(localtime),' sender()', " Вход не выполнен 1 \n";
						#print STR ' sender() Вход не выполнен 1', "\n $res \n";
						$t = undef;
						$t = login($res);
						if($t == 200){
							print LOG scalar(localtime),' sender()', " Успешный вход 2 \n";
							#print STR ' sender() Вход выполнен 1', "\n $res \n";
							if($x eq 2){
								#print LOG scalar(localtime),' sender() Отправили', " $metod и $t_url \n";
								@res = sender($metod, $t_url);
								#print LOG 'sender() sender() 2 вернул', " $res[0] \n";
								#print STR 'sender() sender() 2 вернул', " $res[0] \n $res[1] \n";	
								} elsif($x eq 3){
									#print LOG scalar(localtime),' sender() Отправили', " $metod, $t_url и $par \n";
									@res = sender($metod, $t_url, $par);
									#print LOG 'sender() sender() 2 вернул', " $res[0] \n";
									#print STR 'sender() sender() 2 вернул', " $res[0] \n $res[1] \n";
									}
							}
						}	
				}
	}	
}			
		
sub login($){
	$res =~ m/<input type="hidden" name="login" value="(\d+)" \/>/s;
	#print LOG 'login() ', "\$1"," = ", "$1 \n";
	$login = $1;
	#print LOG 'login() ', "\$login"," = ", "$1 \n";
	#name=xbb&password=frodo&lowRes=1&s1=%D0%92%D0%BE%D0%B9%D1%82%D0%B8&w=1200%3A800&login=1316527992
	%form = ('name' => $name, 'password' => $pass, 'lowRes' => 1, 's1' => '%D0%92%D0%BE%D0%B9%D1%82%D0%B8',
		'w' => '1200%3A800', 'login' => $login);
	#print LOG 'login() %form:', "\n";
	#foreach(keys %form){
	#	print LOG "$_"," = ", "$form{$_} \n";}
	@res = undef;	
    @res = ua("post", "$url/dorf1.php", \%form);
	if($res[0] == 200){
		$res = $res[1];
		#print LOG 'login()'," Вторая попытка входа. $res[0] \n";
		#print STR 'login()'," Вторая попытка входа. $res[0] \n $res \n";
		$t = captcha($res, "login_0");
		if($t == 400){
            # что-то зделать при появлении капчи
		} elsif ($t == 200){
            $t = chek_login($res);	
			if($t == 200){
				#@dorf = $res =~ m/href="\?newdid=(\d+)"/g;
				return 200;
				} elsif ($t == 400){
					print LOG scalar(localtime), ' login()', " Вход не выполнен 2\. Проверьте логин и пароль \n";
					print STR 'login() Вход не выполнен 2', "\n $res \n";
					sleep 30;
					login($res);
					}
			}
				
	}
}                        

sub chek_login($){
        my $res_ch_log = $_[0];
		#print STR 'chek_login($)', "\n", "$res_ch_log \n";
        if($res_ch_log =~ m/id="navigation"/){
            #$resp_body = $resp->content;
			#print LOG 'chek_login($)',"\t 200 \n";
            return 200;
        } else {
			#print LOG 'chek_login($)',"\t 400 \n";
            return 400;
            }
}

sub captcha($$){
		if($_[0] =~ m/CAPTCHA-контроль активирован/){
			print LOG scalar(localtime)," $_[1] CAPTCHA-контроль активирован \n";
			#print STR $res_str;
			#print CONT $res_ok;
			send_mail("$_[1] CAPTCHA-контроль активирован");
			qx{mplayerc.exe 1.mp3};
			sleep 700;
			return 400;
			} else { return 200;}
}