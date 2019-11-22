﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБЩЕГО НАЗНАЧЕНИЯ 

#Область ПрограммныйИнтерфейс

#Если НЕ Клиент И НЕ ВнешнееСоединение Тогда
	
// Функция возвращает значение экспортных переменных модуля приложений из параметра сеанса.
// Необходимо для возможности создания объектов на сервере.
Функция глЗначениеПеременной(Имя) Экспорт
	
	Кэш = ПараметрыСеанса.ОбщиеЗначения.Получить();
	КэшИзменен = Ложь;
	ПолученноеЗначение = ОбщегоНазначенияРТ.ПолучитьЗначениеПеременной(Имя, Кэш, КэшИзменен);
	
	Если КэшИзменен Тогда
		ПараметрыСеанса.ОбщиеЗначения = Новый ХранилищеЗначения(Кэш);
	КонецЕсли;
	
	Возврат ПолученноеЗначение;
	
КонецФункции

// Процедура установки значения экспортных переменных модуля приложения.
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
//  Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	Кэш = ПараметрыСеанса.ОбщиеЗначения.Получить();
	ОбщегоНазначенияРТ.УстановитьЗначениеПеременной(Имя, Кэш, Значение);
	ПараметрыСеанса.ОбщиеЗначения = Новый ХранилищеЗначения(Кэш);
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти
