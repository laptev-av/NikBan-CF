﻿#Область ПрограммныйИнтерфейс

// Определяет префикс кодов и номеров объектов информационной базы по умолчанию.
//
// Параметры:
//	Префикс - Строка, 2 - префикс кодов и номеров объектов информационной базы по умолчанию.
//
Процедура ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию(Префикс) Экспорт
	
	Префикс = "";
	Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		Префикс = НСтр("ru = 'РТ'");
	КонецЕсли;
	
КонецПроцедуры

// Определяет список планов обмена, которые используют функционал подсистемы обмена данными.
//
// Параметры:
//  ПланыОбменаПодсистемы - Массив - Массив планов обмена конфигурации,
//   которые используют функционал подсистемы обмена данными.
//   Элементами массива являются объекты метаданных планов обмена.
//
// Пример:
//   ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменБезИспользованияПравилКонвертации);
//   ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменСБиблиотекойСтандартныхПодсистем);
//   ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.РаспределеннаяИнформационнаяБаза);
//
Процедура ПолучитьПланыОбмена(ПланыОбменаПодсистемы) Экспорт
	
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаБухгалтерияПредприятия);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаБухгалтерияПредприятия30);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменУправлениеТорговлейРозница);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаУправлениеТорговлей103);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаУправлениеПредприятием);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаОтчетностьПредпринимателя);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаУправлениеНебольшойФирмой);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ПоМагазину);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ПоРабочемуМесту);
	ОбменДаннымиXDTOПереопределяемый.СписокПлановОбменаXDTO(ПланыОбменаПодсистемы);
	
КонецПроцедуры

// Обработчик при выгрузке данных.
// Используется для переопределения стандартной обработки выгрузки данных.
// В данном обработчике должна быть реализована логика выгрузки данных:
// выборка данных для выгрузки, сериализация данных в файл сообщения или сериализация данных в поток.
// После выполнения обработчика выгруженные данные будут отправлены получателю подсистемой обмена данными.
// Формат сообщения для выгрузки может быть произвольным.
// В случае ошибок при отправке данных следует прерывать выполнение обработчика
// методом ВызватьИсключение с описанием ошибки.
//
// Параметры:
//
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//   Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная
//   обработка события производиться не будет. Отказ от стандартной обработки не отменяет действие.
//   Значение по умолчанию - Истина.
//
//  Получатель - ПланОбменаСсылка - Узел плана обмена, для которого выполняется выгрузка данных.
//
//  ИмяФайлаСообщения - Строка - Имя файла, в который необходимо выполнить выгрузку данных.
//   Если этот параметр заполнен, то система ожидает,
//   что данные будут выгружены в файл. После выгрузки система выполнит отправку данных из этого файла.
//   Если параметр пустой, то система ожидает, что данные будут выгружены в параметр ДанныеСообщения.
//
//  ДанныеСообщения - Произвольный - Если параметр ИмяФайлаСообщения пустой,
//   то система ожидает, что данные будут выгружены в этот параметр.
//
//  КоличествоЭлементовВТранзакции - Число - Определяет максимальное число элементов данных,
//   которые помещаются в сообщение в рамках одной транзакции базы данных.
//   При необходимости в обработчике следует реализовать логику
//   установки транзакционных блокировок на выгружаемые данные.
//   Значение параметра задается в настройках подсистемы обмена данными.
//
//  ИмяСобытияЖурналаРегистрации - Строка - Имя события журнала регистрации текущего сеанса обмена данными.
//   Используется для записи в журнал регистрации данных (ошибок, предупреждений, информации) с заданным именем события.
//   Соответствует параметру ИмяСобытия метода глобального контекста ЗаписьЖурналаРегистрации.
//
//  КоличествоОтправленныхОбъектов - Число - Счетчик отправленных объектов.
//   Используется для определения количества отправленных объектов
//   для последующей фиксации в протоколе обмена.
//
Процедура ПриВыгрузкеДанных(СтандартнаяОбработка,
								Получатель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоОтправленныхОбъектов) Экспорт
	
КонецПроцедуры

