﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает массив типов для ограничения типов элемента формы РасшифровкаПлатежаДокументРасчетовСКонтрагентом.
// Параметры:
//           ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Вид операции документа для которого
//                                                                              необходимо получить массив типов.
// Возвращаемое значение:
//           МассивТиповОграничений - Массив - Массив типов ограничивающих типы для реквизита формы
//                                             РасшифровкаПлатежаДокументРасчетовСКонтрагентом.
//
Функция ОграничениеТипаДокументаРасчетовПоХозяйственнойОперации(ХозяйственнаяОперация) Экспорт
	
	Перем МассивТиповОграничений;
	МассивТиповОграничений = Новый Массив();
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		МассивТиповОграничений.Добавить(Тип("ДокументСсылка.РеализацияТоваров"));
		МассивТиповОграничений.Добавить(Тип("ДокументСсылка.ЧекККМ"));
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
		МассивТиповОграничений.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтПокупателя"));
	КонецЕсли;
	Возврат МассивТиповОграничений;
	
КонецФункции

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
// Параметры:
//           ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хоз. операции документа для которого
//                                                                              необходимо получить массив реквизитов.
//           МассивВсехРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена всех
//                                                 реквизитов документов.
//           МассивРеквизитовОперации - Неопределено - Выходной параметр с типом Массив в который будут помещены имена
//                                                     реквизитов по виду операции документа.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("ХозяйственнаяОперация");
	МассивВсехРеквизитов.Добавить("Организация");
	МассивВсехРеквизитов.Добавить("Контрагент");
	МассивВсехРеквизитов.Добавить("ВидОплаты");
	МассивВсехРеквизитов.Добавить("Магазин");
	МассивВсехРеквизитов.Добавить("ЭквайринговыйТерминал");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.Сумма");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорПлатежногоАгента");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		МассивРеквизитовОперации.Добавить("ХозяйственнаяОперация");
		МассивРеквизитовОперации.Добавить("Организация");
		МассивРеквизитовОперации.Добавить("Магазин");
		МассивРеквизитовОперации.Добавить("Контрагент");
		МассивРеквизитовОперации.Добавить("ЭквайринговыйТерминал");
		МассивРеквизитовОперации.Добавить("ВидОплаты");
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.Сумма");
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом");
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
			МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.ДоговорПлатежногоАгента");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос();
	
	ТекстЗапроса = ТекстЗапросаТаблицаРасчетыПоЭквайрингу() + ПолучитьРазделитьЗапросов()
				   + ТекстЗапросаТаблицаРасчетыСКлиентами();
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	ИспользоватьРасчетыСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетыСКлиентами");
	Запрос.УстановитьПараметр("ИспользоватьРасчетыСКлиентами", ИспользоватьРасчетыСКлиентами);
	
	МассивПустыхДокументовРасчета = Новый Массив;
	МассивПустыхДокументовРасчета.Добавить(Документы.РеализацияТоваров.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Документы.ЧекККМ.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Документы.ВозвратТоваровОтПокупателя.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Неопределено);
	
	Запрос.УстановитьПараметр("МассивПустыхДокументовРасчета", МассивПустыхДокументовРасчета);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасчетыПоЭквайрингу", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСКлиентами",   МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

