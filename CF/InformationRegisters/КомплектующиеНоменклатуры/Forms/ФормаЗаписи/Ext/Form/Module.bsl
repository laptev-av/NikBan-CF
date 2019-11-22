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
		
		Если ТекущийЭлемент = Элементы.Номенклатура
			ИЛИ ТекущийЭлемент = Элементы.Характеристика Тогда
			Запись.Номенклатура = СтрокаРезультата.Номенклатура;
			Если СтрокаРезультата.Свойство("Характеристика") Тогда
				Запись.Характеристика = СтрокаРезультата.Характеристика;
			Иначе
				Запись.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			КонецЕсли;
			ПриИзмененииНоменклатуры();
		Иначе
			Запись.Комплектующая = СтрокаРезультата.Номенклатура;
			Если СтрокаРезультата.Свойство("Характеристика") Тогда
				Запись.ХарактеристикаКомплектующей = СтрокаРезультата.Характеристика;
			Иначе
				Запись.ХарактеристикаКомплектующей = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			КонецЕсли;
			ПриИзмененииКомплектующей();
		КонецЕсли;
		
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
	
	Если Параметры.Свойство("Ключ")
		И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		Если ЗначениеЗаполнено(Параметры.Ключ.Номенклатура) Тогда
			Элементы.Номенклатура.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.Ключ.Характеристика) Тогда
			Элементы.Характеристика.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	Иначе
		
		Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
			
			Если Параметры.ЗначенияЗаполнения.Свойство("Номенклатура") Тогда
				
				Номенклатура = Параметры.ЗначенияЗаполнения.Номенклатура;
				Если Номенклатура <> Неопределено 
					И ЗначениеЗаполнено(Номенклатура) Тогда
					
					Элементы.Номенклатура.ТолькоПросмотр = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если Параметры.ЗначенияЗаполнения.Свойство("Характеристика") Тогда
				
				Характеристика = Параметры.ЗначенияЗаполнения.Характеристика;
				Если Характеристика <> Неопределено 
					И ЗначениеЗаполнено(Характеристика) Тогда
					
					Элементы.Характеристика.ТолькоПросмотр = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		УстановитьДоступностьХарактеристикУпаковки();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	// Конец ПодключаемоеОборудование

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьДоступностьХарактеристикУпаковки()
	
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

	Если ХарактеристикиКомплектующейИспользуются 
		И НЕ ЗначениеЗаполнено(Запись.ХарактеристикаКомплектующей) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Характеристика комплектующей"" не заполнено'"),
			,
			"Запись.ХарактеристикаКомплектующей",
			,
			Отказ);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
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
Процедура НоменклатураПриИзменении(Элемент)
	
	ПриИзмененииНоменклатуры();
	
