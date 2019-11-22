﻿#Область ПрограммныйИнтерфейс

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Модуль = Вычислить(Имя);
	
#Если НЕ ВебКлиент Тогда
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ТекстИсключения = НСтр("ru = 'Общий модуль ""%1"" не найден.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения,"%1", Имя);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

// Форма списка, в которой устанавлиается отбор
//
Процедура ПриОткрытииСпискаОчереди(ЭтотОбъект, Список) Экспорт
	
	Параметры = РассылкаЭлектронныхЧековКлиентПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеБСП Тогда
		
		// Вставить содержимое обработчика.
		ОбщийМодуль("ОбщегоНазначенияКлиентСервер").УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"ПроизошлаОшибкаПередачи", 
			ЭтотОбъект.ОтборПоОшибкам,
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			ЭтотОбъект.ОтборПоОшибкам);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура отправляет электронное сообщение на электронную почта и абонентский номер.
//
Процедура НачатьОтправкуЭлектронногоЧека(ПараметрыЧека, ТекстСообщения, ПокупательEmail, ПокупательНомер) Экспорт
	
	РассылкаЭлектронныхЧековВызовСервера.НачатьОтправкуЭлектронногоЧека(ПараметрыЧека, ТекстСообщения, ПокупательEmail, ПокупательНомер);
	
КонецПроцедуры

// Процедура открывает форму настройки отправки электронных чеков
//
Процедура НастроитьОтправкуЭлектронныхЧеков() Экспорт
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияРТ.Форма.Продажи");
	
КонецПроцедуры

#КонецОбласти
