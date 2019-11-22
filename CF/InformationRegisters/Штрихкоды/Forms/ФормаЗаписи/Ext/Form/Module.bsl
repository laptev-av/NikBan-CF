﻿
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.ЗначенияЗаполнения.Свойство("Владелец")
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Владелец) Тогда
		
		УстановитьТекстЗаголовкаПоВладельцу(Параметры.ЗначенияЗаполнения.Владелец);
		УстановитьВидимостьПоВладельцу(Параметры.ЗначенияЗаполнения.Владелец);
		
	ИначеЕсли ЗначениеЗаполнено(Запись.Владелец) Тогда
		
		УстановитьТекстЗаголовкаПоВладельцу(Запись.Владелец);
		УстановитьВидимостьПоВладельцу(Запись.Владелец);
		
	ИначеЕсли Параметры.ЗначенияЗаполнения.Свойство("ТипВладельца") Тогда
		
		Если Параметры.ЗначенияЗаполнения.ТипВладельца <> Тип("Неопределено") Тогда
			
			УстановитьТекстЗаголовкаПоТипуВладельца(Параметры.ЗначенияЗаполнения.ТипВладельца);
			Элементы.Владелец.ВыбиратьТип = Ложь;
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(Параметры.ЗначенияЗаполнения.ТипВладельца);
			Элементы.Владелец.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
			
		Иначе
			
			УстановитьДоступностьПоВладельцу();
			
		КонецЕсли;
		
		УстановитьВидимостьПоТипуВладельца(Параметры.ЗначенияЗаполнения.ТипВладельца);
		
	Иначе
		
		УстановитьДоступностьПоВладельцу();
		
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		ХарактеристикиИспользуются = Справочники.Номенклатура.ПроверитьИспользованиеХарактеристик(Запись.Владелец);
		Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
		
		Если ЗначениеЗаполнено(Запись.Штрихкод) Тогда
			ШтрихкодПриИзмененииСервер();
		КонецЕсли;
	КонецЕсли;
	
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
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

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипЗнч(Запись.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		Если ХарактеристикиИспользуются 
			И НЕ ЗначениеЗаполнено(Запись.Характеристика) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Поле ""Характеристика"" не заполнено'"),
				,
				"Запись.Характеристика",
				,
				Отказ);				
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	ХарактеристикиИспользуются = Справочники.Номенклатура.ПроверитьИспользованиеХарактеристик(Запись.Владелец);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ВладелецПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если ЗначениеЗаполнено(Запись.Владелец) Тогда
		ВладелецХарактеристики = Неопределено;
		Если ОбработкаТабличнойЧастиТоварыВызовСервера.ПроверитьИспользованиеХарактеристикИПолучитьВладельцаДляВыбора(Запись.Владелец, ВладелецХарактеристики) Тогда
			Если ВладелецХарактеристики = Неопределено Тогда
				ПоказатьПредупреждение(,НСтр("ru = 'Для данной номенклатуры характеристики не заданы.'"));
            Иначе
                
                // &ЗамерПроизводительности
                ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                         Истина, "Справочник.ХарактеристикиНоменклатуры.Форма.ФормаВыбора.Открытие");

                ПараметрыФормыВыбора = Новый Структура;
				ПараметрыФормыВыбора.Вставить("ТекущийЭлемент"  , Запись.Характеристика);
				ПараметрыФормыВыбора.Вставить("ПараметрВладелец", ВладелецХарактеристики);
				ПараметрыФормыВыбора.Вставить("Номенклатура"    , Запись.Владелец);
				ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыФормыВыбора, Элемент);
			КонецЕсли;
		Иначе
			ПоказатьПредупреждение(,НСтр("ru = 'Для данной номенклатуры отключено использование характеристик.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Запись.Владелец) Тогда
		ДанныеВыбора = Новый СписокЗначений;
		ОбработкаТабличнойЧастиТоварыВызовСервера.ПолучитьСписокДляВыбораУпаковок(Запись.Владелец, ДанныеВыбора, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	
	ШтрихкодПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипШтрихкодаПриИзменении(Элемент)
	Если Запись.ТипШтрихкода = ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыШтрихкодов.EAN128") Тогда
		Запись.ПредставлениеШтрихкода = Запись.Штрихкод;
	Иначе
		Запись.ПредставлениеШтрихкода = "";		
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовыйШтрихкод(Команда)
	
	Запись.Штрихкод = СформироватьШтрихкодEAN13();
	Запись.ТипШтрихкода = ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыШтрихкодов.EAN13");
	Запись.ПредставлениеШтрихкода = "";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПоВладельцу()
	
	Если ЗначениеЗаполнено(Запись.Владелец)
		И ТипЗнч(Запись.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		Элементы.Характеристика.Доступность = Истина;
		Элементы.Упаковка.Доступность = Истина;
		Если НЕ Элементы.Найти("ФормаНовыйШтрихкод") = Неопределено Тогда
			Элементы.ФормаНовыйШтрихкод.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Запись.Владелец) И ТипЗнч(Запись.Владелец) = Тип("СправочникСсылка.Справки2ЕГАИС") Тогда
		Элементы.Характеристика.Доступность = Ложь;
		Элементы.Упаковка.Доступность = Ложь;
		Если НЕ Элементы.Найти("ФормаНовыйШтрихкод") = Неопределено Тогда
			Элементы.ФормаНовыйШтрихкод.Доступность = Истина;
		КонецЕсли;
	Иначе
		Элементы.Характеристика.Доступность = Ложь;
		Элементы.Упаковка.Доступность = Ложь;
		Если НЕ Элементы.Найти("ФормаНовыйШтрихкод") = Неопределено Тогда
			Элементы.ФормаНовыйШтрихкод.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗаголовкаПоТипуВладельца(ТипВладельца)
	
	ТекстЗаголовка = "";
	Если ТипВладельца = Тип("СправочникСсылка.Номенклатура") Тогда
		ТекстЗаголовка = НСтр("ru = 'Номенклатура'");		
	ИначеЕсли ТипВладельца = Тип("СправочникСсылка.ИнформационныеКарты") Тогда
		ТекстЗаголовка = НСтр("ru = 'Информационная карта'");
	ИначеЕсли ТипВладельца = Тип("СправочникСсылка.СерийныеНомера") Тогда
		ТекстЗаголовка = НСтр("ru = 'Номер подарочного сертификата'");
	КонецЕсли;	        
	
	Если ТекстЗаголовка <> "" Тогда
		Элементы.Владелец.Заголовок = ТекстЗаголовка;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьВидимостьПоТипуВладельца(ТипВладельца)
	
	ВидимостьЭлементовПоВладельцуНоменклатура = ТипВладельца = Тип("СправочникСсылка.Номенклатура");
	ВидимостьЭлементовПоВладельцуСправка2 = ТипВладельца = Тип("СправочникСсылка.Справки2ЕГАИС");
	
	Элементы.Характеристика.Видимость = ВидимостьЭлементовПоВладельцуНоменклатура;
	Элементы.Упаковка.Видимость = ВидимостьЭлементовПоВладельцуНоменклатура;
	Элементы.ФормаНовыйШтрихкод.Доступность = ВидимостьЭлементовПоВладельцуНоменклатура или ВидимостьЭлементовПоВладельцуСправка2;
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьТекстЗаголовкаПоВладельцу(Владелец)
	
	ТекстЗаголовка = "";
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		ТекстЗаголовка = НСтр("ru = 'Номенклатура'");
	ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.ИнформационныеКарты") Тогда
		ТекстЗаголовка = НСтр("ru = 'Информационная карта'");
	ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.СерийныеНомера") Тогда
		ТекстЗаголовка = НСтр("ru = 'Номер подарочного сертификата'");
	КонецЕсли;
	
	Если ТекстЗаголовка <> "" Тогда
		Элементы.Владелец.Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоВладельцу(Владелец)
	
	ВидимостьЭлементовПоВладельцуНоменклатура = ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура");
	ВидимостьЭлементовПоВладельцуСправка2 = ТипЗнч(Владелец) = Тип("СправочникСсылка.Справки2ЕГАИС");
	
	Элементы.Характеристика.Видимость = ВидимостьЭлементовПоВладельцуНоменклатура;
	Элементы.Упаковка.Видимость = ВидимостьЭлементовПоВладельцуНоменклатура;
	Элементы.Владелец.ТолькоПросмотр = Истина;
	Если НЕ Элементы.Найти("ФормаНовыйШтрихкод") = Неопределено Тогда
		Элементы.ФормаНовыйШтрихкод.Видимость = ВидимостьЭлементовПоВладельцуНоменклатура или ВидимостьЭлементовПоВладельцуСправка2;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииСервер()
	
	УстановитьДоступностьПоВладельцу();
	
	Если ЗначениеЗаполнено(Запись.Владелец)
		И ТипЗнч(Запись.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
				
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу"      , Запись.Упаковка);
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Номенклатура", Запись.Владелец);
		СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
		СтруктураСтроки.Вставить("Упаковка", Запись.Упаковка);
		СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
				
		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

		ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
		
		ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
		Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
				
	Иначе     	
		Запись.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
		Запись.Упаковка = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13()
	
	Возврат ПодключаемоеОборудованиеРТВызовСервера.СформироватьШтрихкод();
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод)
	
	Запись.Штрихкод = Штрихкод;
	ШтрихкодПриИзмененииСервер();
	
КонецФункции

&НаСервере
Процедура ШтрихкодПриИзмененииСервер()
	
	Запись.ТипШтрихкода = ПодключаемоеОборудованиеРТВызовСервера.ОпределитьТипШтрихкода(Запись.Штрихкод); 	
	Если Запись.ТипШтрихкода = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN128 Тогда
		Запись.ПредставлениеШтрихкода = Запись.Штрихкод;
	Иначе
		Запись.ПредставлениеШтрихкода = "";
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

