﻿
#Область ОбработчикиКоманд

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
	ОткрытьФорму("ОбщаяФорма.ОбменСПодключаемымОборудованием", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти