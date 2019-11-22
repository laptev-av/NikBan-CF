﻿
#Область ПрограммныйИнтерфейс

// Возвращает структуру параметров заполнения табличной части.
// 
Функция СтруктураПараметрыЗаполнения() Экспорт

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ПересчитатьСумму",                   Ложь);
	ПараметрыЗаполнения.Вставить("ПересчитатьЦенуПоСумме",             Ложь);
	ПараметрыЗаполнения.Вставить("ПересчитатьКоличествоЕдиниц",        Ложь);
	ПараметрыЗаполнения.Вставить("ЗаполнитьИндексАкцизнойМарки",       Ложь);
	ПараметрыЗаполнения.Вставить("МаркируемаяАлкогольнаяПродукцияВТЧ", Ложь);
	ПараметрыЗаполнения.Вставить("ШтрихкодыВТЧ",                       Ложь);
	ПараметрыЗаполнения.Вставить("ПерезаполнитьНоменклатуруЕГАИС",     Ложь);
	ПараметрыЗаполнения.Вставить("ЗаполнитьАлкогольнуюПродукцию",      Ложь);
	ПараметрыЗаполнения.Вставить("ОбработатьУпаковки",                 Истина);
	ПараметрыЗаполнения.Вставить("ПроверитьСериюРассчитатьСтатус",     Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Вызывается при сканировании штрихкода в форме объекта.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая при завершении обработки,
//  Форма - УправляемаяФорма - форма, в которой отсканирован штрихкод,
//  Источник - Строка - источник внешнего события,
//  Событие - Строка - наименование события,
//  Данные - Строка - данные для события,
//  ПараметрыСканированияАкцизныхМарок - Структура - параметры сканирования акцизных марок.
//
Процедура ВнешнееСобытиеПолученыШтрихкоды(ОповещениеПриЗавершении, Форма, Источник, Событие, Данные, ПараметрыСканированияАкцизныхМарок = Неопределено) Экспорт
	
	Если Не Форма.ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(Форма.ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0 Тогда
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
			Истина, "ОбщийМодуль.СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды");
		
		ДанныеШтрихкода = СобытияФормЕГАИСКлиентПереопределяемый.ПреобразоватьДанныеСоСканераВСтруктуру(Результат.Параметр);
		
		АкцизныеМаркиЕГАИСКлиент.ОбработатьДанныеШтрихкода(
			ОповещениеПриЗавершении,
			Форма,
			ИнтеграцияЕГАИСКлиентСервер.ОбработатьДанныеШтрихкода(ДанныеШтрихкода),
			ПараметрыСканированияАкцизныхМарок);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при сканировании штрихкода в форме объекта.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой отсканирован штрихкод,
//  Источник - Строка - источник внешнего события,
//  Событие - Строка - наименование события,
//  Данные - Строка - данные для события,
//  КэшированныеЗначения - Структура - кэш формы документа.
//
Процедура ВнешнееСобытиеОбработатьВводШтрихкода(Форма, Источник, Событие, Данные, КэшированныеЗначения) Экспорт
	
	Если Не Форма.ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(Форма.ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0 Тогда
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
			Истина, "ОбщийМодуль.СобытияФормЕГАИСКлиент.ВнешнееСобытиеОбработатьВводШтрихкода");
		
		ДанныеШтрихкода = СобытияФормЕГАИСКлиентПереопределяемый.ПреобразоватьДанныеСоСканераВСтруктуру(Результат.Параметр);
		
		АкцизныеМаркиЕГАИСКлиент.ОбработатьВводШтрихкода(
			Форма,
			ИнтеграцияЕГАИСКлиентСервер.ОбработатьДанныеШтрихкода(ДанныеШтрихкода),
			КэшированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызыввается при наступлении события "Выбор" в табличной части.
// Открывает форму выбранного элемента, если имя реквизита входит в массив имен.
//
// Параметры:
// Форма - УправляемаяФорма - форма объекта,
// ТаблицаФормы - таблица формы - таблица в которой произошло событие,
// ВыбранноеПоле - поле формы
Процедура ВыборЭлементаТабличнойЧастиОткрытьФормуЭлемента(Форма, ТаблицаФормы, ВыбранноеПоле) Экспорт
	
	МассивИмен = МассивИменРеквизитовФормыОткрытия();
	
	ИмяТабличнойЧасти = ТаблицаФормы.Имя;
	
	Для Каждого ИмяЭлемента Из МассивИмен Цикл
		
		Если Форма.Элементы.Найти(ИмяТабличнойЧасти + ИмяЭлемента) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Форма.Элементы[ИмяТабличнойЧасти + ИмяЭлемента] = ВыбранноеПоле Тогда
			НавигационннаяСсылка = ПолучитьНавигационнуюСсылку(ТаблицаФормы.ТекущиеДанные[ИмяЭлемента]);
			ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационннаяСсылка);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Функция МассивИменРеквизитовФормыОткрытия()
	
	Массив = Новый Массив;
	Массив.Добавить("АлкогольнаяПродукция");
	Массив.Добавить("Справка2");
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти
