﻿
#Область ПрограммныйИнтерфейс

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
	
	Если Результат = Неопределено Тогда
		ОбновитьКоды(ДополнительныеПараметры.СтруктураПараметровКлиента);
	Иначе
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ДанныеПоискаПоМагнитномуКоду(МагнитныйКод, ЭтотОбъект);
	
	НайденоОбъектов = СтруктураРезультат.ЗначенияПоиска.Количество();
	Если НайденоОбъектов > 0 Тогда
		Если НайденоОбъектов = 1 Тогда
			ОбработатьДанныеПоКодуСервер(СтруктураРезультат);
		ИначеЕсли НайденоОбъектов > 1 Тогда
			ПодключаемоеОборудованиеРТВызовСервера.ПодготовитьДанныеДляВыбора(СтруктураРезультат);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект);
	
	НайденоОбъектов = СтруктураРезультат.ЗначенияПоиска.Количество();
	Если НайденоОбъектов > 0 Тогда
		Если НайденоОбъектов = 1 Тогда
			ОбработатьДанныеПоКодуСервер(СтруктураРезультат);
		ИначеЕсли НайденоОбъектов > 1 Тогда
			ПодключаемоеОборудованиеРТВызовСервера.ПодготовитьДанныеДляВыбора(СтруктураРезультат);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		СтруктураРезультат.Вставить("НайденоЗначение", СтрокаРезультата.Карта);
		Если СтрокаРезультата.ЭтоРегистрационнаяКарта Тогда
			ТекстВопроса = НСтр("ru = 'По коду %1 найдена регистрационная карта. Открыть найденное значение?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'По коду %1 найдена дисконтная карта. Открыть найденное значение?'");
		КонецЕсли;
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СтрокаРезультата.ДанныеПО);
		
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		СтруктураРезультат.Вставить("НайденоЗначение", СтрокаРезультата.СерийныйНомер);
		ТекстВопроса = НСтр("ru = 'По коду %1 найден подарочный сертификат. Открыть найденное значение?'");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СтрокаРезультата.ДанныеПО);
		СтруктураРезультат.Вставить("ТекстВопроса", ТекстВопроса);
		
	ИначеЕсли СтрокаРезультата.Свойство("ШтрихкодУпаковкиЕГАИС")
		И ЗначениеЗаполнено(СтрокаРезультата.ШтрихкодУпаковкиЕГАИС) Тогда
		
		СтруктураРезультат.Вставить("НайденоЗначение", СтрокаРезультата.ШтрихкодУпаковкиЕГАИС);
		Если СтрокаРезультата.Свойство("ТипУпаковки") Тогда
			Если СтрокаРезультата.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
				ТекстВопроса = НСтр("ru = 'По коду ""%1"" найдена акцизная марка. Открыть найденное значение?'");
			Иначе
				ТекстВопроса = НСтр("ru = 'По коду ""%1"" найдена упаковка ЕГАИС. Открыть найденное значение?'");
			КонецЕсли;
		Иначе
			ТекстВопроса = НСтр("ru = 'По коду ""%1"" найдена упаковка ЕГАИС. Открыть найденное значение?'");
		КонецЕсли;
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СтрокаРезультата.ДанныеПО);
		СтруктураРезультат.Вставить("ТекстВопроса", ТекстВопроса);
		
	Иначе // Номенклатура.
		
		СтруктураРезультат.Вставить("НайденоЗначение", СтрокаРезультата.Номенклатура);
		ТекстВопроса = НСтр("ru = 'По коду %1 найдена номенклатура. Открыть найденное значение?'");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СтрокаРезультата.ДанныеПО);
		СтруктураРезультат.Вставить("ТекстВопроса", ТекстВопроса);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	Если СтруктураПараметровКлиента.НеизвестныеДанныеПО Тогда
		
		ОбновитьКоды(СтруктураПараметровКлиента);
		
	ИначеЕсли СтруктураПараметровКлиента.Свойство("НайденоЗначение") Тогда
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаВопросаОбОткрытииЗначения", ЭтотОбъект, СтруктураПараметровКлиента);
		ПоказатьВопрос(ОбработчикОповещения, СтруктураПараметровКлиента.ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКартуПоШаблону(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.Количество() = 2
			И Результат.Свойство("КодКарты")
			И Результат.Свойство("НаименованиеШаблона") Тогда
			
			ОбновитьКартуПоШаблонуСервер(Результат, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВопросаОбОткрытииЗначения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоказатьЗначение(, ДополнительныеПараметры.НайденоЗначение);
	Иначе
		ОбновитьКоды(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "СтраницаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ЭтоДисконтнаяКарта = Объект.ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная;
	Элементы.ВидДисконтнойКарты.Видимость = ЭтоДисконтнаяКарта;
	Элементы.ПараметрыБонуснойПрограммы.Видимость = ЭтоДисконтнаяКарта;
	
	Заголовок = ?(Объект.ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная, НСтр("ru = 'Дисконтная карта'"), НСтр("ru = 'Регистрационная карта'"));
	
	Если НЕ Параметры.Ключ.Пустая()
		И НЕ Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Магнитная Тогда
		ДанныеШтрихКода = ПодключаемоеОборудованиеРТВызовСервера.ПолучитьШтрихкод(Объект.Ссылка);
		Если НЕ ДанныеШтрихКода = Неопределено Тогда
		
			ШтрихкодКарты     = ДанныеШтрихКода.Штрихкод;
			ТипШтрихкодаКарты = ДанныеШтрихКода.ТипШтрихкода;
		
		КонецЕсли;
	КонецЕсли;
	
	ПриИзмененииТипаКарты();
	ПриИзмененииВладельцаКарты(Ложь);
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	ЗаполнитьФлагиПоВидуКартыСервер();
	УстановитьДоступностьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
	
		Если Объект.ВидКарты = ПредопределенноеЗначение("Перечисление.ВидыИнформационныхКарт.Штриховая") Тогда
			Объект.Наименование = ШтрихкодКарты;
		Иначе
			Объект.Наименование = Объект.КодКарты;
		КонецЕсли;
	
	КонецЕсли;
	
	ПараметрыЗаписи.Вставить("ШтрихкодКарты"    , ШтрихкодКарты);
	ПараметрыЗаписи.Вставить("ТипШтрихкодаКарты", ТипШтрихкодаКарты);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Вставить содержимое обработчика.
	
	Если ТекущийОбъект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Магнитная Тогда
	
		НаборЗаписейШтрихкодов = РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
		НаборЗаписейШтрихкодов.Отбор.Владелец.Установить(ТекущийОбъект.Ссылка);
		
		Попытка
			НаборЗаписейШтрихкодов.Записать();
		Исключение
			Отказ = Истина;
			СтрокаОшибки = ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки);
		КонецПопытки;
		
	Иначе
		
		НаборЗаписейШтрихкодов = РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
		НаборЗаписейШтрихкодов.Отбор.Владелец.Установить(ТекущийОбъект.Ссылка);
		
		ЗаписьШтрихкода = НаборЗаписейШтрихкодов.Добавить();
		ЗаписьШтрихкода.Владелец     = ТекущийОбъект.Ссылка;
		ЗаписьШтрихкода.ТипШтрихкода = ПараметрыЗаписи.ТипШтрихкодаКарты;
		ЗаписьШтрихкода.Штрихкод     = ПараметрыЗаписи.ШтрихкодКарты;

		Если НЕ НаборЗаписейШтрихкодов.ПроверитьЗаполнение() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если Не Отказ Тогда
			Попытка
				НаборЗаписейШтрихкодов.Записать();
			Исключение
				Отказ = Истина;
				СтрокаОшибки = ОписаниеОшибки();
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки);
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Магнитная Тогда
	
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("ШтрихкодКарты");
		МассивНепроверяемыхРеквизитов.Добавить("ТипШтрихкодаКарты");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецКартыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ФизическиеЛица") 
		ИЛИ ВыбранноеЗначение = Тип("СправочникСсылка.Пользователи")
		ИЛИ ВыбранноеЗначение = Тип("СправочникСсылка.Контрагенты") Тогда
		
		УстановитьПараметрыВыбораВладельцаКарты(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецКартыПриИзменении(Элемент)
	
	ПриИзмененииВладельцаКарты();
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагКодКартыПриИзменении(Элемент)
	
	ПриИзмененииВидаКарты(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагШтрихКодПриИзменении(Элемент)
	
	ПриИзмененииВидаКарты(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодКартыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ШтрихкодКарты) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(ШтрихкодКарты);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодКартыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КодКарты) Тогда
		МагнитныйКод = Объект.КодКарты;
		СтруктураПараметровКлиента = ПолученМагнитныйКод(МагнитныйКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание = 0 Тогда
		СформироватьСписокАвтоНаименованийКартыКлиент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БонуснаяПрограммаЛояльностиПриИзменении(Элемент)
	Элементы.КартаДляНакоплений.Доступность = ЗначениеЗаполнено(Объект.БонуснаяПрограммаЛояльности);
КонецПроцедуры

&НаКлиенте
Процедура КартаДляНакопленийПриИзменении(Элемент)
	КартаДляНакопленийПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КартаДляНакопленийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("БонуснаяПрограммаЛояльности", Объект.БонуснаяПрограммаЛояльности);
	СтруктураОтбора.Вставить("КартаДляНакоплений", ПредопределенноеЗначение("Справочник.ИнформационныеКарты.ПустаяСсылка"));
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.ИнформационныеКарты.ФормаВыбора", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры


&НаКлиенте
Процедура ВидДисконтнойКартыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ВидыДисконтныхКарт.Форма.ФормаВыбора.Открытие");

КонецПроцедуры  

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФлагиПоВидуКартыСервер()

	ФлагКодКарты =      (Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Магнитная)
					ИЛИ (Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Смешанная);

	ФлагШтрихКод =      (Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Штриховая)
					ИЛИ (Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Смешанная);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВидаКарты(Элемент)

	Если ФлагКодКарты И ФлагШтрихКод Тогда
	
		Объект.ВидКарты = ПредопределенноеЗначение("Перечисление.ВидыИнформационныхКарт.Смешанная");
	ИначеЕсли ФлагКодКарты Тогда
		
		Объект.ВидКарты = ПредопределенноеЗначение("Перечисление.ВидыИнформационныхКарт.Магнитная");
	ИначеЕсли ФлагШтрихКод Тогда
		
		Объект.ВидКарты = ПредопределенноеЗначение("Перечисление.ВидыИнформационныхКарт.Штриховая");
	Иначе
		Если Элемент.Имя = "ФлагКодКарты" Тогда
			ФлагШтрихКод = Истина;
		Иначе
			ФлагКодКарты = Истина;
		КонецЕсли;
		ПриИзмененииВидаКарты(Элемент);
		Возврат;
	КонецЕсли;
	
	Если Элемент.Имя = "ФлагШтрихКод" Тогда
		Если НЕ ФлагШтрихКод Тогда
			ТипШтрихкодаКарты = ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыШтрихкодов.ПустаяСсылка");
			ШтрихкодКарты = "";
		ИначеЕсли Не ЗначениеЗаполнено(ТипШтрихкодаКарты) Тогда
			ТипШтрихкодаКарты = ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыШтрихкодов.EAN13");
		КонецЕсли;
	ИначеЕсли Элемент.Имя = "ФлагКодКарты" И НЕ ФлагКодКарты Тогда
		Объект.КодКарты = "";
	КонецЕсли;
	
	УстановитьДоступностьСервер();

КонецПроцедуры

// Процедура изменяет внешний вид формы в зависимости от значения, выбранного в поле "ВладелецКарты".
//
&НаСервере
Процедура ПриИзмененииВладельцаКарты(ИзменятьРеквизиты = Истина)
	
	Если ИзменятьРеквизиты Тогда
		
		Если ТипЗнч(Объект.ВладелецКарты) = Тип("СправочникСсылка.Контрагенты") Тогда
			Объект.ДатаСледующегоОпроса = '00010101';
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПараметрыВыбораВладельцаКартыСервер(ТипЗнч(Объект.ВладелецКарты));
	УстановитьДоступностьСервер();
	
КонецПроцедуры

// Процедура выполняет действия при изменении типа карты.
//
&НаСервере
Процедура ПриИзмененииТипаКарты()
	
	Если Объект.ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная Тогда
		Элементы.ВладелецКарты.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица, СправочникСсылка.Контрагенты");
	Иначе
		Элементы.ВладелецКарты.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица, СправочникСсылка.Пользователи");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьСервер()

	ЭтоДисконтнаяКарта = Объект.ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная;
	ВладелецКонтрагент = ТипЗнч(Объект.ВладелецКарты) = Тип("СправочникСсылка.Контрагенты");
	
	Элементы.ВидДисконтнойКарты.ТолькоПросмотр = НЕ ЭтоДисконтнаяКарта;
	
	Элементы.КодКарты.ТолькоПросмотр = НЕ ФлагКодКарты;
	
	Элементы.ШтрихкодКарты.ТолькоПросмотр     = НЕ ФлагШтрихКод;
	Элементы.ТипШтрихкодаКарты.ТолькоПросмотр = НЕ ФлагШтрихКод;
	
	Если ЭтоДисконтнаяКарта Тогда
		Элементы.ДатаПоследнегоОпроса.ТолькоПросмотр = ВладелецКонтрагент;
		Элементы.ДатаСледующегоОпроса.ТолькоПросмотр = ВладелецКонтрагент;
	Иначе
		Элементы.СтраницаОпрос.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.КартаДляНакоплений.Доступность = ЗначениеЗаполнено(Объект.БонуснаяПрограммаЛояльности);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыВыбораВладельцаКарты(ВыбранноеЗначение)
	
	МассивПараметров = Новый Массив;
	
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ФизическиеЛица")
		И Объект.ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыИнформационныхКарт.Регистрационная") Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Сотрудник", Истина));
	КонецЕсли;
	
	Элементы.ВладелецКарты.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьПараметрыВыбораВладельцаКартыСервер(ВыбранноеЗначение)
	
	МассивПараметров = Новый Массив;
	
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ФизическиеЛица")
		И Объект.ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыИнформационныхКарт.Регистрационная") Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Сотрудник", Истина));
	КонецЕсли;
	
	Элементы.ВладелецКарты.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоды(СтруктураПараметровКлиента)
	
	Если СтруктураПараметровКлиента.ТипДанныхПО = "Штрихкод" Тогда
		ФлагШтрихКод = Истина;
		ШтрихкодКарты = СтруктураПараметровКлиента.ДанныеПО;
		ПриИзмененииВидаКарты(Элементы.ФлагШтрихКод);
		ТипШтрихкодаКарты = ПодключаемоеОборудованиеРТВызовСервера.ОпределитьТипШтрихкода(ШтрихкодКарты);
	Иначе
		ФлагКодКарты = Истина;
		Объект.КодКарты = СтруктураПараметровКлиента.ДанныеПО;
		ПриИзмененииВидаКарты(Элементы.ФлагКодКарты);
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСписокАвтоНаименованийКартыКлиент()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования = "";
	Если ФлагКодКарты  И ЗначениеЗаполнено(Объект.КодКарты) Тогда
		СтрокаНаименования = Объект.КодКарты;
		Элементы.Наименование.СписокВыбора.Добавить(Объект.КодКарты);
	ИначеЕсли ФлагШтрихКод И ЗначениеЗаполнено(ШтрихкодКарты) Тогда
		СтрокаНаименования = ШтрихкодКарты;
		Элементы.Наименование.СписокВыбора.Добавить(ШтрихкодКарты);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ВладелецКарты) Тогда
		СтрокаНаименования = СтрокаНаименования + " (" + СокрЛП(Объект.ВладелецКарты) + ")";
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КартаДляНакопленийПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.КартаДляНакоплений) Тогда
		
		Если Объект.БонуснаяПрограммаЛояльности <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.КартаДляНакоплений, "БонуснаяПрограммаЛояльности") Тогда
			СтрокаОшибки = НСтр("ru = 'Бонусная программа карты для накоплений не совпадает с выбранной бонусной программой. Выберите другую карту'");
			Объект.КартаДляНакоплений = Справочники.ИнформационныеКарты.ПустаяСсылка();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки, , "КартаДляНакоплений", "Объект");
		ИначеЕсли Объект.Ссылка = Объект.КартаДляНакоплений Тогда
			СтрокаОшибки = НСтр("ru = 'Карта для накоплений совпадает с текущей картой. Выберите другую карту'");
			Объект.КартаДляНакоплений = Справочники.ИнформационныеКарты.ПустаяСсылка();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки, , "КартаДляНакоплений", "Объект");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКартуПоШаблонуСервер(Результат, ДополнительныеПараметры)
	
	ТаблицаШаблонов = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.СтруктураПараметровКлиента.РегистрацияНовойКартыВыборШаблона);
	СтрокиШаблонов = ТаблицаШаблонов.НайтиСтроки(Результат);
	Если СтрокиШаблонов.Количество() > 0 Тогда
		СтруктураШаблонов = Новый Структура;
		ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВСтруктуру(ТаблицаШаблонов, СтрокиШаблонов[0], СтруктураШаблонов);
		
		Объект.Наименование = СтруктураШаблонов.КодКарты;
		
		Объект.ВидКарты = СтруктураШаблонов.ВидКарты;
		Объект.ДатаОткрытия = ТекущаяДатаСеанса();
		Объект.Родитель = СтруктураШаблонов.ГруппаКарты;
		Объект.ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная;
		
		Если Объект.ВидКарты = Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
			ШтрихКодКарты = СтруктураШаблонов.КодКарты;
			Объект.КодКарты = "";
			ФлагКодКарты = Ложь;
			ФлагШтрихКод = Истина;
		Иначе
			Объект.КодКарты = СтруктураШаблонов.КодКарты;
			ШтрихКодКарты = "";
			ФлагКодКарты = Истина;
			ФлагШтрихКод = Ложь;
		КонецЕсли;
		
		Объект.ВидДисконтнойКарты = СтруктураШаблонов.ВидДисконтнойКарты;
		Объект.БонуснаяПрограммаЛояльности = СтруктураШаблонов.БонуснаяПрограммаЛояльности;
		
		Если СтруктураШаблонов.Свойство("ПроводитьОпросВладельцаПриРегистрации")
			И СтруктураШаблонов.ПроводитьОпросВладельцаПриРегистрации Тогда
			Объект.ДатаСледующегоОпроса = Объект.ДатаОткрытия;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
		УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти
