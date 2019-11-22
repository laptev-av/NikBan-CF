﻿
// Используется механизмом обработки изменения реквизитов ТЧ.
&НаКлиенте
Перем КэшированныеЗначения;

// Используется для передачи текущей строки в обработчик ожидания.
&НаКлиенте
Перем ТекущиеДанныеИдентификатор;

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоНаименованию(Результат, ДополнительныеПараметры) Экспорт
		
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ЗавершитьОбработкуДанныхПоКодуКлиент(Результат);
	КонецЕсли;
	
КонецПроцедуры

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

&НаКлиенте
Процедура ПолучитьВесЗавершение(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		ТоварыКоличествоУпаковокПриИзменении(ЭтотОбъект)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ИдентификаторСтроки = ДобавитьНайденныеСерийныеНомера(СтрокаРезультата);
		
	Иначе // Номенклатура.
		
		ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваров(СтрокаРезультата);
		
	КонецЕсли;

	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьДанныеИзТСДСервер(СтруктураПараметров) Экспорт
	
	Результат = ПодключаемоеОборудованиеРТВызовСервера.ОбработатьДанныеПоНоменклатуреИзТСДСервер(ЭтотОбъект, СтруктураПараметров);
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеПозицииТоваров(СтруктураПараметров) Экспорт 
	
	ДобавленаСтрока = Ложь;
	ТекущаяСтрока = ПодключаемоеОборудованиеРТВызовСервера.ИнициализацияСтрокиТоваров(ЭтотОбъект, СтруктураПараметров, ДобавленаСтрока);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТВызовСервера.ЗавершениеОбработкиСтрокиТоваров(ЭтотОбъект, ТекущаяСтрока, СтруктураДействий);
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеСерийныеНомера(СтруктураНомера) Экспорт
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТВызовСервера.ДобавитьНоменклатуруПоСерийномуНомеру(ЭтотОбъект, СтруктураНомера);
	Возврат ИдентификаторСтроки;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторТекущейСтроки);
	ТекущаяСтрока.Характеристика = Результат;
	ТоварыХарактеристикаПриИзменении(Неопределено);

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
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(Документы.ОрдерНаОтражениеНедостачТоваров.ПараметрыУказанияСерий(Объект));
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект, КартинкаСостоянияДокумента, Элементы.КартинкаСостоянияДокумента.Подсказка, РазрешеноПроведение);
	
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
		ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьСтатусыУказанияСерий(
			Объект,
			Документы.ОрдерНаОтражениеНедостачТоваров.ПараметрыУказанияСерий(Объект));
		
	КонецЕсли;
	
	УстановитьДоступностьКомандБуфераОбмена();	
	
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Склад",
		"ТолькоПросмотр",
		НЕ ЗначениеЗаполнено(Объект.Магазин));
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обработчик механизма "ДатыЗапретаИзменения".
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
	ПараметрыУказанияСерий = 
		Новый ФиксированнаяСтруктура(Документы.ОрдерНаОтражениеНедостачТоваров.ПараметрыУказанияСерий(Объект));
	
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьСтатусыУказанияСерий(
		Объект,
		Документы.ОрдерНаОтражениеНедостачТоваров.ПараметрыУказанияСерий(Объект));
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
		
	// &ЗамерПроизводительности	
	ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);	
		
	Оповестить("Запись_ОрдерНаОтражениеНедостачТоваров",ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
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

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Или ИмяСобытия = "ВставкаСтрокИзБуфераОбмена" Тогда
		
		УстановитьДоступностьКомандБуфераОбмена();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	// &ЗамерПроизводительности
	Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
	                                            "Документ.ОрдерНаОтражениеНедостачТоваров.ФормаДокумента.Запись",
                                                           Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Склад) 
		И НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ПриИзмененииСклада();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Магазин) Тогда
		ПриИзмененииМагазина();
	КонецЕсли;
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	Перем ТекущаяСтрока;
	Перем СтруктураДействий;
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	Если ИспользоватьАдресноеХранение Тогда
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу" , ТекущаяСтрока.Упаковка);
	КонецЕсли;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");

	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьУпаковкуНоменклатуры(
		ДанныеВыбора,
		СтандартнаяОбработка,
		Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ОбновитьКэшированныеЗначенияДляУчетаСерий(
				Элемент,КэшированныеЗначения,ПараметрыУказанияСерий,Копирование);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ОбработкаТабличнойЧастиТоварыКлиент.НеобходимоОбновитьСтатусыСерий(
		Элемент,КэшированныеЗначения,ПараметрыУказанияСерий) Тогда
		
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
		ОбработкаТабличнойЧастиТоварыКлиент.ОбновитьКэшированныеЗначенияДляУчетаСерий(
					Элемент,КэшированныеЗначения,ПараметрыУказанияСерий);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, Элементы.Товары.ТекущиеДанные);
	
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

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	ОповещенияПриПолученииВеса = Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект);
	ПодключаемоеОборудованиеРТКлиент.ПолучениеВесаСЭлектронныхВесовДляТабличнойЧасти(ОповещенияПриПолученииВеса, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ПодключаемоеОборудованиеРТКлиент.ВыгрузитьДокументВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УчитыватьСерийныеНомераПриСвертке", Ложь);
	ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, ДополнительныеПараметры);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНаименованию(Команда)
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Магазин",Объект.Магазин);
	РаботаСПравиламиИменованияКлиент.ПоискПоНаименованию(ЭтаФорма,ПараметрыПоиска);
	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура УказатьСерии(Команда)
	
	ВводСерийРазрешен = Истина;
	ОбработкаТабличнойЧастиТоварыКлиент.ПроверитьВозможностьУказанияСерий(
		ЭтотОбъект,
		ПараметрыУказанияСерий,
		ВводСерийРазрешен);
	
	Если НЕ ВводСерийРазрешен Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанныеИдентификатор = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
	ПараметрыФормыУказанияСерий.Вставить("ОрдерНаОтражениеИзлишковНедостач", Истина);
	
	ОбработчикУказанияСерий = Новый ОписаниеОповещения("ОбработатьУказаниеСерий", ЭтотОбъект, ПараметрыФормыУказанияСерий);
	РежимБлокировки = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму(
		ПараметрыФормыУказанияСерий.ИмяФормы,
		ПараметрыФормыУказанияСерий,
		ЭтотОбъект,,,,
		ОбработчикУказанияСерий,
		РежимБлокировки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУказаниеСерий(ЗначениеВозврата, ПараметрыФормыУказанияСерий) Экспорт
	
	Если ЗначениеВозврата <> Неопределено Тогда
		ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.Товары;
	ДанныеТаблицы = Объект.Товары;
	
	ОбработкаТабличнойЧастиТоварыКлиент.РазбитьСтрокуТЧ(ЭтотОбъект, ДанныеТаблицы, ТаблицаФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСвернутьТЧ(Команда)
	РазвернутьСвернутьТЧНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если КопированиеСтрокКлиент.ВозможноКопированиеСтрок(Элементы.Товары.ТекущаяСтрока) Тогда
		СкопироватьСтрокиНаСервере();
		КопированиеСтрокКлиент.ОповеститьПользователяОКопированииСтрок(Элементы.Товары.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)

	КоличествоТоваровДоВставки = Объект.Товары.Количество();
	ПолучитьСтрокиИзБуфераОбмена();
	КоличествоВставленных = Объект.Товары.Количество() - КоличествоТоваровДоВставки;
	КопированиеСтрокКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеРазбитьСтроку(Количество, ДополнительныеПараметры) Экспорт
	
	НоваяСтрока = ДополнительныеПараметры.НоваяСтрока;
	Если НоваяСтрока = Неопределено Тогда
		ОбработкаТабличнойЧастиТоварыКлиент.РазбитьСтрокуТЧПроверитьЧисло(Количество, ДополнительныеПараметры);
	КонецЕсли;
	
	НоваяСтрока = ДополнительныеПараметры.НоваяСтрока;
	ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
	Если НЕ НоваяСтрока = Неопределено Тогда
		
		СтруктураДействий = Новый Структура;
		ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
		
		ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
			Объект.Товары,
			ТекущаяСтрока,
			СтруктураДействий,
			КэшированныеЗначения);
		
		ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
			Объект.Товары,
			НоваяСтрока,
			СтруктураДействий,
			КэшированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазвернутьСвернутьТЧНаСервере()
	
	РазвернутаТЧ = НЕ РазвернутаТЧ;
	
	ВидимостьЭлементов = НЕ РазвернутаТЧ;
	
	ПоложениеКоманднойПанели = ?(ВидимостьЭлементов,
		ПоложениеКоманднойПанелиФормы.Авто,
		ПоложениеКоманднойПанелиФормы.Нет);
	
	Элементы.Шапка.Видимость                      = ВидимостьЭлементов;
	Элементы.ГруппаИнформация.Видимость           = ВидимостьЭлементов;
	
	Элементы.РазвернутьСвернутьТЧ.Картинка = ?(ВидимостьЭлементов,
		БиблиотекаКартинок.РазвернутьТабличнуюЧасть,
		БиблиотекаКартинок.СвернутьТабличнуюЧасть);
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

// Процедура заполняет организацию при изменении склада.
//
&НаСервере
Процедура ПриИзмененииСклада()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		                                              
		Объект.Организация = Объект.Склад.Организация;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет склад при изменении магазина.
//
&НаСервере
Процедура ПриИзмененииМагазина()
	
	Объект.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(
		Объект.Магазин,
		,
		Объект.Склад,
		Пользователи.ТекущийПользователь());
	
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		ПриИзмененииСклада();
	КонецЕсли;
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(Документы.ОрдерНаОтражениеНедостачТоваров.ПараметрыУказанияСерий(Объект));
	УстановитьВидимостьЭлементовСерий();
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента);
	