// Обработчик при загрузке данных.
// Используется для переопределения стандартной обработки загрузки данных.
// В данном обработчике должна быть реализована логика загрузки данных:
// необходимые проверки перед загрузкой данных, сериализация данных из файла сообщения или сериализация данных из
// потока.
// Формат сообщения для загрузки может быть произвольным.
// В случае ошибок при получении данных следует прерывать выполнение обработчика
// методом ВызватьИсключение с описанием ошибки.
//
// Параметры:
//
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения
//   стандартной (системной) обработки события.
//   Если в теле процедуры-обработчика установить данному параметру значение Ложь,
//   стандартная обработка события производиться не будет.
//   Отказ от стандартной обработки не отменяет действие.
//   Значение по умолчанию: Истина.
//
//  Отправитель - ПланОбменаСсылка - Узел плана обмена, для которого выполняется загрузка данных.
//
//  ИмяФайлаСообщения - Строка - Имя файла, из которого требуется выполнить загрузку данных.
//   Если параметр не заполнен, то данные для загрузки передаются через параметр ДанныеСообщения.
//
//  ДанныеСообщения - Произвольный - Параметр содержит данные, которые необходимо загрузить.
//   Если параметр ИмяФайлаСообщения пустой,
//   то данные для загрузки передаются через этот параметр.
//
//  КоличествоЭлементовВТранзакции - Число - Определяет максимальное число элементов данных,
//   которые читаются из сообщения и записываются в базу данных в рамках одной транзакции.
//   При необходимости в обработчике следует реализовать логику записи данных в транзакции.
//   Значение параметра задается в настройках подсистемы обмена данными.
//
//  ИмяСобытияЖурналаРегистрации - Строка - Имя события журнала регистрации текущего сеанса обмена данными.
//   Используется для записи в журнал регистрации данных (ошибок, предупреждений, информации) с заданным именем события.
//   Соответствует параметру ИмяСобытия метода глобального контекста ЗаписьЖурналаРегистрации.
//
//  КоличествоПолученныхОбъектов - Число -Счетчик полученных объектов.
//   Используется для определения количества загруженных объектов
//   для последующей фиксации в протоколе обмена.
//
Процедура ПриЗагрузкеДанных(СтандартнаяОбработка,
								Отправитель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоПолученныхОбъектов) Экспорт
	
КонецПроцедуры

// Обработчик регистрации изменений для начальной выгрузки данных.
// Используется для переопределения стандартной обработки регистрации изменений.
// При стандартной обработке будут зарегистрированы изменения всех данных из состава плана обмена.
// Если для плана обмена предусмотрены фильтры ограничения миграции данных,
// то использование этого обработчика позволит повысить производительность начальной выгрузки данных.
// В обработчике следует реализовать регистрацию изменений с учетом фильтров ограничения миграции данных.
// Если для плана обмена используются ограничения миграции по дате или по дате и организациям,
// то можно воспользоваться универсальной процедурой
// ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям.
// Обработчик используется только для универсального обмена данными с использованием правил обмена
// и для универсального обмена данными без правил обмена и не используется для обменов в РИБ.
// Использование обработчика позволяет повысить производительность
// начальной выгрузки данных в среднем в 2-4 раза.
//
// Параметры:
//
//  Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
//
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//   Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события
//   производиться не будет.
//   Отказ от стандартной обработки не отменяет действие.
//   Значение по умолчанию - Истина.
//
//  Отбор - Массив или ОбъектМетаданных - определяет отбор по объектам метаданных, для которых следует выполнить
//                                       регистрацию изменений.
//
Процедура РегистрацияИзмененийНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	
	
КонецПроцедуры

