﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("РазделНСИ", Истина);
	ОткрытьФорму("Обработка.ПанельОбменСЕГАИС.Форма.Форма",
	             ПараметрыФормы,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно, 
	             ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