КонецПроцедуры

#Область Серии

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий)
	
	ОбработкаТабличнойЧастиТоварыСервер.ОбработатьУказаниеСерий(Объект,ПараметрыУказанияСерий,ПараметрыФормыУказанияСерий);

КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат ОбработкаТабличнойЧастиТоварыСервер.ПоместитьСерииВХранилище(
		Объект,
		ПараметрыУказанияСерий,
		ТекущиеДанныеИдентификатор,
		ЭтотОбъект);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ИдентификаторСтроки, КэшированныеЗначения)
	
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(
		Объект,
		ПараметрыУказанияСерий,
		ИдентификаторСтроки,
		КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий)
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Склад",
		"ТолькоПросмотр",
		НЕ ЗначениеЗаполнено(Объект.Магазин));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.ТоварыСерия.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
КонецПроцедуры

#КонецОбласти

#Область РаботаСБуферомОбмена
	
&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	КопированиеСтрокСервер.ПоместитьВыделенныеСтрокиВБуферОбмена(Элементы.Товары.ВыделенныеСтроки, Объект.Товары);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбмена()
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ПодарочныйСертификат"));
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ОтборПоТипуНоменклатуры", МассивТиповНоменклатуры);
	
	ТаблицаТоваров = КопированиеСтрокСервер.ПолучитьСтрокиИзБуфераОбмена(ПараметрыОтбора);
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		Если ИспользоватьАдресноеХранение Тогда
			СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу" , ТекущаяСтрока.Упаковка);
		КонецЕсли;
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		
		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);		
		
	КонецЦикла;
	
	КопированиеСтрокСервер.ОчиститьБуферОбмена();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", 
		НЕ ОбщегоНазначения.ПустойБуферОбмена("Строки"));
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