// Обработчик при коллизии изменений данных.
// Событие возникает при получении данных, если в текущей информационной базе изменен тот же объект,
// что получен из сообщения обмена и эти объекты различаются.
// Используется для переопределения стандартной обработки коллизий изменений данных.
// Стандартная обработка коллизий предполагает получение изменений от главного узла
// и игнорирование изменений, полученных от подчиненного узла.
// В данном обработчике должен быть переопределен параметр ПолучениеЭлемента,
// если требуется изменить поведение по умолчанию.
// В данном обработчике можно задать поведение системы при возникновении коллизии изменений данных в разрезе данных,
// в разрезе свойств данных, в разрезе отправителей или для всей информационной базы в целом, или для всех данных в
// целом.
// Обработчик вызывается как в обмене в распределенной информационной базе (РИБ),
// так и во всех остальных обменах, в том числе в обменах по правилам обмена.
//
// Параметры:
//  ЭлементДанных - Произвольный - элемент данных, прочитанный из сообщения обмена данными.
//                  Элементами данных могут быть КонстантаМенеджерЗначения.<Имя константы>,
//                  объекты базы данных (кроме объекта "Удаление объекта"), наборы записей регистров,
//                  последовательностей или перерасчетов.
//
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - Определяет, будет ли прочитанный элемент данных записан в базу данных
//                                               или нет в случае коллизии.
//   При вызове обработчика параметр имеет значение Авто, что означает действия по умолчанию
//   (принимать от главного, игнорировать от подчиненного).
//   Значение данного параметра может быть переопределено в обработчике.
//
//  Отправитель - ПланОбменаСсылка - Узел плана обмена, от имени которого выполняется получение данных.
//
//  ПолучениеОтГлавного - Булево -  В распределенной информационной базе обозначает признак получения данных от главного
//                                узла.
//   Истина - выполняется получение данных от главного узла, Ложь - от подчиненного.
//   В обменах по правилам обмена принимает значение Истина - если в правилах обмена приоритет объекта
//   при коллизии установлен в значение "Выше" (значение по умолчанию) или не указан;
//   Ложь - если в правилах обмена приоритет объекта при коллизии установлен в значение "Ниже" или "Совпадает".
//   Во всех остальных типах обмена данными параметр принимает значение Истина.
//
Процедура ПриКоллизииИзмененийДанных(Знач ЭлементДанных, ПолучениеЭлемента, Знач Отправитель, Знач ПолучениеОтГлавного) Экспорт
	
	
	
КонецПроцедуры

// Обработчик начальной настройки ИБ после создания узла РИБ.
// Вызывается в момент первого запуска подчиненного узла РИБ (в том числе АРМ).
Процедура ПриНастройкеПодчиненногоУзлаРИБ() Экспорт
	
КонецПроцедуры

// Получает доступные для использования версии универсального формата EnterpriseData.
//
// Параметры:
//   ВерсииФормата - Соответствие - Соответствие номера версии формата,
//                   общему модулю, в котором находятся обработчики выгрузки/загрузки для данной версии.
//
// Пример:
//   ВерсииФормата.Вставить("1.2", <ИмяОбщегоМодуляСПравиламиКонвертации>);
//
Процедура ПриПолученииДоступныхВерсийФормата(ВерсииФормата) Экспорт
	
	ВерсииФормата.Вставить("1.2", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.3", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.4", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.5", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.6", МенеджерОбменаЧерезУниверсальныйФормат);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейсРТ

