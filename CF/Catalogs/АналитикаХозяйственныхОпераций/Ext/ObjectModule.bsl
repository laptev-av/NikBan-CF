﻿
#Область ПрограммныйИнтерфейс

// Для предопределенных элементов получает правильный код операции.
//
// Параметры:
//  ИмяПредопределенногоЭлемента - строка имя предопределенного элемента.
//
// Возвращаемое значение:
//  Перечисление.ХозяйственныеОперации 
//
Функция ПолучитьПравильнуюХозяйственнуюОперацию(ИмяПредопределенногоЭлемента = "") Экспорт

	Если Ссылка = Справочники.АналитикаХозяйственныхОпераций.КомплектацияНоменклатуры Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Комплектация номенклатуры'");
		Возврат Перечисления.ХозяйственныеОперации.КомплектацияНоменклатуры;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПеремещениеТоваров Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Перемещение товаров'");
		Возврат Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПоступлениеТоваров Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Поступление товаров'");
		Возврат Перечисления.ХозяйственныеОперации.ПоступлениеТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.РеализацияТоваров Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Реализация товаров'");
		Возврат Перечисления.ХозяйственныеОперации.РеализацияТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.СкидкиПодарки Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Списание на затраты (подарки)'");
		Возврат Перечисления.ХозяйственныеОперации.СписаниеНаЗатраты;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПогашениеПодарочныхСертификатов Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Погашение подарочных сертификатов'");
		Возврат Перечисления.ХозяйственныеОперации.ПогашениеПодарочныхСертификатов;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ОприходованиеТоваров Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Оприходование товаров'");
		Возврат Перечисления.ХозяйственныеОперации.Оприходование;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПередачаТоваровДоРеализации Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Передача товаров до реализации'");
		Возврат Перечисления.ХозяйственныеОперации.ПередачаТоваровДоРеализации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПередачаТоваровПослеРеализации Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Передача товаров после реализации'");
		Возврат Перечисления.ХозяйственныеОперации.ПередачаТоваровПослеРеализации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПриемТоваровОтДругойОрганизации Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Прием товаров от другой организации'");
		Возврат Перечисления.ХозяйственныеОперации.ПриемТоваровОтДругойОрганизации;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ПересортицаТоваров Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Пересортица товаров'");
		Возврат Перечисления.ХозяйственныеОперации.ПересортицаТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ОтгрузкаНаВнутренниеНужды Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Отгрузка на внутренние нужды'");
		Возврат Перечисления.ХозяйственныеОперации.ОтгрузкаНаВнутренниеНужды;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ОприходованиеКомиссионныхТоваров Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Оприходование комиссионного товара'");
		Возврат Перечисления.ХозяйственныеОперации.ОприходованиеКомиссионныхТоваров;
		
	ИначеЕсли Ссылка = Справочники.АналитикаХозяйственныхОпераций.ВознаграждениеОтКомитента Тогда
		
		ИмяПредопределенногоЭлемента = НСтр("ru = 'Вознаграждение от комитента'");
		Возврат Перечисления.ХозяйственныеОперации.ВознаграждениеОтКомитента;

	Иначе
		
		Возврат Перечисления.ХозяйственныеОперации.ПустаяСсылка();
		
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоНовый() Тогда 
		
		Если Предопределенный Тогда
			
			ИмяПредопределенногоЭлемента = "";
			ПравильнаяХозяйственнаяОперация = ПолучитьПравильнуюХозяйственнуюОперацию(ИмяПредопределенногоЭлемента);
			
			Если Не ПравильнаяХозяйственнаяОперация = ХозяйственнаяОперация Тогда
				
				ТекстОшибки = НСтр("ru = 'Для этого предопределенного элемента 
				|возможно задать только код хозяйственной
				|" + " "+ ИмяПредопределенногоЭлемента+"'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					"ХозяйственнаяОперация",
					,
					Отказ);
					
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Ссылка.ХозяйственнаяОперация) 
			И Не Ссылка.ХозяйственнаяОперация = ХозяйственнаяОперация Тогда
			
			Если НЕ ПроверитьХозяйственнуюОперацию() Тогда
					
				ТекстОшибки = НСтр("ru = 'Нельзя изменить код хозяйственной операции,
				|так как он используется в документах'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					"ХозяйственнаяОперация",
					,
					Отказ);
					
			КонецЕсли;
				
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет правильность заполнения кода хозяйственной операции.
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Булево - "Истина", если ошибка есть.
//
Функция ПроверитьХозяйственнуюОперацию()

	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВозвратТоваровОтПокупателя.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	|ГДЕ
	|	ВозвратТоваровОтПокупателя.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровПоставщику.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|ГДЕ
	|	ВозвратТоваровПоставщику.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтчетОРозничныхПродажахВозвращенныеТовары.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ОтчетОРозничныхПродажахВозвращенныеТовары
	|ГДЕ
	|	ОтчетОРозничныхПродажахВозвращенныеТовары.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекККМ.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОприходованиеТоваров.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
	|ГДЕ
	|	ОприходованиеТоваров.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СписаниеТоваров.АналитикаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеТоваров КАК СписаниеТоваров
	|ГДЕ
	|	СписаниеТоваров.АналитикаХозяйственнойОперации = &АналитикаХозяйственнойОперации");
	
	Запрос.УстановитьПараметр("АналитикаХозяйственнойОперации", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	

КонецФункции

#КонецОбласти