﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
	ПараметрЗаполнен = Ложь;
	
	ПараметрПравило = ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "ПравилоЦенообразования");
	ПараметрЗаполнен   = ПроверитьЗаполненностьПараметра(ПараметрПравило);
	
	ПараметрПравило = ПолучитьПараметр(КомпоновщикНастроек.Настройки, "ПравилоЦенообразования");
	ПараметрЗаполнен   = ПроверитьЗаполненностьПараметра(ПараметрПравило) Или ПараметрЗаполнен;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Осуществляет проверку заполненности параметра компоновки.
//
// Параметры:
// Параметр - ЗначениеПараметраНастроекКомпоновкиДанных - параметр, заполненность которого необходимо проверить.
//
// Возвращаемое значение:
// Булево - Истина, если параметр заполнен, Ложь, в противном случае.
//
Функция ПроверитьЗаполненностьПараметра(Параметр)
	
	Если Параметр <> Неопределено Тогда
		
		ЗначениеПараметра = Параметр.Значение;
		ТипПараметра      = ТипЗнч(ЗначениеПараметра);
		ПараметрЗаполнен  = ЗначениеЗаполнено(ЗначениеПараметра);
		
		Если ТипПараметра = Тип("СписокЗначений") Тогда
			Если ЗначениеПараметра.Количество() = 0 Тогда
				ПараметрЗаполнен = Ложь;
			Иначе
				ПараметрЗаполнен = Истина;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ПараметрЗаполнен = Ложь;
		
	КонецЕсли;
	
	Возврат ПараметрЗаполнен;

КонецФункции

// Получает параметр из компоновщика настроек.
Функция ПолучитьПараметр(Настройки, Параметр) Экспорт
	
	ЗначениеПараметра = Неопределено;
	ПолеПараметр = ?(ТипЗнч(Параметр) = Тип("Строка"), Новый ПараметрКомпоновкиДанных(Параметр), Параметр);
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
КонецФункции

#КонецОбласти

#КонецЕсли
