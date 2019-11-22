﻿
#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученМагнитныйКод(МагнитныйКод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	Иначе
		
		Запись.Номенклатура = СтрокаРезультата.Номенклатура;
		Если СтрокаРезультата.Свойство("Характеристика") Тогда
			Запись.Характеристика = СтрокаРезультата.Характеристика;
		Иначе
			Запись.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
		КонецЕсли;
		ПриИзмененииНоменклатуры();
		
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись[ДополнительныеПараметры.ИмяРеквизита] = Результат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		ХарактеристикиИспользуются = Справочники.Номенклатура.ПроверитьИспользованиеХарактеристик(Запись.Номенклатура);
		Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	КонецЕсли;

	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	ИдентификаторПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	ХарактеристикиИспользуются = Справочники.Номенклатура.ПроверитьИспользованиеХарактеристик(Запись.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	ИдентификаторПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если ХарактеристикиИспользуются 
		И НЕ ЗначениеЗаполнено(Запись.Характеристика) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Характеристика"" не заполнено'"),
			,
			"Запись.Характеристика",
			,
			Отказ);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.НоменклатураПоставщиков.Форма.ФормаЗаписи.Открытие");
             
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(ЭтаФорма, Элемент, СтандартнаяОбработка, Запись);
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", Запись.Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", Запись.Характеристика);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", 0);
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)

	ПриИзмененииНоменклатуры();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииНоменклатуры()
	
	Если ЗначениеЗаполнено(Запись.Номенклатура) Тогда
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);

		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Номенклатура", Запись.Номенклатура);
		СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
		СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);

		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

		ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
		
		ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
		Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	ИдентификаторПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ИдентификаторПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Запись.Идентификатор) Тогда
		Элементы.Магазин.Доступность = Ложь;
		Если ЗначениеЗаполнено(Запись.Магазин) Тогда
			Запись.Магазин = Справочники.Магазины.ПустаяСсылка();
			ЭтотОбъект.Модифицированность = Истина;
		КонецЕсли;
	Иначе
		Элементы.Магазин.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
