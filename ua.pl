#!perl -w

use HTTP::Cookies;
use LWP::UserAgent;
#use LWP::Debug qw(+debug);
#use LWP::Debug qw(+conns);
#require "login_1.pl";
open STR, "+>str.htm";
open LOG, "+>>log.txt";
#my($metod, $t_ur, $par);
#ua('post', 'ts3.travian.ru/dorf1.php');
sub ua($$;$){
#print "goooooo \n";
#foreach @_ {$p.(keys $_) = $_}
$ua = LWP::UserAgent->new;
$ua->agent('Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.9.168 Version/11.50');
#$ua->agent('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; ru)');
$ua->default_header(
     'Accept' => 'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1',
     'Accept-Language' => 'ru-RU,ru;q=0.9,en;q=0.8',
     'Accept-Charset' => 'iso-8859-1, utf-8, utf-16, *;q=0.1',
     'Connection' => 'Keep-Alive, TE',
     'TE' => 'deflate, gzip, chunked, identity, trailers');
$ua->cookie_jar(HTTP::Cookies->new(file => "cookies.txt", autosave => 1, ignore_discard=>1));
push @{$ua->requests_redirectable}, 'POST';
#print LOG "Debug \t $r \n";

#sub ua($$;$){
#print "goooooo \n";
($ua_metod, $ua_t_url) = @_;
if(defined $_[2]){
	$ua_par = $_[2];
	#print LOG scalar(localtime), ' ua()'," Три параметра $ua_metod $ua_t_url $ua_par \n";
	ua_send_three($ua_metod, $ua_t_url, $ua_par);
	} else {
		#print LOG scalar(localtime), ' ua()', " Два параметра $ua_metod $ua_t_url \n";
		ua_send_two($ua_metod, $ua_t_url);
		}
}

sub ua_send_two($$){
	$resp = $ua->$ua_metod("$ua_t_url");
	#LWP::Debug::conns();
	if ($resp->is_success) {
		$ras = 0;
		$resp_all = $resp->as_string;
		#print STR 'ua_send_two($$)', "\n $resp_all \n";
		#$resp_body = $resp->content;
		return(200, $resp_all);
		} else {
			print LOG scalar(localtime), " Error: " . $resp->status_line . "\n" . $resp->is_error . "\n";
			#$ras++;
			sleep 10;
			#if ($ras <= 10){
				ua_send_two($ua_metod, $ua_t_url);
			#	} else {
			#		dialup();
			#		$ras = 0;
			#		ua_send_two($ua_metod, $ua_t_url);
			#		}
			}
}

sub ua_send_three($$$){
	my $resp = $ua->$ua_metod("$ua_t_url", $ua_par);
	if ($resp->is_success) {
		$ras = 0;
		my $resp_all = $resp->as_string;
		#print STR 'ua_send_three($$$)', "\n $resp_all \n";
		#$resp_body = $resp->content;
		return(200, $resp_all);
		} else {
			print LOG scalar(localtime), " Error: " . $resp->status_line . "\n" . $resp->is_error . "\n";
			#$ras++;
			sleep 10;
			#if ($ras <= 10){
				ua_send_three($ua_metod, $ua_t_url, $ua_par);
			#	} else {
			#		dialup();
			#		$ras = 0;
			#		ua_send_three($ua_metod, $ua_t_url, $ua_par);
			#		}
			}
}

sub dialup{
	$f = qx(rasdial /d);
	if($f =~ m/Команда успешно выполнена/){
		print LOG scalar(localtime), ' dialup() Успешно отключились',  "\n";
		sleep 60;
		$f = qx(rasdial GPRS);
		if($f =~ m/Команда успешно завершена/){
			print LOG scalar(localtime), ' dialup() Успешно подключились', "\n";
		} else {
			print LOG scalar(localtime), ' dialup() Почему-то не подключились',  "\n";
			sleep 10;
			dialup();
			}
		sleep 10;
	} else {
		print LOG scalar(localtime), ' dialup() Почему-то не отключились',  "\n";
		sleep 10;
		dialup();
		}	
}
#@s = ua('post', 'http://ts3.travian.ru/dorf1.php');
#print STR 'ua.pl ',"\n @s \n";