Функция ПодготовитьДанныеДляПробитияЧека(ДокументСсылка, РаспределениеВыручкиПоСекциям, НомерЧека) Экспорт
	
	ОбщиеПараметры = МенеджерОборудованияКлиентСервер.ПараметрыОперацииФискализацииЧека();
	
	// Общие параметры чека
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("КассаККМ");
	СтруктураРеквизитов.Вставить("Магазин");
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Дата");
	СтруктураРеквизитов.Вставить("Ответственный");
	СтруктураРеквизитов.Вставить("ДоговорПлатежногоАгента");
	СтруктураРеквизитов.Вставить("ВидНалога");
	СтруктураРеквизитов.Вставить("Контрагент");
	СтруктураРеквизитов.Вставить("СуммаДокумента");
	СтруктураРеквизитов.Вставить("ДокументОснование");
	СтруктураРеквизитов.Вставить("ЗаказПокупателя");
	СтруктураРеквизитов.Вставить("ХозяйственнаяОперация");
	СтруктураРеквизитов.Вставить("ВидОплаты");
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, СтруктураРеквизитов);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("НаименованиеПолное");
	СтруктураРеквизитов.Вставить("ИНН");
	СтруктураРеквизитов.Вставить("КПП");
	РеквизитыОрганизация = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.Организация, СтруктураРеквизитов);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ЭлектронныйЧекSMSПередаютсяПрограммой1С");
	СтруктураРеквизитов.Вставить("ЭлектронныйЧекEmailПередаютсяПрограммой1С");
	СтруктураРеквизитов.Вставить("СерийныйНомер");
	СтруктураРеквизитов.Вставить("Магазин");
	СтруктураРеквизитов.Вставить("Код");
	СтруктураРеквизитов.Вставить("СпособФорматноЛогическогоКонтроля", "ПодключаемоеОборудование.СпособФорматноЛогическогоКонтроля");
	СтруктураРеквизитов.Вставить("ДопустимоеРасхождениеФорматноЛогическогоКонтроля", "ПодключаемоеОборудование.ДопустимоеРасхождениеФорматноЛогическогоКонтроля");
	СтруктураРеквизитов.Вставить("ТипОборудования", "ПодключаемоеОборудование.ТипОборудования");
	РеквизитыКассыККМ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.КассаККМ, СтруктураРеквизитов);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Наименование");
	СтруктураРеквизитов.Вставить("ИНН");
	РеквизитыКассир = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.Ответственный.ФизическоеЛицо, СтруктураРеквизитов);
	
	ОбщиеПараметры.СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложенияККТ(РеквизитыДокумента.Организация, 
												РеквизитыДокумента.ВидНалога);
	
	Если РеквизитыДокумента.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		ОбщиеПараметры.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств;
		Если ЗначениеЗаполнено(РеквизитыДокумента.ДоговорПлатежногоАгента) Тогда
			НомерСекции = РаспределениеВыручкиПоСекциям.СоответствиеДоговоровСекциям.Получить(РеквизитыДокумента.ДоговорПлатежногоАгента);
		Иначе
			НомерСекции = РаспределениеВыручкиПоСекциям.НомерСекцииДляОплатыКартой;
		КонецЕсли;
		Если ОбщиеПараметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ОСН Тогда
			ЗначСтавкиНДС = УчетНДС.СтавкаНДСПоУмолчанию(ДокументСсылка.Дата);
			СтавкаНДС = ПодключаемоеОборудованиеРТ.СтавкаНДСВФорматеБПО(ЗначСтавкиНДС, Истина);	
		Иначе
			СтавкаНДС = Неопределено;
		КонецЕсли;
		ПринятоОт = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(РеквизитыДокумента.Контрагент, "НаименованиеПолное");
		Наименование = НСтр("ru = 'Оплата картой от:'") + " " + ПринятоОт + Символы.ПС
						+ НСтр("ru = 'Основание:'") + " " + РеквизитыДокумента.ДокументОснование;
	Иначе
		ОбщиеПараметры.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств;
		Если ЗначениеЗаполнено(РеквизитыДокумента.ДоговорПлатежногоАгента) Тогда
			НомерСекции = РаспределениеВыручкиПоСекциям.СоответствиеДоговоровСекциям.Получить(РеквизитыДокумента.ДоговорПлатежногоАгента);
		Иначе
			НомерСекции = РаспределениеВыручкиПоСекциям.НомерСекцииДляВозвратаОплатыНаКарту;
		КонецЕсли;
		Если ОбщиеПараметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ОСН Тогда
			ЗначСтавкиНДС = УчетНДС.СтавкаНДСПоУмолчанию(ДокументСсылка.Дата);
			СтавкаНДС = ПодключаемоеОборудованиеРТ.СтавкаНДСВФорматеБПО(ЗначСтавкиНДС, Ложь);	
		Иначе
			СтавкаНДС = Неопределено;
		КонецЕсли;
		Вернуть = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(РеквизитыДокумента.Контрагент, "НаименованиеПолное");
		Наименование = НСтр("ru = 'Возврат на карту:'") + " " + Вернуть + Символы.ПС
						+ НСтр("ru = 'Основание:'") + " " + РеквизитыДокумента.ДокументОснование
	КонецЕсли;
	
	ОбщиеПараметры.Электронно = Ложь;
	
	// Параметры необходимые для чека ЕНВД на принтере чеков
	ОбщиеПараметры.ДокументОснование = ДокументСсылка;
	
	ОбщиеПараметры.Кассир          = РеквизитыКассир.Наименование;
	ОбщиеПараметры.Вставить("ИмяКассира", РеквизитыКассир.Наименование);
	ОбщиеПараметры.КассирИНН       = РеквизитыКассир.ИНН;
	
	ОбщиеПараметры.Организация    = РеквизитыДокумента.Организация;
	ОбщиеПараметры.ОрганизацияНазвание = РеквизитыОрганизация.НаименованиеПолное;
	ОбщиеПараметры.ОрганизацияИНН = РеквизитыОрганизация.ИНН;
	ОбщиеПараметры.ОрганизацияКПП = РеквизитыОрганизация.КПП;
	ОбщиеПараметры.НомерКассы     = РеквизитыКассыККМ.Код;
	ОбщиеПараметры.НомерЧека      = НомерЧека;
	ОбщиеПараметры.ТорговыйОбъект = РеквизитыДокумента.Магазин;

	ОбщиеПараметры.НомерСмены = 1;
	
	СведенияООрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(РеквизитыДокумента.Организация, РеквизитыДокумента.Дата);
	АдресМагазина = ОбщегоНазначенияРТ.АдресМагазина(РеквизитыКассыККМ.Магазин);
	
	СерийныйНомер = РеквизитыКассыККМ.СерийныйНомер;
	Если НЕ ЗначениеЗаполнено(СерийныйНомер) Тогда
		СерийныйНомер = "1";
	КонецЕсли;
	
	ОбщиеПараметры.АдресРасчетов = АдресМагазина;
	ОбщиеПараметры.МестоРасчетов = Строка(РеквизитыКассыККМ.Магазин) + " " + АдресМагазина;
	ОбщиеПараметры.АдресМагазина = АдресМагазина;
	ОбщиеПараметры.НаименованиеМагазина = Строка(РеквизитыКассыККМ.Магазин);
	ОбщиеПараметры.СерийныйНомер = СерийныйНомер;
	
	ПодключаемоеОборудованиеРТ.ЗаполнитьПараметрыПлатежногоДоговора(ОбщиеПараметры, 
																	РеквизитыДокумента.ДоговорПлатежногоАгента,
																	РеквизитыДокумента.СуммаДокумента);
	
	Если ЗначениеЗаполнено(РеквизитыДокумента.ДоговорПлатежногоАгента) Тогда
		НомерСекции = РаспределениеВыручкиПоСекциям.СоответствиеДоговоровСекциям.Получить(РеквизитыДокумента.ДоговорПлатежногоАгента);
	Иначе
		НомерСекции = 1;
	КонецЕсли;
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("НомерСекции", НомерСекции);
	
	ОбщиеПараметры.КассаККМ = РеквизитыДокумента.КассаККМ;
	
	РасшифровкаПлатежа = РасшифровкаПлатежа(ДокументСсылка);
	
	СуммаДокументовРасчетов = 0;
	
	Для Каждого СтрокаПлатежа Из РасшифровкаПлатежа Цикл
		
		ПараметрыДокумента.Вставить("ПризнакСпособаРасчета", СтрокаПлатежа.ПризнакСпособаРасчета);
		ТабличнаяЧастьТоварыОтсутствует = ТипЗнч(СтрокаПлатежа.ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой");
		Если ЗначениеЗаполнено(СтрокаПлатежа.ДокументРасчетовСКонтрагентом) 
			И НЕ ТабличнаяЧастьТоварыОтсутствует Тогда
			ПодключаемоеОборудованиеРТ.ДобавитьСтрокиДляФискализацииТоваров(СтрокаПлатежа.ДокументРасчетовСКонтрагентом, ПараметрыДокумента, ОбщиеПараметры, СуммаДокументовРасчетов);
		ИначеЕсли ЗначениеЗаполнено(РеквизитыДокумента.ЗаказПокупателя) Тогда
			ПодключаемоеОборудованиеРТ.ДобавитьСтрокиДляФискализацииТоваров(РеквизитыДокумента.ЗаказПокупателя, ПараметрыДокумента, ОбщиеПараметры, СуммаДокументовРасчетов);
		Иначе
			СтрокаПозицииЧека = МенеджерОборудованияКлиентСервер.ПараметрыФискальнойСтрокиЧека(); 
			
			СтрокаПозицииЧека.Наименование = Наименование;
			СтрокаПозицииЧека.Количество     = 1;
			СтрокаПозицииЧека.Цена           = СтрокаПлатежа.Сумма;
			СтрокаПозицииЧека.ЦенаСоСкидками = СтрокаПлатежа.Сумма;
			СтрокаПозицииЧека.Сумма          = СтрокаПлатежа.Сумма;
			СтрокаПозицииЧека.НомерСекции    = НомерСекции;
			СтрокаПозицииЧека.СтавкаНДС      = СтавкаНДС;
			
			СтрокаПозицииЧека.ПризнакСпособаРасчета = СтрокаПлатежа.ПризнакСпособаРасчета;
			СтрокаПозицииЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПлатежВыплата;
			
			ПодключаемоеОборудованиеРТ.ЗаполнитьПараметрыПлатежногоДоговораВСтроке(ОбщиеПараметры, СтрокаПозицииЧека);
			
			ОбщиеПараметры.ПозицииЧека.Добавить(СтрокаПозицииЧека);
			СуммаДокументовРасчетов = СуммаДокументовРасчетов + СтрокаПлатежа.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	Если РеквизитыКассыККМ.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		// При необходимости будет проведен формато-логический контроль
		ОбщиеПараметры.СпособФорматноЛогическогоКонтроля = РеквизитыКассыККМ.СпособФорматноЛогическогоКонтроля;
		ОбщиеПараметры.ДопустимоеРасхождениеФорматноЛогическогоКонтроля = РеквизитыКассыККМ.ДопустимоеРасхождениеФорматноЛогическогоКонтроля;
		Если ФорматноЛогическийКонтрольКлиентСервер.НуженФорматноЛогическийКонтроль(ОбщиеПараметры) Тогда
			ФорматноЛогическийКонтрольКлиентСервер.ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры);
		КонецЕсли;
	КонецЕсли;
	
	СтрокаНаименованиеОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Оплата по карте %1'"), РеквизитыДокумента.ВидОплаты);
	СтрокаОплаты = Новый Структура();
	СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Электронно);
	СтрокаОплаты.Вставить("Наименование", СтрокаНаименованиеОплаты);
	СтрокаОплаты.Вставить("Сумма", РеквизитыДокумента.СуммаДокумента);
	ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	
	РазницаСумм = СуммаДокументовРасчетов - РеквизитыДокумента.СуммаДокумента;
	Если РазницаСумм > 0 Тогда
		СтрокаОплаты = Новый Структура();
		СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Постоплата);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Постоплата'"));
		СтрокаОплаты.Вставить("Сумма", РазницаСумм);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	КонецЕсли;
	
	Возврат ОбщиеПараметры;
	
