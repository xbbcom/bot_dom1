#!perl -w

use Net::SMTP;
open LOG, "+>>log.txt";

sub send_mail($){
			print LOG scalar(localtime), ' send_mail($) получил сообщение', " $_[0] \n";

			#$smtp = Net::SMTP->new('smtp.mail.ru', Debug=>1);
			#$smtp->auth('vovvva@mail.ru', 'comacu30_77');
			#$smtp->mail('vovvva@mail.ru');
				
            $smtp = Net::SMTP->new('smtp.pochta.ru', Debug=>1);
            $smtp->auth('gravis@pochta.ru', 'tetris');
            $smtp->mail('gravis@pochta.ru');
			
			#$smtp = Net::SMTP->new('smtp.yandex.ru', Debug=>1);
            #$smtp->auth('xbbcom@yandex.ru', 'fromfex');
            #$smtp->mail('xbbcom@yandex.ru');
			   
			#$smtp->to('79624177776@sms.beemail.ru');
			$smtp->to('vovvva@mail.ru');
			#$smtp->to('gravis@pochta.ru');
			#$smtp->to('xbbcom@yandex.ru');
		  
								
			$smtp->data();
			   
			$smtp->datasend('From:gravis@pochta.ru',"\n");
			#$smtp->datasend('From:xbbcom@yandex.ru',"\n");
			#$smtp->datasend('From:vovvva@mail.ru',"\n");
			#$smtp->datasend('From:79624177776@sms.beemail.ru',"\n");
			   
			#$smtp->datasend('Content-Type: text/plain; charset=utf-8',"\n");
			#$smtp->datasend('Content-Transfer-Encoding: 8bit',"\n");
               
			#$smtp->datasend('To:79624177776@sms.beemail.ru',"\n");
			#$smtp->datasend('To:gravis@pochta.ru',"\n");
			$smtp->datasend('To:vovvva@mail.ru',"\n");
			#$smtp->datasend('To:xbbcom@yandex.ru',"\n"); 
								
			$smtp->datasend("\n");
			#$smtp->datasend(scalar(localtime));
			$smtp->datasend(scalar(localtime), $_[0]);
			$smtp->dataend();
			$smtp->quit;
			#return 200;
}
#send_mail('aaa');