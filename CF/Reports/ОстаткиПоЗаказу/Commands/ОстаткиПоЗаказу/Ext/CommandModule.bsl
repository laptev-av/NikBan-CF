﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Отчет.ОстаткиПоЗаказу.ФормаОбъекта", Новый Структура("Отбор, СформироватьПриОткрытии",
					Новый Структура("ЗаказПокупателя", ПараметрКоманды) , Истина),,, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
