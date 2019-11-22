﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает магазин, если магазин один в справочнике.
//
// Возвращаемое значение:
// СправочникСсылка.Магазины - Найденный магазин.
// Неопределено - если магазинов нет или больше одного.
//
Функция ПолучитьМагазинПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Магазины.Ссылка КАК Магазин
	|ИЗ
	|	Справочник.Магазины КАК Магазины
	|ГДЕ
	|	(НЕ Магазины.ПометкаУдаления)");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Магазин = Выборка.Магазин;
	Иначе
		Магазин = Справочники.Магазины.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Магазин;

КонецФункции

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//     Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы, связанного с
//              реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриОтгрузке");
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриПоступлении");
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач");
	Результат.Добавить("ИспользоватьОрдернуюСхемуПриПеремещении");
	Результат.Добавить("ИспользоватьПрименениеЦен");
	Результат.Добавить("ИспользоватьПрямуюИнкассацию");
	Результат.Добавить("ПравилоЦенообразования");
	Результат.Добавить("СкладПоступления");
	Результат.Добавить("СкладПродажи");
	Результат.Добавить("ВидМинимальныхЦенПродажи");
	Результат.Добавить("СегментИсключаемойНоменклатуры");
	Результат.Добавить("ПорядокОкругленияСуммыЧекаВПользуПокупателя");
	Результат.Добавить("ТипОкругленияЧекаВПользуПокупателя");
	Результат.Добавить("ПлощадьТорговогоЗала");
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент");
	Если ИспользоватьАссортимент Тогда
		Результат.Добавить("ФорматМагазина");
		Результат.Добавить("КонтролироватьАссортимент");
		Результат.Добавить("КонтролироватьАссортиментВЗаказеПокупателя");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПокупателей") Тогда
		Результат.Добавить("МетодРасчетаПотребности");
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	РедактируемыеРеквизиты.Добавить("ПорядокОкругленияСуммыЧекаВПользуПокупателя");
	РедактируемыеРеквизиты.Добавить("СегментИсключаемойНоменклатуры");
	РедактируемыеРеквизиты.Добавить("ВидМинимальныхЦенПродажи");
	РедактируемыеРеквизиты.Добавить("ПравилоЦенообразования");
	
	РедактируемыеРеквизиты.Добавить("ИспользоватьПрименениеЦен");
	РедактируемыеРеквизиты.Добавить("ИспользоватьОрдернуюСхемуПриОтгрузке");
	РедактируемыеРеквизиты.Добавить("ИспользоватьОрдернуюСхемуПриПоступлении");
	РедактируемыеРеквизиты.Добавить("ИспользоватьОрдернуюСхемуПриПеремещении");
	РедактируемыеРеквизиты.Добавить("ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Процедура печати
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ГрафикРаботы") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ГрафикРаботы", 
			"График работы магазина", 
			ПечатьГрафикаРаботыМагазина(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;

КонецПроцедуры

// Процедура вызывается при отключении ордерной схемы.
// Снимает признаки использования ордерного документооборота
// для всех магазинов.
//
Процедура ОтключитьИспользованиеОрдернойСхемы() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Магазины.Ссылка,
	|	Магазины.ИспользоватьОрдернуюСхемуПриОтгрузке,
	|	Магазины.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач,
	|	Магазины.ИспользоватьОрдернуюСхемуПриПеремещении,
	|	Магазины.ИспользоватьОрдернуюСхемуПриПоступлении
	|ИЗ
	|	Справочник.Магазины КАК Магазины
	|ГДЕ
	|	(Магазины.ИспользоватьОрдернуюСхемуПриОтгрузке
	|			ИЛИ Магазины.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач
	|			ИЛИ Магазины.ИспользоватьОрдернуюСхемуПриПеремещении
	|			ИЛИ Магазины.ИспользоватьОрдернуюСхемуПриПоступлении)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		Магазин = Выборка.Ссылка.ПолучитьОбъект();
		Магазин.ИспользоватьОрдернуюСхемуПриОтгрузке = Ложь;
		Магазин.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = Ложь;
		Магазин.ИспользоватьОрдернуюСхемуПриПеремещении = Ложь;
		Магазин.ИспользоватьОрдернуюСхемуПриПоступлении = Ложь;
		Магазин.Записать();
	
	КонецЦикла;

КонецПроцедуры

// Вызывается при переходе на версию РТ 2.2
//
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформацииОрганизаций() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ФактАдресМагазина";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ТелефонМагазина";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Факс");
	ПараметрыВида.Вид = "ФаксМагазина";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 3;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьГрафикаРаботыМагазина(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Магазины_ГрафикРаботы";
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Справочник.Ссылка                КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(Справочник.Ссылка) КАК МагазинПредставление,
	|	&Год                             КАК Год
	|ИЗ
	|	Справочник.Магазины              КАК Справочник
	|ГДЕ
	|	Справочник.Ссылка = &Магазин
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГОД(ГрафикиРаботы.ДатаКалендаря)                  КАК ГодКалендаря,
	|	КВАРТАЛ(ГрафикиРаботы.ДатаКалендаря)              КАК КварталКалендаря,
	|	МЕСЯЦ(ГрафикиРаботы.ДатаКалендаря)                КАК МесяцКалендаря,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ГрафикиРаботы.ДатаКалендаря) КАК КалендарныеДни,
	|	ГрафикиРаботы.ВидДня                              КАК ВидДня,
	|	ГрафикиРаботы.Магазин                             КАК Ссылка
	|ИЗ
	|	РегистрСведений.ГрафикиРаботыМагазинов            КАК ГрафикиРаботы
	|ГДЕ
	|	ГрафикиРаботы.Год = &Год
	|	И ГрафикиРаботы.Магазин = &Магазин
	|
	|
	|СГРУППИРОВАТЬ ПО
	|	ГОД(ГрафикиРаботы.ДатаКалендаря),
	|	КВАРТАЛ(ГрафикиРаботы.ДатаКалендаря),
	|	МЕСЯЦ(ГрафикиРаботы.ДатаКалендаря),
	|	ГрафикиРаботы.ВидДня,
	|	ГрафикиРаботы.Магазин
	|УПОРЯДОЧИТЬ ПО 
	|	КВАРТАЛ(ГрафикиРаботы.ДатаКалендаря),
	|	МЕСЯЦ(ГрафикиРаботы.ДатаКалендаря)
	|ИТОГИ ПО
	|	Ссылка,
	|	ГодКалендаря,
	|	КварталКалендаря,
	|	МесяцКалендаря");
	    	
	Запрос.УстановитьПараметр("Магазин", ПараметрыПечати.Магазин);
	Запрос.УстановитьПараметр("Год", ПараметрыПечати.Год);
	Результаты = Запрос.ВыполнитьПакет();
	Макет      = УправлениеПечатью.МакетПечатнойФормы("Справочник.Магазины.ПФ_MXL_ГрафикРаботыМагазина");
    	
	ОбластьЗаголовок      = Макет.ПолучитьОбласть("Заголовок");
	ОбластьКвартал        = Макет.ПолучитьОбласть("Квартал");
    ОбластьШапкаКвартала  = Макет.ПолучитьОбласть("ШапкаКвартала");
	ОбластьКолонкаМесяца  = Макет.ПолучитьОбласть("КолонкаМесяца");
	ОбластьСреднемесячный = Макет.ПолучитьОбласть("Среднемесячный");
	ОбластьСреднее        = Макет.ПолучитьОбласть("КолонкаМесяцаСр");
		
	ВыборкаПоМагазинам  = Результаты[0].Выбрать();
	ВыборкаПоКалендарям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	
			
	Пока ВыборкаПоМагазинам.Следующий() Цикл
		
		Если НЕ ВыборкаПоКалендарям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоМагазинам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// ЗАГОЛОВОК
		
		ОбластьЗаголовок.Параметры.Год     = Формат(ВыборкаПоМагазинам.Год, "ЧЦ=4; ЧГ=0");
		ОбластьЗаголовок.Параметры.Магазин = ВыборкаПоМагазинам.МагазинПредставление;
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// КАЛЕНДАРЬ
		ВыборкаПоГоду = ВыборкаПоКалендарям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоГоду.Следующий() Цикл
			
			КалендарныеДниГод = 0;
			РабочееВремя40Год = 0;
			РабочееВремя36Год = 0;
			РабочееВремя24Год = 0;
			РабочиеДниГод	  = 0;
			ВыходныеДниГод	  = 0;
			
			ВыборкаПоКварталу = ВыборкаПоГоду.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаПоКварталу.Следующий() Цикл
				
				ОбластьКвартал.Параметры.НомерКвартала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 квартал'"), ВыборкаПоКварталу.КварталКалендаря);
				ТабличныйДокумент.Вывести(ОбластьКвартал);
				ТабличныйДокумент.Вывести(ОбластьШапкаКвартала);
				
				КалендарныеДниКв = 0;
				РабочееВремя40Кв = 0;
				РабочееВремя36Кв = 0;
				РабочееВремя24Кв = 0;
				РабочиеДниКв	 = 0;
				ВыходныеДниКв	 = 0;
				
				Если ВыборкаПоКварталу.КварталКалендаря = 1 ИЛИ ВыборкаПоКварталу.КварталКалендаря = 3 Тогда
					
					КалендарныеДниПолугодие1 = 0;
					РабочееВремя40Полугодие1 = 0;
					РабочееВремя36Полугодие1 = 0;
					РабочееВремя24Полугодие1 = 0;
					РабочиеДниПолугодие1	 = 0;
					ВыходныеДниПолугодие1	 = 0;
					
				КонецЕсли;
				
				ВыборкаПоМесяцу = ВыборкаПоКварталу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаПоМесяцу.Следующий() Цикл
					
					ВыходныеДни 	= 0;
					РабочееВремя40 	= 0;
					РабочееВремя36 	= 0;
					РабочееВремя24 	= 0;
					КалендарныеДни 	= 0;
					РабочиеДни 		= 0;
					ВыборкаПоВидуДня = ВыборкаПоМесяцу.Выбрать(ОбходРезультатаЗапроса.Прямой);
					
					Пока ВыборкаПоВидуДня.Следующий() Цикл
						
						Если ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота 
							ИЛИ ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье 
							ИЛИ ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник Тогда
							
							ВыходныеДни = ВыходныеДни + ВыборкаПоВидуДня.КалендарныеДни;
							
						ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
							
							РабочееВремя40 = РабочееВремя40 + ВыборкаПоВидуДня.КалендарныеДни * 8;
							РабочееВремя36 = РабочееВремя36 + ВыборкаПоВидуДня.КалендарныеДни*36/5;
							РабочееВремя24 = РабочееВремя24 + ВыборкаПоВидуДня.КалендарныеДни*24/5;
							РабочиеДни 	   = РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
							
						ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
							
							РабочееВремя40 = РабочееВремя40 + ВыборкаПоВидуДня.КалендарныеДни * 7;
							РабочееВремя36 = РабочееВремя36 + ВыборкаПоВидуДня.КалендарныеДни*36/5 - 1;
							РабочееВремя24 = РабочееВремя24 + ВыборкаПоВидуДня.КалендарныеДни*24/5 - 1;
							РабочиеДни 	   = РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
							
						КонецЕсли;
						
						КалендарныеДни = КалендарныеДни + ВыборкаПоВидуДня.КалендарныеДни;
						
					КонецЦикла; // вид дня
					
					КалендарныеДниКв = КалендарныеДниКв + КалендарныеДни;
					РабочееВремя40Кв = РабочееВремя40Кв + РабочееВремя40;
					РабочееВремя36Кв = РабочееВремя36Кв + РабочееВремя36;
					РабочееВремя24Кв = РабочееВремя24Кв + РабочееВремя24;
					РабочиеДниКв	 = РабочиеДниКв 	+ РабочиеДни;
					ВыходныеДниКв	 = ВыходныеДниКв	+ ВыходныеДни;
					
					КалендарныеДниПолугодие1 = КалендарныеДниПолугодие1 + КалендарныеДни;
					РабочееВремя40Полугодие1 = РабочееВремя40Полугодие1 + РабочееВремя40;
					РабочееВремя36Полугодие1 = РабочееВремя36Полугодие1 + РабочееВремя36;
					РабочееВремя24Полугодие1 = РабочееВремя24Полугодие1 + РабочееВремя24;
					РабочиеДниПолугодие1	 = РабочиеДниПолугодие1 	+ РабочиеДни;
					ВыходныеДниПолугодие1	 = ВыходныеДниПолугодие1	+ ВыходныеДни;
					
					КалендарныеДниГод = КалендарныеДниГод + КалендарныеДни;
					РабочееВремя40Год = РабочееВремя40Год + РабочееВремя40;
					РабочееВремя36Год = РабочееВремя36Год + РабочееВремя36;
					РабочееВремя24Год = РабочееВремя24Год + РабочееВремя24;
					РабочиеДниГод	  = РабочиеДниГод 	+ РабочиеДни;
					ВыходныеДниГод	  = ВыходныеДниГод	+ ВыходныеДни;
					
					ОбластьКолонкаМесяца.Параметры.ВыходныеДни = ВыходныеДни;
					ОбластьКолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40;
					ОбластьКолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36;
					ОбластьКолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24;
					ОбластьКолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДни;
					ОбластьКолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДни;
					ОбластьКолонкаМесяца.Параметры.ИмяМесяца 		= Формат(Дата(ВыборкаПоГоду.ГодКалендаря, ВыборкаПоМесяцу.Месяцкалендаря,1),"ДФ=ММММ");
					ТабличныйДокумент.Присоединить(ОбластьКолонкаМесяца);
					
				КонецЦикла; // месяц
				
				ОбластьКолонкаМесяца.Параметры.ВыходныеДни   	= ВыходныеДниКв;
				ОбластьКолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Кв;
				ОбластьКолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Кв;
				ОбластьКолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Кв;
				ОбластьКолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниКв;
				ОбластьКолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниКв;
				ОбластьКолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 квартал'"), ВыборкаПоКварталу.КварталКалендаря);
				ТабличныйДокумент.Присоединить(ОбластьКолонкаМесяца);
				
				Если ВыборкаПоКварталу.КварталКалендаря = 2 
					ИЛИ ВыборкаПоКварталу.КварталКалендаря = 4 Тогда
					
					
					ОбластьКолонкаМесяца.Параметры.ВыходныеДни  	= ВыходныеДниПолугодие1;
					ОбластьКолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Полугодие1;
					ОбластьКолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Полугодие1;
					ОбластьКолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Полугодие1;
					ОбластьКолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниПолугодие1;
					ОбластьКолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниПолугодие1;
					ОбластьКолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 полугодие'"), ВыборкаПоКварталу.КварталКалендаря/2);
					ТабличныйДокумент.Присоединить(ОбластьКолонкаМесяца);
					
				КонецЕсли;
				
			КонецЦикла;  // квартал
			
			ОбластьКолонкаМесяца.Параметры.ВыходныеДни 	    = ВыходныеДниГод;
			ОбластьКолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Год;
			ОбластьКолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Год;
			ОбластьКолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Год;
			ОбластьКолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниГод;
			ОбластьКолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниГод;
			ОбластьКолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 год'"), Формат(ВыборкаПоГоду.ГодКалендаря, "ЧЦ=4; ЧГ=0"));
			ТабличныйДокумент.Присоединить(ОбластьКолонкаМесяца);
			
		КонецЦикла; // год
		
		ОбластьСреднемесячный.Параметры.РабочееВремя40 	= РабочееВремя40Год;
		ОбластьСреднемесячный.Параметры.РабочееВремя36 	= РабочееВремя36Год;
		ОбластьСреднемесячный.Параметры.РабочееВремя24 	= РабочееВремя24Год;
		ОбластьСреднемесячный.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 год'"), Формат(ВыборкаПоГоду.ГодКалендаря, "ЧЦ=4; ЧГ=0"));
		ТабличныйДокумент.Вывести(ОбластьСреднемесячный);
		
		ОбластьСреднее.Параметры.РабочееВремя40 	= Формат(РабочееВремя40Год / 12, "ЧДЦ=2; ЧГ=0");
		ОбластьСреднее.Параметры.РабочееВремя36 	= Формат(РабочееВремя36Год / 12, "ЧДЦ=2; ЧГ=0");
		ОбластьСреднее.Параметры.РабочееВремя24 	= Формат(РабочееВремя24Год / 12, "ЧДЦ=2; ЧГ=0");
		ОбластьСреднее.Параметры.ИмяМесяца 		= НСтр("ru = 'Среднемесячное количество'");
		ТабличныйДокумент.Присоединить(ОбластьСреднее);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоМагазинам.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
    	
КонецФункции

#КонецОбласти

#КонецЕсли
