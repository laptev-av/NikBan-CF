﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
	ОбновитьНаименованиеКомандФормы();
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Объект.ИспользоватьОтборПоОрганизациям И Объект.Организации.Количество() <> 0 Тогда
		Объект.Организации.Очистить();
	ИначеЕсли Объект.ИспользоватьОтборПоОрганизациям И Объект.Организации.Количество() = 0 Тогда
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если Не Объект.ИспользоватьОтборПоСкладам И Объект.Склады.Количество() <> 0 Тогда
		Объект.Склады.Очистить();
	ИначеЕсли Объект.ИспользоватьОтборПоСкладам И Объект.Склады.Количество() = 0 Тогда
		Объект.ИспользоватьОтборПоСкладам = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизацийНажатие(Элемент)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхМагазиновНажатие(Элемент)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Склады");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Склад");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Магазины");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите магазины для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоСкладамПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;

КонецФункции

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	Если Объект.Организации.Количество() > 0 Тогда
		ВыбранныеОрганизации = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации);
	Иначе
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	Если Объект.Склады.Количество() > 0 Тогда
		ВыбранныеСклады = Объект.Склады.Выгрузить().ВыгрузитьКолонку("Склад");
		НовыйЗаголовокСкладов = СтрСоединить(ВыбранныеСклады);
	Иначе
		НовыйЗаголовокСкладов = НСтр("ru = 'Выбрать магазины'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхСкладов.Заголовок = НовыйЗаголовокСкладов;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы,
	"ИспользоватьОтборПоОрганизациям",
	"Видимость",
	ИспользоватьНесколькоОрганизаций);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы,
	"ОткрытьСписокВыбранныхОрганизаций",
	"Видимость",
	ИспользоватьНесколькоОрганизаций);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы,
	"ОткрытьСписокВыбранныхОрганизаций",
	"Доступность",
	Объект.ИспользоватьОтборПоОрганизациям);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы,
	"ОткрытьСписокВыбранныхСкладов",
	"Доступность",
	Объект.ИспользоватьОтборПоСкладам);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
		Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

#КонецОбласти