КонецФункции // ПодготовитьДанныеДляПробитияЧека()

// Заполнение признака способа расчета в строке Расшифровка платежа
//
// Параметры:
//  Объект - ДокументОбъект.РасходныйКассовыйОрдер, ДанныеФормыСтруктуры
//  ДокументРасчетовСКонтрагентом - ДокументСсылка.ПоступлениеТоваров, ДокументСсылка.ПриходныйКассовыйОрдер, ДокументСсылка.ЗаказПоставщику, ДокументСсылка.ВозвратТоваровОтПокупателя, ДокументСсылка.ВводОстатковРасчетовСКлиентами
//  СуммаПлатежа - Число,  Реквизит "Сумма" строки "РасшифровкаПлатежа"
//  ПризнакСпособаРасчета - Перечисление.ПризнакиСпособаРасчета, Реквизит "ПризнакСпособаРасчета" строки "РасшифровкаПлатежа"
//  ЗаказПокупателя - ДокументСсылка.ЗаказПокупателя, Реквизит объекта "ЗаказПокупателя"
//
Процедура ЗаполнениеПризнакаСпособаРасчета(Объект, ДокументРасчетовСКонтрагентом, СуммаПлатежа, ПризнакСпособаРасчета, ЗаказПокупателя) Экспорт
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		
		Если НЕ ЗначениеЗаполнено(ДокументРасчетовСКонтрагентом) Тогда
			Если ЗначениеЗаполнено(ЗаказПокупателя) Тогда
				Если СуммаПлатежа >= ЗаказПокупателя.СуммаДокумента Тогда
					ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная;
				Иначе
					ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаЧастичная;
				КонецЕсли;
			Иначе
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.Аванс;
			КонецЕсли; 
		ИначеЕсли ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.РеализацияТоваров")
				  ИЛИ ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ЧекККМ") Тогда
			ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ОплатаКредита;
		КонецЕсли;
	Иначе
		Если ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")
			ИЛИ ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда 
			Если СуммаПлатежа >= ДокументРасчетовСКонтрагентом.СуммаДокумента Тогда
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
			Иначе
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполнить признака способа расчета в строке Расшифровка платежа
//
// Параметры:
//  Объект - ДокументОбъект.РасходныйКассовыйОрдер, ДанныеФормыСтруктуры
//
Процедура ЗаполнениеПризнаковСпособовРасчета(Объект) Экспорт
	
	Для каждого СтрокаРасшифровкиПлатежа Из Объект.РасшифровкаПлатежа Цикл
		ЗаполнениеПризнакаСпособаРасчета(Объект,
										 СтрокаРасшифровкиПлатежа.ДокументРасчетовСКонтрагентом, 
										 СтрокаРасшифровкиПлатежа.Сумма, 
										 СтрокаРасшифровкиПлатежа.ПризнакСпособаРасчета,
										 Объект.ЗаказПокупателя)
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаТаблицаРасчетыПоЭквайрингу()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Магазин КАК Магазин,
	|	ДанныеДокумента.ВидОплаты КАК ВидОплаты,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаОперацийПродажи,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СуммаКомиссии > 0
	|			ТОГДА ДанныеДокумента.СуммаКомиссии
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НачисленнаяСуммаКомиссии,
	|	0 КАК СуммаОперацийВозврата,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СуммаКомиссии < 0
	|			ТОГДА - ДанныеДокумента.СуммаКомиссии
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВозвращаемаяСуммаКомиссии
	|ИЗ
	|	Документ.ОплатаОтПокупателяПлатежнойКартой КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.ЭквайринговыйТерминал,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Магазин,
	|	ДанныеДокумента.ВидОплаты,
	|	0,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СуммаКомиссии > 0
	|			ТОГДА ДанныеДокумента.СуммаКомиссии
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ДанныеДокумента.СуммаДокумента,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СуммаКомиссии < 0
	|			ТОГДА - ДанныеДокумента.СуммаКомиссии
	|		ИНАЧЕ 0
	|	КОНЕЦ
	|ИЗ
	|	Документ.ОплатаОтПокупателяПлатежнойКартой КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыСКлиентами()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Магазин КАК Магазин,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ЕСТЬNULL(ТабличнаяЧастьРасшифровкаПлатежа.Сумма, ДанныеДокумента.СуммаДокумента) КАК Сумма,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом, ДанныеДокумента.Ссылка) В (&МассивПустыхДокументовРасчета)
	|			ТОГДА ДанныеДокумента.Ссылка
	|		ИНАЧЕ ЕСТЬNULL(ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом, ДанныеДокумента.Ссылка)
	|	КОНЕЦ КАК ДокументРасчета,
	|	ВЫБОР
	|		КОГДА ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.РеализацияТоваров
	|			ТОГДА ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом.ЗаказПокупателя
	|		ИНАЧЕ ДанныеДокумента.ЗаказПокупателя
	|	КОНЕЦ КАК ЗаказПокупателя
	|ИЗ
	|	Документ.ОплатаОтПокупателяПлатежнойКартой КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОплатаОтПокупателяПлатежнойКартой.РасшифровкаПлатежа КАК ТабличнаяЧастьРасшифровкаПлатежа
	|		ПО (ТабличнаяЧастьРасшифровкаПлатежа.Ссылка = ДанныеДокумента.Ссылка)
	|ГДЕ
	|	&ИспользоватьРасчетыСКлиентами
	|	И ДанныеДокумента.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧастьРасшифровкаПлатежа.НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьРазделитьЗапросов()

	СтрокаРазделителя = 
	"
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат СтрокаРазделителя

КонецФункции // ПолучитьРазделитьЗапросов()

Функция РасшифровкаПлатежа(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОплатаОтПокупателяПлатежнойКартойРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
	|	ОплатаОтПокупателяПлатежнойКартойРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом,
	|	ОплатаОтПокупателяПлатежнойКартойРасшифровкаПлатежа.Сумма КАК Сумма,
	|	ОплатаОтПокупателяПлатежнойКартойРасшифровкаПлатежа.ПризнакСпособаРасчета КАК ПризнакСпособаРасчета
	|ИЗ
	|	Документ.ОплатаОтПокупателяПлатежнойКартой.РасшифровкаПлатежа КАК ОплатаОтПокупателяПлатежнойКартойРасшифровкаПлатежа
	|ГДЕ
	|	ОплатаОтПокупателяПлатежнойКартойРасшифровкаПлатежа.Ссылка = &ДокументСсылка";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
