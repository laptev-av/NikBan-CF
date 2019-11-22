﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Касса = Справочники.КассыККМ.КассаПоУмолчанию(Организация);
	
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьКассу(Отказ);
	
	ПроверитьДублиВидовОплат(Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ИспользоватьБезПодключенияОборудования Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПодключаемоеОборудование");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоРозничнаяТорговля = ТипЗнч(Касса) = Тип("СправочникСсылка.КассыККМ");
	Если РозничнаяТорговля <> ЭтоРозничнаяТорговля Тогда
		РозничнаяТорговля = ЭтоРозничнаяТорговля;
	КонецЕсли;
	
	Если ИспользоватьБезПодключенияОборудования Тогда
		ПодключаемоеОборудование = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет кассу, указанную в эквайринговом терминале.
//
Процедура ПроверитьКассу(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Касса) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Касса) = Тип("СправочникСсылка.Кассы") Тогда
		Реквизиты = ДенежныеСредстваСервер.ПолучитьРеквизитыКассы(Касса);
	ИначеЕсли ТипЗнч(Касса) = Тип("СправочникСсылка.КассыККМ") Тогда
		Реквизиты = Справочники.КассыККМ.РеквизитыКассыККМ(Касса);
	Иначе
		Реквизиты = Новый Структура("Организация, Магазин");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Реквизиты.Организация) И Организация <> Реквизиты.Организация Тогда
		Текст = НСтр("ru = 'Организация кассы не соответствует организации договора эквайринга'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Касса", , Отказ);
	Иначе
		Магазин = Реквизиты.Магазин;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДублиВидовОплат(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты КАК Справочник.ВидыОплатЧекаККМ) КАК ВидОплаты,
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.НомерСтроки
	|ПОМЕСТИТЬ ТаблицаДублейНеСгруппированное
	|ИЗ
	|	&ТарифыЗаРасчетноеОбслуживание КАК ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты,
	|	КОЛИЧЕСТВО(ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты) КАК Количество
	|ПОМЕСТИТЬ ТаблицаДублей
	|ИЗ
	|	ТаблицаДублейНеСгруппированное КАК ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание
	|
	|СГРУППИРОВАТЬ ПО
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты КАК ВидОплаты,
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.НомерСтроки КАК НомерСтроки,
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты.Наименование КАК Наименование
	|ИЗ
	|	ТаблицаДублейНеСгруппированное КАК ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание
	|ГДЕ
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты В
	|			(ВЫБРАТЬ
	|				ТаблицаДублей.ВидОплаты КАК ВидОплаты
	|			ИЗ
	|				ТаблицаДублей КАК ТаблицаДублей)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидОплаты,
	|	НомерСтроки
	|ИТОГИ ПО
	|	ВидОплаты";
	
	Запрос.УстановитьПараметр("ТарифыЗаРасчетноеОбслуживание", ТарифыЗаРасчетноеОбслуживание.Выгрузить());
	
	Результат = Запрос.Выполнить();
	ВыборкаВидыОплат = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаВидыОплат.Следующий() Цикл
		Выборка = ВыборкаВидыОплат.Выбрать();
		НомераСтрок = "";
		ПервыйНомерСтроки = 0;
		Пока Выборка.Следующий() Цикл
			НомераСтрок = НомераСтрок + Выборка.НомерСтроки + ",";
			Если ПервыйНомерСтроки = 0 Тогда
				ПервыйНомерСтроки = Выборка.НомерСтроки;
			КонецЕсли;
		КонецЦикла;
		
		НомераСтрок = Лев(НомераСтрок, СтрДлина(НомераСтрок) - 1);
		
		ТекстСообщения = НСтр("ru = 'Вид оплаты %1 дублируется №№'") + НомераСтрок;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ТекстСообщения,
							"" + ВыборкаВидыОплат.Наименование + "");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ТарифыЗаРасчетноеОбслуживание", ПервыйНомерСтроки, "ВидОплаты"),
			,
			Отказ
		);
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