// Обработчик вызывается перед записью объекта при загрузке данных в универсальном обмене данными
//
Процедура ПередЗаписьюОбъекта(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Обработчик механизма регистрации объектов "После определения получателей".
// Событие возникает в транзакции записи данных в ИБ, когда определены 
// получатели изменений данных по правилам регистрации объектов.
//
// Параметры:
// Данные. Записываемый объект, представляющий данные - документ, элемент справочника,
// счет бухгалтерского учета, менеджер записи константы, набор записей регистра и т. п.
//
// Получатели. Тип: Массив. Массив узлов планов обмена на которых будут зарегистрированы изменения текущих данных.
//
// ИмяПланаОбмена. Тип: Строка. Имя плана обмена, как объекта метаданных,
// для которого выполняются правила регистрации объектов.
//
Процедура ПослеОпределенияПолучателей(Данные, Получатели, Знач ИмяПланаОбмена) Экспорт
	
КонецПроцедуры

// Заполнение табличных частей документа ВводНачальныхОстатковУзла по остаткам регистров.
//
Процедура ЗаполнитьОстатки(МассивМагазинов = Неопределено, СтруктураЗаполненияВводаОстатков, ВводОстатков = Неопределено, Отказ) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивМагазинов", ?(МассивМагазинов = Неопределено, СтруктураЗаполненияВводаОстатков.Узел.Магазины.ВыгрузитьКолонку("Магазин"), МассивМагазинов));

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПравилаЦенообразованияЦеновыеГруппы.ВидЦен.Ссылка 	КАК ВидЦены,
	|	Номенклатура.Ссылка 								КАК Номенклатура
	|ПОМЕСТИТЬ ВременнаяТаблицаВидовЦен
	|ИЗ
	|	Справочник.Магазины КАК Магазины
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаЦенообразования.ЦеновыеГруппы КАК ПравилаЦенообразованияЦеновыеГруппы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|			ПО (Номенклатура.ЦеноваяГруппа = ПравилаЦенообразованияЦеновыеГруппы.ЦеноваяГруппа)
	|		ПО (Магазины.ПравилоЦенообразования = ПравилаЦенообразованияЦеновыеГруппы.Ссылка)
	|ГДЕ
	|	Магазины.Ссылка В(&МассивМагазинов)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Магазины.ПравилоЦенообразования.ВидЦен,
	|	NULL
	|ИЗ
	|	Справочник.Магазины КАК Магазины
	|ГДЕ
	|	Магазины.Ссылка В(&МассивМагазинов)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПравилаЦенообразованияДополнительныеВидыЦен.ВидЦен,
	|	NULL
	|ИЗ
	|	Справочник.Магазины КАК Магазины
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаЦенообразования.ДополнительныеВидыЦен КАК ПравилаЦенообразованияДополнительныеВидыЦен
	|		ПО Магазины.ПравилоЦенообразования = ПравилаЦенообразованияДополнительныеВидыЦен.Ссылка
	|ГДЕ
	|	Магазины.Ссылка В(&МассивМагазинов)";
	
	Запрос.Выполнить();
	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	// 0 - Товары на складах
	|	ТоварыНаСкладахОстатки.Склад,
	|	ТоварыНаСкладахОстатки.Номенклатура,
	|	ТоварыНаСкладахОстатки.Характеристика,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаДокумента, Склад.Магазин В (&МассивМагазинов)) КАК ТоварыНаСкладахОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 1 - Товары организаций
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТоварыОрганизацийОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыОрганизацийОстатки.Характеристика КАК Характеристика,
	|	ТоварыОрганизацийОстатки.Склад КАК Склад,
	|	ТоварыОрганизацийОстатки.Организация КАК Организация,
	|	ТоварыОрганизацийОстатки.Поставщик КАК Контрагент,
	|	ТоварыОрганизацийОстатки.Договор КАК Договор,
	|	ТоварыОрганизацийОстатки.НомерГТД КАК НомерГТД, 
	|	ТоварыОрганизацийОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(&ДатаДокумента, Склад.Магазин В (&МассивМагазинов)) КАК ТоварыОрганизацийОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 2 - Денежные средства наличные.
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДенежныеСредстваНаличныеОстатки.Организация,
	|	ДенежныеСредстваНаличныеОстатки.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	ДенежныеСредстваНаличныеОстатки.Касса,
	|	ДенежныеСредстваНаличныеОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(&ДатаДокумента, Касса.Магазин В (&МассивМагазинов)) КАК ДенежныеСредстваНаличныеОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 3 - Денежные средства ККМ
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДенежныеСредстваККМОстатки.КассаККМ КАК КассаККМ,
	|	ДенежныеСредстваККМОстатки.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	ДенежныеСредстваККМОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваККМ.Остатки(&ДатаДокумента, КассаККМ.Магазин В (&МассивМагазинов)) КАК ДенежныеСредстваККМОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 4 - Действующие цены номенклатуры.
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДействующиеЦеныНоменклатурыСрезПоследних.ОбъектЦенообразования КАК Магазин,
	|	ДействующиеЦеныНоменклатурыСрезПоследних.Номенклатура,
	|	ДействующиеЦеныНоменклатурыСрезПоследних.Характеристика,
	|	ДействующиеЦеныНоменклатурыСрезПоследних.Цена,
	|	ДействующиеЦеныНоменклатурыСрезПоследних.Упаковка
	|ИЗ
	|	РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(&ДатаДокумента, ОбъектЦенообразования В (&МассивМагазинов)) КАК ДействующиеЦеныНоменклатурыСрезПоследних
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	// 5 - Цены номенклатуры
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЦеныНоменклатурыСрезПоследних.ВидЦены 			КАК ВидЦены,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура 		КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Характеристика 	КАК Характеристика,
	|	ЦеныНоменклатурыСрезПоследних.Цена 				КАК Цена,
	|	ЦеныНоменклатурыСрезПоследних.Упаковка 			КАК Упаковка
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаДокумента) КАК ЦеныНоменклатурыСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВидовЦен КАК ВременнаяТаблицаВидовЦен
	|		ПО (ЦеныНоменклатурыСрезПоследних.ВидЦены = ВременнаяТаблицаВидовЦен.ВидЦены
	|					И ЦеныНоменклатурыСрезПоследних.Номенклатура = ВременнаяТаблицаВидовЦен.Номенклатура
	|				ИЛИ ВЫБОР
	|					КОГДА ЦеныНоменклатурыСрезПоследних.ВидЦены = ВременнаяТаблицаВидовЦен.ВидЦены
	|							И ВременнаяТаблицаВидовЦен.Номенклатура ЕСТЬ NULL
	|						ТОГДА ИСТИНА
	|				КОНЕЦ)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	// 6 - Себестоимость номенклатуры.
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СебестоимостьНоменклатурыСрезПоследних.Магазин,
	|	СебестоимостьНоменклатурыСрезПоследних.Номенклатура,
	|	СебестоимостьНоменклатурыСрезПоследних.Характеристика,
	|	СебестоимостьНоменклатурыСрезПоследних.Цена
	|ИЗ
	|	РегистрСведений.СебестоимостьНоменклатуры.СрезПоследних(
	|			&ДатаДокумента,
	|			Магазин В (&МассивМагазинов)
	|				ИЛИ Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)) КАК СебестоимостьНоменклатурыСрезПоследних
	|;
	|////////////////////////////////////////////////////////////////////////////////
	// 7 - Товары к поступлению
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТоварыКПоступлениюОстатки.Номенклатура,
	|	ТоварыКПоступлениюОстатки.Характеристика,
	|	ТоварыКПоступлениюОстатки.Склад,
	|	ТоварыКПоступлениюОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			&ДатаДокумента,
	|			Склад.Магазин В (&МассивМагазинов)) КАК ТоварыКПоступлениюОстатки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	// 8 - Товары к отгрузке
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТоварыКОтгрузкеОстатки.Номенклатура,
	|	ТоварыКОтгрузкеОстатки.Характеристика,
	|	ТоварыКОтгрузкеОстатки.Склад,
	|	ТоварыКОтгрузкеОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке.Остатки(
	|			&ДатаДокумента,
	|			Склад.Магазин В (&МассивМагазинов)) КАК ТоварыКОтгрузкеОстатки";
	
	Запрос.УстановитьПараметр("МассивМагазинов", ?(МассивМагазинов = Неопределено, СтруктураЗаполненияВводаОстатков.Узел.Магазины.ВыгрузитьКолонку("Магазин"), МассивМагазинов));
	ДатаДокумента = Новый Граница(СтруктураЗаполненияВводаОстатков.Дата,ВидГраницы.Включая);
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если ВводОстатков = Неопределено ИЛИ ВводОстатков.Пустая() Тогда
		ОбъектВводОстатков = Документы.ВводНачальныхОстатковУзла.СоздатьДокумент();	
	Иначе
		ОбъектВводОстатков = ВводОстатков.ПолучитьОбъект();
	КонецЕсли;
	ОбъектВводОстатков.Дата          	= СтруктураЗаполненияВводаОстатков.Дата;
	ОбъектВводОстатков.КодУзлаОбмена 	= СтруктураЗаполненияВводаОстатков.КодУзлаОбмена;
	ОбъектВводОстатков.Узел          	= СтруктураЗаполненияВводаОстатков.Узел;
	ОбъектВводОстатков.Комментарий      = СтруктураЗаполненияВводаОстатков.Комментарий;
	ОбъектВводОстатков.ПометкаУдаления  = СтруктураЗаполненияВводаОстатков.ПометкаУдаления;

	
	ТабличныеЧастиДокумента = ОбъектВводОстатков.Метаданные().ТабличныеЧасти;
	СоответствиеРезультатовЗапросаТабличнымЧастям = Новый Соответствие;
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ТоварыНаСкладах.Имя, 0);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ТоварыОрганизаций.Имя, 1);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ДенежныеСредстваНаличные.Имя, 2);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ДенежныеСредстваККМ.Имя, 3);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ДействующиеЦеныНоменклатуры.Имя, 4);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ЦеныНоменклатуры.Имя, 5);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.СебестоимостьНоменклатуры.Имя, 6);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ТоварыКПоступлению.Имя, 7);
	СоответствиеРезультатовЗапросаТабличнымЧастям.Вставить(ТабличныеЧастиДокумента.ТоварыКОтгрузке.Имя, 8);	

	Для каждого ЭлементСоответствия Из СоответствиеРезультатовЗапросаТабличнымЧастям Цикл
		ОбъектВводОстатков[ЭлементСоответствия.Ключ].Очистить();
		Если РезультатЗапроса[ЭлементСоответствия.Значение].Пустой() Тогда
			Продолжить;
		КонецЕсли; 	
		ВыборкаРезультатаЗапроса = РезультатЗапроса[ЭлементСоответствия.Значение].Выбрать();
		Если ВыборкаРезультатаЗапроса.Количество() <= 99999 Тогда
			ОбъектВводОстатков[ЭлементСоответствия.Ключ].Загрузить(РезультатЗапроса[ЭлементСоответствия.Значение].Выгрузить());
		Иначе
			Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
				Если ОбъектВводОстатков[ЭлементСоответствия.Ключ].Количество() < 99999 Тогда
					НоваяСтрокаТабличнойЧасти = ОбъектВводОстатков[ЭлементСоответствия.Ключ].Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, ВыборкаРезультатаЗапроса);
				Иначе
					Если НЕ ЗаписатьВводОстатков(ОбъектВводОстатков, РежимЗаписиДокумента.Запись) Тогда
						Отказ = Истина;
					КонецЕсли;
					
					ВыборкаДокументов = Документы.ВводНачальныхОстатковУзла.Выбрать(,, Новый Структура("КодУзлаОбмена", СтруктураЗаполненияВводаОстатков.КодУзлаОбмена), "Дата");
					Пока ВыборкаДокументов.Следующий() Цикл
						ДокументВыборки = ВыборкаДокументов.ПолучитьОбъект();
						
						Если Не ДокументВыборки.ПометкаУдаления И ДокументВыборки[ЭлементСоответствия.Ключ].Количество() = 0 Тогда
							НовыйОбъектВводОстатков = ДокументВыборки;
							Прервать;
						ИначеЕсли ДокументВыборки.ПометкаУдаления Тогда 
							НовыйОбъектВводОстатков = ДокументВыборки;
							НовыйОбъектВводОстатков.ПометкаУдаления = Ложь;
							Для Каждого ТаблЧасть Из НовыйОбъектВводОстатков.Метаданные().ТабличныеЧасти Цикл
								НовыйОбъектВводОстатков[ТаблЧасть.Имя].Очистить();
							КонецЦикла;
							Прервать;

						КонецЕсли;
					КонецЦикла;
					Если НовыйОбъектВводОстатков = Неопределено Тогда
						НовыйОбъектВводОстатков = Документы.ВводНачальныхОстатковУзла.СоздатьДокумент();
					КонецЕсли; 
					НовыйОбъектВводОстатков.Дата          = ОбъектВводОстатков.Дата;
					НовыйОбъектВводОстатков.КодУзлаОбмена = ОбъектВводОстатков.КодУзлаОбмена;
					НовыйОбъектВводОстатков.Узел          = ОбъектВводОстатков.Узел;
					НоваяСтрокаТабличнойЧасти = НовыйОбъектВводОстатков[ЭлементСоответствия.Ключ].Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, ВыборкаРезультатаЗапроса);
					ОбъектВводОстатков = НовыйОбъектВводОстатков;
					НовыйОбъектВводОстатков = Неопределено;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ЗаписатьВводОстатков(ОбъектВводОстатков, РежимЗаписиДокумента.Запись) Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ОбъектВводОстатков.Пустой() Тогда
		ТекстОшибки = НСтр("ru = 'Отсутствуют остатки на дату начала выгрузки документов. 
		|Документ ""Начальные остатки узла"" не будет сформирован.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	Если НЕ ЗаписатьВводОстатков(ОбъектВводОстатков, РежимЗаписиДокумента.Запись) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

//Функция записи документа ВводНачальныхОстатковУзла
//
Функция ЗаписатьВводОстатков(ОбъектВводОстатков, РежимЗаписи) Экспорт

	ВыполненоУспешно = Истина;
	
	Попытка
					
		ОбъектВводОстатков.Записать(РежимЗаписи);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными.Проведение документа ""Ввод начальных остатков узла""'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Информация);
				
	Исключение
		
		Инфо = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными.Проведение документа ""Ввод начальных остатков узла""'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,Инфо);
		ВыполненоУспешно = Ложь;
	
	КонецПопытки;

	Возврат ВыполненоУспешно;
	
КонецФункции

#КонецОбласти
