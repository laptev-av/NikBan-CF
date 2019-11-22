﻿
////////////////////////////////////////////////////////////////////////////////
//
// ИнтеграцияГИСМКлиент : переопределяемые сеоверные процедуры и функции подсистемы "Интеграция с ГИСМ"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предоставляет возможность переопределить обработку заполнения документа "Заявка на выпуск КиЗ".
//
// Параметры:
//  ЗаявкаОбъект - ДокументОбъект.ЗаявкаНаВыпускКиЗ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка,Неопределено - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияЗаявкиНаВыпускКиЗ(ЗаявкаОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ЗаполнитьЗаявкуНаВыпускКиЗНаОснованииДругогоДокумента(ЗаявкаОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		
	КонецЕсли;
	
	ЗаявкаОбъект.Ответственный = Пользователи.ТекущийПользователь();
	ЗаявкаОбъект.Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(ЗаявкаОбъект.Организация);
	
КонецПроцедуры

// Предоставляет возможность переопределить заполение документа "Заявка на выпуск КиЗ".
//
// Параметры:
//  ЗаявкаОбъект         - ДокументОбъект.ЗаявкаНаВыпускКиЗ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ЗаполнитьЗаявкуНаВыпускКиЗНаОснованииДругогоДокумента(ЗаявкаОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьЗаявкуНаВыпускКиЗНаОснованииЗаказаПоставщику(ЗаявкаОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление об отгрузке маркированных товаров ГИСМ".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОбОтгрузкеГИСМ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		
		ИнтеграцияГИСМ_РТ.ЗаполнитьУведомлениеОбОтгрузкеГИСМНаОснованииРеализации(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		ИнтеграцияГИСМ_РТ.ЗаполнитьУведомлениеОбОтгрузкеГИСМНаОснованииВозвратаТоваровПоставщику(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		
	КонецЕсли;
	
	УведомлениеОбъект.Ответственный = Пользователи.ТекущийПользователь();
	КонецПроцедуры
	
// Предоставляет возможность переопределить обработку заполнения документа "Уведомление о ввозе маркированных товаров из ЕАЭС".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОВвозеИзЕАЭСГИСМ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьУведомлениеОВвозеИзЕАЭСГИСМНаОснованииПоступления(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	УведомлениеОбъект.Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление об импорте маркированных товаров".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОбИмпортеМаркированныхТоваровГИСМ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОбИмпортеГИСМ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьУведомлениеОбИмпортеГИСМНаОснованииПоступления(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	УведомлениеОбъект.Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление о списании КиЗ для маркировки".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОСписанииКиЗГИСМ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОСписанииКиЗ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СписаниеТоваров") Тогда
		ИнтеграцияГИСМ_РТ.ЗаполнитьУведомлениеОСписанииКиЗНаОснованииВнутреннегоПотребления(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	УведомлениеОбъект.Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление об импорте маркированных товаров".
//
// Параметры:
//  Объект - ДокументОбъект.УведомлениеОбИмпортеМаркированныхТоваровГИСМ - документ, для которого выполняется заполнение.
//  Отказ - Булево - Признак отказа.
//  ПроверяемыеРеквизиты - Массив - Проверяемые реквизиты.
//
Процедура УведомлениеОбИмпортеОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	ИнтеграцияГИСМ_РТ.УведомлениеОбИмпортеОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

// Определяет контрагента по ИНН и КПП
//
// Параметры:
//  ИНН  - Строка - ИНН контрагента.
//  КПП  - Строка - КПП контрагента.
//
// Возвращаемое значение:
//   ОпределяемыйТип.КонтрагентГИСМ, Неопределено  - Найденный контрагент или Неопределено, если поиск завершился неудачей.
//
Функция КонтрагентПоИННКПП(ИНН, КПП) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.КонтрагентПоИННКПП(ИНН, КПП);
	
КонецФункции

// Возвращает структуру, содержащую ИНН и КПП контагента.
//
// Параметры:
//  Контрагент - ОпределяемыйТип.КонтрагентГИСМ - контрагент.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     ИНН  - Строка - ИНН контрагента.
//     КПП  - Строка - КПП контрагента.
//
Функция ИННКПППоКонтрагенту(Контрагент) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ИННКПППоКонтрагенту(Контрагент);
	
КонецФункции

// Возвращает структуру, содержащую ИНН, КПП, GLN организации.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация.
//  Подразделение - ОпределяемыйТип.Подразделение - Подразделение организации.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     ИНН  - Строка - ИНН контрагента.
//     КПП  - Строка - КПП контрагента.
//     GLN  - Строка - GLN контрагента.
//
Функция ИННКППGLNОрганизации(Организация, Подразделение) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ИННКППGLNОрганизации(Организация, Подразделение);
	
КонецФункции

// Возвращает структуру, содержащую Страну, Регистрационный номер, наименование, признак физического лица, ИНН и КПП.
//
// Параметры:
//  Контрагент - ОпределяемыйТип.КонтрагентГИСМ - Контрагент.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     Страна  - Строка - Страна регистрации контрагента.
//     РегистрационныйНомер  - Строка - Регистриционный номер контрагента.
//     Наименование  - Строка - Наименование контрагента.
//     НаименованиеПолное  - Строка - Полное наименование контрагента.
//     ЭтоФизическоеЛицо  - Булево - Признак физического лица.
//     ИНН  - Строка - ИНН контрагента.
//     КПП  - Строка - КПП контрагента.
//     ЮридическийАдрес - Строка - Юридический адрес контрагента.
//
Функция РеквизитыКонтрагента(Контрагент) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.РеквизитыКонтрагента(Контрагент);
	
КонецФункции

// Проверяет использование подразделений в информационной базе.
// 
// Возвращаемое значение:
//  Булево - Подразделения используются.
//
Функция ИспользоватьПодразделения() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ИспользоватьПодразделения();
	
КонецФункции

// Проверяет использование заявок на выпуск КиЗ.
// 
// Возвращаемое значение:
//  Булево - Заявки используются.
//
Функция ИспользоватьЗаявкиНаВыпускКиЗ() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Проверяет использование нескольких организаций в информационной базе.
// 
// Возвращаемое значение:
//  Булево - Несколько организаций используются.
//
Функция ИспользоватьНесколькоОрганизаций() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ИспользоватьНесколькоОрганизаций();
	
КонецФункции

// Документ-основание является возвратом поставщику
//
// Параметры:
//  ДокументСсылка - ДокументСсылка- Документ-основание
// 
// Возвращаемое значение:
//  Булево - Основание является возвратом поставщику
//
Функция ДокументОснованиеВозвратПоставщику(ДокументСсылка) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ДокументОснованиеВозвратПоставщику(ДокументСсылка);
	
КонецФункции

// Получить организацию и подразделение документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ, подразделение и организацию которого необходимо получить.
// 
// Возвращаемое значение:
//  Структура со свойствами:
//    * Организация - ОпределяемыйТип.Организация - Организация документа.
//    * Подразделение - ОпределяемыйТип.Подразделение - Подразделение документа.
//
Функция ОрганизацияПодразделениеДокумента(ДокументСсылка) Экспорт
	
	
	Возврат Неопределено;
	
КонецФункции

// Позволяет определить получение валюты регламентированного учета.
//
// Возвращаемое значение:
//  СправочникСсылка.Валюты - Валюта регламентированного учета.
//
Функция ВалютаРегламентированногоУчета() Экспорт
	
	Возврат НСтр("ru = 'руб.'") 
	
КонецФункции

// В данной функции необходимо реализовать запрос, который определяет поступившие КиЗ
// для документов "Заявка на выпуск КиЗ", "Уведомление о поступлении маркированной продукции".
//
// Параметры:
//  Объект - ДокументОбъект, ДанныеФормыСтруктура - Объект
//
// Возвращаемое значение:
//  Запрос - Запрос для определения поступивших КиЗ.
//
Функция ЗапросПоПоступившимКиЗ(Объект) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ЗапросПоПоступившимКиЗ(Объект);
	
КонецФункции

// Обновляет в табличной части документа "Заявкам на выпуск КиЗ" табличную часть "Заказанные КиЗ"
//
// Параметры:
//  Объект - ДокументОбъект, ДанныеФормыСтруктура - Объект
//
Процедура ОбновитьКолонкиВыпущеноПолученоВТЧЗаказанныеКиЗ(Объект) Экспорт
	
	ИнтеграцияГИСМ_РТ.ОбновитьКолонкиВыпущеноПолученоВТЧЗаказанныеКиЗ(Объект);
	
КонецПроцедуры

// Получает данные по "Заявкам на выпуск КиЗ" для заполнения обработки "Подтверждение поступивших КиЗ".
//
// Параметры:
//  ДокументыКПодтверждению - Массив - Содержит документы "Заявка на выпуск КиЗ", для которых будет выполняться подтверждение поступления.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     НомераКиЗКПодтверждению - ТаблицаЗначений - содержит данные по выпущенным КиЗ, их статусам и документам поступления.
//     ПроблемыДублиКиЗ        - ТаблицаЗначений - содержит информацию о дублирующихся в обрабатываемых документах номерах КиЗ.
//     ПроблемыСопоставления   - ТаблицаЗначений - содержит информацию о выпущенных киз, которые не удалость сопоставить заказанным КиЗ.
//
Функция ДанныеПоЗаявкамНаВыпускКиЗ(ДокументыКПодтверждению) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ДанныеПоЗаявкамНаВыпускКиЗ(ДокументыКПодтверждению);
	
КонецФункции

// Получает данные по "Заявкам на выпуск КиЗ" для заполнения обработки "Подтвреждение поступивших КиЗ".
//
// Параметры:
//  ДокументыКПодтверждению - Массив - Содержит документы "Заявка на выпуск КиЗ", для которых будет выполняться подтверждение поступления.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     НомераКиЗКПодтверждению - ТаблицаЗначений - содержит данные по ожидаемым маркированным товарам, их статусам и документам поступления.
//     ПроблемыДублиКиЗ        - ТаблицаЗначений - содержит информацию о дублирующихся в обрабатываемых документах номерах КиЗ ожидаемых товарах.
//     ПроблемыСопоставления   - Неопределено    - всегда устанавливается в Неопределено.
//
Функция ДанныеПоУведомлениямОПоступлении(ДокументыКПодтверждению) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ДанныеПоУведомлениямОПоступлении(ДокументыКПодтверждению);
	
КонецФункции

// Позволяет переопределить представление номенклатуры, исходя из представления номенклатуры и характеристики.
//
// Параметры:
//  НоменклатураПредставление - Строка - представление номенклатуры.
//  ХарактеристикаПредставление - Строка - представление характеристики номенклатуры.
//
// Возвращаемое значение:
//   Строка - сформированное представление номенклатуры.
//
Функция ПредставлениеНоменклатуры(НоменклатураПредставление, ХарактеристикаПредставление) Экспорт
	
	Возврат ОбщегоНазначенияРТ.ПолучитьПредставлениеНоменклатуры(НоменклатураПредставление, ХарактеристикаПредставление);
	
КонецФункции

// Формирует текст запроса для отчета "ПоступленияБезДокументовГИСМ"
//
// Параметры:
//  ИмяНабораДанных - Строка - определяет, по каким документу ГИСМ будут получаться данные. 
//     Если имя "КиЗ", то по "Заявкам на выпуск КиЗ", если "МаркированныеТовары", то по "Уведомлениям о поступлении маркированной продукции"
//  ОтборОрганизация - ОпределяемыйТип.Организация - отбор по организации.
//  ОтборКонтрагент  - ОпределяемыйТип.Контрагенты - отбор по контрагентам.
// 
// Возвращаемое значение:
//  Строка - текст запроса.
//
Функция ТекстЗапросаПоПроблемнымПоступлениям(ИмяНабораДанных, ОтборОрганизация, ОтборКонтрагент) Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаПоПроблемнымПоступлениям(ИмяНабораДанных, ОтборОрганизация, ОтборКонтрагент);
	
КонецФункции

#Область МенюОтчеты

// Заполнить подменю отчеты в командной панели формы
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, на которую требуется добавить отчеты.
//
Процедура ЗаполнитьПодменюОтчеты(Форма) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандуДвиженияДокумента(КомандыОтчетов) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПодпискиНаСобытия

// Обрабочик события перед записью, документов влияющих на расчет поступления КиЗ от эмитента.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//  РежимЗаписи  - РежимЗаписиДокумента - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//  РежимПроведения - РежимПроведенияДокумента - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура ВлияющийНаСтатусПоступленияКиЗДокументПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ИнтеграцияГИСМ_РТ.ВлияющийНаСтатусПоступленияКиЗДокументПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Обрабочик события при проведении, документов влияющих на расчет поступления КиЗ от эмитента.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//  РежимПроведения - РежимПроведенияДокумента - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура ВлияющийНаСтатусПоступленияКиЗДокументПриПроведении(Источник, Отказ, РежимПроведения) Экспорт
	
	ИнтеграцияГИСМ_РТ.ВлияющийНаСтатусПоступленияКиЗДокументПриПроведении(Источник, Отказ, РежимПроведения);
	
КонецПроцедуры

// Обрабочик события при записи документа "Заявка на выпуск КиЗ" и его оснований для расчета статуса заявки.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусЗаявкиНаВыпускКиЗ(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМ_РТ.РассчитатьСтатусЗаявкиНаВыпускКиЗ(Источник, Отказ);
	
КонецПроцедуры

// Обрабочик события при записи документа "Уведомления о поступлении маркированных товаров" для расчета статуса уведомления.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусУведомленияОПоступлении(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМ_РТ.РассчитатьСтатусУведомленияОПоступлении(Источник, Отказ);
	
КонецПроцедуры

// Обрабочик события при записи документа "Уведомления о отгрузке маркированных товаров" и его основаних для расчета статуса уведомления.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусУведомленияОбОтгрузке(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМ_РТ.РассчитатьСтатусУведомленияОбОтгрузке(Источник, Отказ);
	
КонецПроцедуры

// Обрабочик события при записи документов, влияющих на расчет состояних информирования ГИСМ для расчета статуса уведомлени1.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусИнформированияГИСМ(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМ_РТ.РассчитатьСтатусИнформированияГИСМ(Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполненияПредставленияТоваров

// Заполняет представление номенклатуры в документах уведомлениях по номерам КиЗ, указанным в документе основании.
//
// Параметры:
//  Основание  - ДокументСсылка - документ, являющийся основанием для уведомления.
//  НомераКиЗ  - ТабличнаяЧастьДокумента - ТЧ, которая содержит колонку НомерКиЗ.
//
Процедура ЗаполнитьПредставлениеТоваровУведомленияПоНомерамКиЗОснования(Основание, НомераКиЗ) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьПредставлениеТоваровУведомленияПоНомерамКиЗОснования(Основание, НомераКиЗ);
	
КонецПроцедуры

// Заполняет представление номенклатуры в документе "Уведомление о поступлении маркированной продукции" по номерам КиЗ, указанным в документе основании.
//
// Параметры:
//  НомераКиЗ  - ТабличнаяЧастьДокумента - ТЧ, которая содержит колонку НомерКиЗ.
//
Процедура ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(НомераКиЗ) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(НомераКиЗ);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаявкаНаВыпускКиЗ

// Проверяет корректность заказываемых КиЗ. В одном документе могут быть либо персонифицированные, либо неперсонифицированные КиЗ.
//
// Параметры:
//  Объект             - ДокументОбъект - документ, в котором выполняется проверка.
//  ИмяТабличнойЧасти  - Строка - имя табличной части, которая содержит заказываемые КиЗ.
//  Отказ              - Булево - устанавливается в Ложь, если проверка завершилась неудачей.
//
Процедура ПроверитьКорректностьПерсонифицованностиЗаказываемыхКиЗ(Объект, ИмяТабличнойЧасти, Отказ) Экспорт
	
	ИнтеграцияГИСМ_РТ.ПроверитьКорректностьПерсонифицованностиЗаказываемыхКиЗ(Объект, ИмяТабличнойЧасти, Отказ);
	
КонецПроцедуры

// Проверяет указания характеристик в табличной части документа.
//
// Параметры:
//  Объект                         - ДокументОбъект - документ, в котором выполняется проверка.
//  МассивНепроверяемыхРеквизитов  - Массив - содержит реквизиты, для которых в метаданных установлен признак проверки, но они исключаются из платформенной проверки.
//  ИмяТаблицы                     - Строка - имя табличной части, которая содержит заказываемые КиЗ.
//  Отказ                          - Булево - устанавливается в Ложь, если проверка завершилась неудачей.
//
Процедура ПроверитьЗаполнениеХарактеристик(Объект, МассивНепроверяемыхРеквизитов, ИмяТаблицы, Отказ) Экспорт
	
	ИнтеграцияГИСМ_РТ.ПроверитьЗаполнениеХарактеристик(Объект, МассивНепроверяемыхРеквизитов, ИмяТаблицы, Отказ);
	
КонецПроцедуры

// Обрабатывает результат подбора заказываемых КиЗ в документе "Заявка на выпуск КиЗ".
//
// Параметры:
//  Форма              - УправляемаяФорма - форма, из которой был вызван подбор.
//  ВыбранноеЗначение  - Произвольный - результат, возвращенный обработкой подбора КиЗ.
//
Процедура ОбработкаПодбораЗаявкиНаВыпускКиЗ(Форма, ВыбранноеЗначение) Экспорт
	
	ИнтеграцияГИСМ_РТ.ОбработкаПодбораЗаявкиНаВыпускКиЗ(Форма, ВыбранноеЗначение);
	
КонецПроцедуры

// Дополняет условное оформление формы документа "Заявка на выпуск КиЗ".
//
// Параметры:
//  Форма              - УправляемаяФорма - форма, из которой был вызван подбор.
//
Процедура ДополнитьУсловноеОформлениеЗаявкаНаВыпускКиЗ(Форма) Экспорт
	
	ИнтеграцияГИСМ_РТ.ДополнитьУсловноеОформлениеЗаявкаНаВыпускКиЗ(Форма);
	
КонецПроцедуры

// Дополняет условное оформление формы документа "Уведомление об импорте".
//
// Параметры:
//  Форма              - УправляемаяФорма - форма, из которой был вызван подбор.
//
Процедура ДополнитьУсловноеОформлениеУведомлениеОбИмпорте(Форма) Экспорт
	
	ИнтеграцияГИСМ_РТ.ДополнитьУсловноеОформлениеУведомлениеОбИмпорте(Форма);
	
КонецПроцедуры

// Предоставляет возможность заполнить служебные реквизиты в ТЧ документа "Заявка на выпуск КиЗ" 
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа "Заявка на выпуск КиЗ"
//
Процедура ЗаполнитьСлужебныеРеквизитыТабличнойЧастиЗаявкиНаВыпускКиЗ(Форма) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧастиЗаявкиНаВыпускКиЗ(Форма);
	
КонецПроцедуры

// Предоставляет возможность заполнить служебные реквизиты в ТЧ документа "Уведомление об импорте маркированных товаров"
//
// Параметры:
//  Форма - ТабличнаяЧасть - ТЧ "Товары "документа "Уведомление об импорте маркированных товаров".
//
Процедура ЗаполнитьСлужебныеРеквизитыТабличнойЧастиУведомлениеОбИмпорте(Товары) Экспорт
	
	ИнтеграцияГИСМ_РТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧастиУведомлениеОбИмпорте(Товары);
	
КонецПроцедуры

#КонецОбласти

#Область Панель1СМаркировка

// Проверяет наличие права чтения на документ и функциональную опцию использования,
// которым отражается факт розничных продаж.
//
// Возвращаемое значение:
//   Булево   - Истина, если право есть, Ложь в обратном случае.
//
Функция ДоступенОтчетОРозничныхПродажах() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ДоступенОтчетОРозничныхПродажах();
	
КонецФункции

// Проверяет наличие права чтения на документ и функциональную опцию использования,
// которыми отражается факт возврата от розничного покупателя.
//
// Возвращаемое значение:
//   Булево   - Истина, если право есть, Ложь в обратном случае.
//
Функция ДоступенВозвратТоваровОтРозничногоКлиента() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ДоступенВозвратТоваровОтРозничногоКлиента();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт розничных продаж,
// требующих дальнейшего действия или ожидания для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаОтчетыОРозничныхПродажах() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаОтчетыОРозничныхПродажах();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт розничных продаж,
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаОтчетыОРозничныхПродажахОтработайте() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаОтчетыОРозничныхПродажахОтработайте();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт розничных продаж,
// требующих ожидания для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаОтчетыОРозничныхПродажахОжидайте() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаОтчетыОРозничныхПродажахОжидайте();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт возврата от розничного покупателя,
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаВозвратыТоваровОтРозничныхКлиентов() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаВозвратыТоваровОтРозничныхКлиентов();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт возврата от розничного покупателя,
// требующих дальнейшего действия или ожидания для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОтработайте() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОтработайте();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт возврата от розничного покупателя,
// требующих ожидания для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОжидайте() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОжидайте();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление о списании КиЗ",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОСписанииКиЗГИСМ() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОСписанииКиЗГИСМ();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление о списании КиЗ",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОСписанииКиЗГИСМОформите() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОСписанииКиЗГИСМОформите();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление о отгрузке маркированных товаров",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОбОтгрузке() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОбОтгрузке();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление о отгрузке маркированных товаров",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОбОтгрузкеОформите() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОбОтгрузкеОформите();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Заявка на выпуск КиЗ",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаЗаявкиНаВыпускКиЗГИСМ()  Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаЗаявкиНаВыпускКиЗГИСМ();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Заявка на выпуск КиЗ",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаЗаявкиНаВыпускКиЗГИСМОформите()  Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаЗаявкиНаВыпускКиЗГИСМОформите();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление о ввозе маркированных товаров из ЕАЭС",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОВвозеИзЕАЭС() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОВвозеИзЕАЭС();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление о ввозе маркированных товаров из ЕАЭС",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОВвозеИзЕАЭСОформите() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОВвозеИзЕАЭСОформите();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление об импорте маркированных товаров",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОбИмпорте() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОбИмпорте();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов "Уведомление об импорте маркированных товаров",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаУведомленияОбИмпортеОформите() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаУведомленияОбИмпортеОформите();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов ожидающих отправки "Отчеты о розничных продажах",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаКоличествоОтчетовОРозничныхПродажахОжидающиеОтправки() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаКоличествоОтчетовОРозничныхПродажахОжидающиеОтправки();
	
КонецФункции

// Формирует текст запроса, вычисляющий количество документов ожидающих отправки "Возвраты товаров от клиентов",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Возвращаемое значение:
//   Строка   - текст запроса.
//
Функция ТекстЗапросаКоличествоВозвратовОтРозничныхКлиентовОжидающиеОтправки() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаКоличествоВозвратовОтРозничныхКлиентовОжидающиеОтправки();
	
КонецФункции

#КонецОбласти

#Область ЗапросыДинамическихСписковРаспоряжений

// Формирует текст запроса для динамического списка распоряжений уведомлений об импорте.
//
// Возвращаемое значение:
//   Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Функция ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбИмпорте() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбИмпорте();
	
КонецФункции

// Формирует текст запроса для динамического списка распоряжений уведомлений о ввозе из ЕАЭС.
//
// Возвращаемое значение:
//   Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Функция ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОВвозеИзЕАЭС() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОВвозеИзЕАЭС();
	
КонецФункции

// Формирует текст запроса для динамического списка распоряжений уведомлений о списании.
//
// Возвращаемое значение:
//   Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Функция ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОСписании() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОСписании();
	
КонецФункции

// Формирует текст запроса для динамического списка распоряжений уведомлений об отгрузке.
//
// Возвращаемое значение:
//   Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Функция ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбОтгрузке() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбОтгрузке();
	
КонецФункции

// Формирует текст запроса для динамического списка заявок на выпуск КиЗ.
//
// Возвращаемое значение:
//   Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Функция ТекстЗапросаДинамическогоСпискаРаспоряженийЗаявкаНаВыпускКиЗ() Экспорт
	
	Возврат ИнтеграцияГИСМ_РТ.ТекстЗапросаДинамическогоСпискаРаспоряженийЗаявкаНаВыпускКиЗ();
	
КонецФункции

#КонецОбласти

#КонецОбласти