КонецПроцедуры

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
Процедура КомплектующаяПриИзменении(Элемент)
	
	ПриИзмененииКомплектующей();
	
	Если ЗначениеЗаполнено(Запись.Комплектующая) Тогда 
		ПроверитьДробноеКоличествоЗаписи();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаКомплектующейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Запись.Комплектующая) Тогда
		ВладелецХарактеристики = Неопределено;
		Если ОбработкаТабличнойЧастиТоварыВызовСервера.ПроверитьИспользованиеХарактеристикИПолучитьВладельцаДляВыбора(Запись.Комплектующая, ВладелецХарактеристики) Тогда
			
			Если ВладелецХарактеристики = Неопределено Тогда
				ПоказатьПредупреждение(,НСтр("ru = 'Для данной номенклатуры характеристики не заданы.'"));
            Иначе
                
                // &ЗамерПроизводительности
                ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                         Истина, "Справочник.ХарактеристикиНоменклатуры.Форма.ФормаВыбора.Открытие");

                ПараметрыФормыВыбора = Новый Структура;
				ПараметрыФормыВыбора.Вставить("ТекущийЭлемент"  , Запись.Характеристика);
				ПараметрыФормыВыбора.Вставить("ПараметрВладелец", ВладелецХарактеристики);
				ПараметрыФормыВыбора.Вставить("Номенклатура"    , Запись.Комплектующая);
				
				ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыФормыВыбора, Элемент);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ХарактеристикаКомплектующейСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", Запись.Комплектующая);
	ТекущаяСтрока.Вставить("Характеристика", Запись.ХарактеристикаКомплектующей);
	ТекущаяСтрока.Вставить("ХарактеристикаКомплектующей", Запись.ХарактеристикаКомплектующей);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", 0);
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, 
																		  Элемент, 
																		  СтандартнаяОбработка, 
																		  ТекущаяСтрока,
																		  ,
																		  "ХарактеристикаКомплектующей");
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Запись.Комплектующая) Тогда
		ДанныеВыбора = Новый СписокЗначений;
		ОбработкаТабличнойЧастиТоварыВызовСервера.ПолучитьСписокДляВыбораУпаковок(Запись.Комплектующая, ДанныеВыбора, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.Комплектующая) Тогда 
		ПроверитьДробноеКоличествоЗаписи();
	КонецЕсли;
	
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
Процедура УстановитьДоступностьХарактеристикУпаковки(ИмяПоля = "");
	
	Если ИмяПоля = "" ИЛИ ИмяПоля = "Номенклатура" Тогда
		ХарактеристикиИспользуются = Справочники.Номенклатура.ПроверитьИспользованиеХарактеристик(Запись.Номенклатура);
		Элементы.Характеристика.ТолькоПросмотр = НЕ ХарактеристикиИспользуются;
		Элементы.Характеристика.АвтоОтметкаНезаполненного = ХарактеристикиИспользуются;
		Элементы.Характеристика.ОтметкаНезаполненного = ХарактеристикиИспользуются;
		
		Если НЕ ХарактеристикиИспользуются И ЗначениеЗаполнено(Запись.Номенклатура) Тогда
			Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
		Иначе
			Элементы.Характеристика.ПодсказкаВвода = "";
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяПоля = "" ИЛИ ИмяПоля = "Комплектующая" Тогда
		ХарактеристикиКомплектующейИспользуются = Справочники.Номенклатура.ПроверитьИспользованиеХарактеристик(Запись.Комплектующая);
		Элементы.ХарактеристикаКомплектующей.ТолькоПросмотр = НЕ ХарактеристикиКомплектующейИспользуются;
		Элементы.ХарактеристикаКомплектующей.АвтоОтметкаНезаполненного = ХарактеристикиКомплектующейИспользуются;
		Элементы.ХарактеристикаКомплектующей.ОтметкаНезаполненного = ХарактеристикиКомплектующейИспользуются;
		
		Если НЕ ХарактеристикиКомплектующейИспользуются И ЗначениеЗаполнено(Запись.Комплектующая) Тогда
			Элементы.ХарактеристикаКомплектующей.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
		Иначе
			Элементы.ХарактеристикаКомплектующей.ПодсказкаВвода = "";
		КонецЕсли;
		
		Элементы.Упаковка.ТолькоПросмотр =НЕ ЗначениеЗаполнено(Запись.Комплектующая);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНоменклатуры()
	
	УстановитьДоступностьХарактеристикУпаковки("Номенклатура");
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКомплектующей()
	
	Если ЗначениеЗаполнено(Запись.Комплектующая) Тогда
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.ХарактеристикаКомплектующей);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", Запись.Упаковка);
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Номенклатура", Запись.Комплектующая);
		СтруктураСтроки.Вставить("Характеристика", Запись.ХарактеристикаКомплектующей);
		СтруктураСтроки.Вставить("Упаковка", Запись.Упаковка);
		СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиКомплектующейИспользуются);
		
		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);
		Запись.Комплектующая = СтруктураСтроки.Номенклатура;
		Запись.ХарактеристикаКомплектующей = СтруктураСтроки.Характеристика;
		Запись.Упаковка = СтруктураСтроки.Упаковка;
		
	Иначе
		Запись.ХарактеристикаКомплектующей = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
		Запись.Упаковка = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	УстановитьДоступностьХарактеристикУпаковки("Комплектующая");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДробноеКоличествоЗаписи()
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", 	Запись.Комплектующая);
	СтруктураСтроки.Вставить("Количество",		Запись.Количество);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличество");
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПроверитьДробноеКоличество(СтруктураСтроки, СтруктураДействий);
	
	Запись.Количество = СтруктураСтроки.Количество;
	
КонецПроцедуры

#КонецОбласти
