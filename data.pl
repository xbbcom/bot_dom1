﻿#!perl -w
# Имя сервера, ваш логин и пароль
$url = 'http://ts2.travian.ru';
$name = 'xbb';
$pass = 'frodo';
# Массив идентификаторов ваших деревень
#@dorf = (139684, 109337, 25837);
#Массив фармящих деревень
%dorf_farm = ('@farm_bd' => 25837, '@farm_bd1' => 139684);

#Идентификаторы моих деревень (используется в farm.pl)
$dorf_farm1 = 40526;
			
#Массив для постройки войск. (Тип войск  => количество войнов)
%build_arm = ('t1' => 1);			
			
# Тип атаки: 2- подкрепление, 3- обычная атака, 4- атака набег
$type_att = 4;
# Улучшение зданий. Перечислить номера клеток на которых нужно улучшить здание
@build = (19, 20, 12, 24, 13, 26);
@build_1 = (40, 26);
@build_0 = (20, 40);
# Переменная определяет время засыпания при отсутствии нужных войск для атаки
$sleep_time_farm = 360;
# Переменная определяет время засыпания при проверке нападения на вас, если нападения нет
$sleep_time_chek_no = 300;
# Переменная определяет время засыпания при проверке нападения на вас, если нападение есть
$sleep_time_chek_yes = 240;


