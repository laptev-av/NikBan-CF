﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииБсп

#Область НастройкиПоУмолчанию

// Возвращает строковое представление варианта синхронизации документов,
// в зависимости от установленного режима выгрузки документов; 
//
// Возвращаемое значение:
//  Строка, неограниченной длины - строковое представление варианта выгрузки документов.
//
Функция ОпределитьВариантСинхронизацииДокументов(РежимВыгрузкиДокументов) Экспорт
	
	ВариантСинхронизацииДокументов = "";
	
	Если РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		ВариантСинхронизацииДокументов = "АвтоматическаяСинхронизация"
	ИначеЕсли РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		ВариантСинхронизацииДокументов = "ИнтерактивнаяСинхронизация"
	ИначеЕсли РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		ВариантСинхронизацииДокументов = "НеСинхронизировать"
	КонецЕсли;
	
	Возврат ВариантСинхронизацииДокументов;
	
КонецФункции

// Возвращает строковое представление варианта синхронизации справочников,
// в зависимости от установленного режима выгрузки справочников; 
//
// Возвращаемое значение:
//  Строка, неограниченной длины - строковое представление варианта выгрузки справочников.
//
Функция ОпределитьВариантСинхронизацииСправочников(РежимВыгрузкиСправочников) Экспорт
	
	ВариантСинхронизацииСправочников = "";
	
	Если РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		ВариантСинхронизацииСправочников = "АвтоматическаяСинхронизация";
	ИначеЕсли РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости Тогда
		ВариантСинхронизацииСправочников = "СинхронизироватьПоНеобходимости";
	ИначеЕсли РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		ВариантСинхронизацииСправочников = "НеСинхронизировать";
	КонецЕсли;
	
	Возврат ВариантСинхронизацииСправочников;
	
КонецФункции

#КонецОбласти

#Область ПереопределяемаяНастройкаДополненияВыгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху
//                                                            вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Строка            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Строка            - Заголовок для отрисовки на форме команды открытия формы
//                                                            настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По
//                                                            умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по
//                                                            умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                            узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно
//                                                               использовать специальные  значения "ВсеДокументы" и
//                                                               "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки,
//                                                               предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в
//                                                               соответствии с общим правилами формирования полей
//                                                               компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле
//                                                               "Ссылка.Организация".
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	Если Получатель.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать 
		И Получатель.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		Параметры.ВариантБезДополнения.Использование     = Ложь;
		Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
		Параметры.ВариантДополнительно.Использование     = Ложь;
		
	Иначе
		
		// Отключаем вариант "ВариантВсеДокументы".
		
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		
		// Настраиваем вариант "Без дополнения".
		Параметры.ВариантБезДополнения.Использование = Истина;
		Параметры.ВариантБезДополнения.Порядок       = 3;
		Параметры.ВариантБезДополнения.Заголовок     = НСтр("ru = 'Не добавлять документы к отправке'") 
			+ Символы.ПС 
			+ "Отправлять только нормативно-справочную информацию, измененную с момента последней отправки.";
		
		// Настраиваем вариант "Произвольный отбор".
		Параметры.ВариантПроизвольныйОтбор.Использование = Истина;
		Параметры.ВариантПроизвольныйОтбор.Порядок       = 2;
		
		Если Получатель.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
			Параметры.ВариантПроизвольныйОтбор.Заголовок = НСтр("ru = 'Добавить справочники'");
		Иначе
			Параметры.ВариантПроизвольныйОтбор.Заголовок = НСтр("ru = 'Добавить произвольные справочники и документы'");
		КонецЕсли;
		
		Если Не Получатель.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
			// Вычисляем и устанавливаем параметры сценария.
			ПараметрыПоУмолчанию = ПараметрыВыгрузкиПоУмолчанию(Получатель);
			
			// Настраиваем вариант "Дополнительно" по сценарию узла.
			Параметры.ВариантДополнительно.Использование            = Истина;
			Параметры.ВариантДополнительно.Порядок                  = 1;
			Параметры.ВариантДополнительно.Заголовок                = НСтр("ru='Отправить все документы'");
			Параметры.ВариантДополнительно.ИмяФормыОтбора           = "ОбщаяФорма.НастройкаВыгрузки";
			Параметры.ВариантДополнительно.ЗаголовокКомандыФормы    = НСтр("ru='Выбрать организации для отбора'");
			Параметры.ВариантДополнительно.ИспользоватьПериодОтбора = Истина;
			Параметры.ВариантДополнительно.ПериодОтбора             = ПараметрыПоУмолчанию.Период;
			
			// Добавляем строка настройки отбора.
			СтрокаОтбора = Параметры.ВариантДополнительно.Отбор.Добавить();
			СтрокаОтбора.ПолноеИмяМетаданных = "ВсеДокументы";
			СтрокаОтбора.ВыборПериода = Истина;
			СтрокаОтбора.Период       = ПараметрыПоУмолчанию.Период;
			СтрокаОтбора.Отбор        = ПараметрыПоУмолчанию.Отбор;
		Иначе
			Параметры.ВариантДополнительно.Использование            = Ложь;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку".
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора.
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                        узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут
//                                                               быть использованы специальные  значения "ВсеДокументы"
//                                                               и "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с
//                                                               общим правилами формирования полей компоновки.
//                                                               Например, для указания отбора по реквизиту документа
//                                                               "Организация", будет использовано поле
//                                                               "Ссылка.Организация".
//
// Возвращаемое значение: 
//     Строка - описание отбора.
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Если Параметры.ИспользоватьПериодОтбора Тогда
		Если ЗначениеЗаполнено(Параметры.ПериодОтбора) Тогда
			ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='за период: %1'"), НРег(Параметры.ПериодОтбора));
		Иначе
			ДатаНачалаВыгрузки = Получатель.ДатаНачалаВыгрузкиДокументов;
			Если ЗначениеЗаполнено(ДатаНачалаВыгрузки) Тогда
				ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='начиная с даты начала отправки документов: %1'"), Формат(ДатаНачалаВыгрузки, "ДЛФ=DD"));
			Иначе
				ОписаниеПериода = НСтр("ru='за весь период учета'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОписаниеПериода = "";
	КонецЕсли;
	
	СписокОрганизаций = ОрганизацииОтбораИнтерактивнойВыгрузки(Параметры.Отбор);
	
	Если СписокОрганизаций.Количество()=0 Тогда
		ОписаниеОтбораОрганизации = НСтр("ru='по всем организациям'");
	Иначе
		ОписаниеОтбораОрганизации = "";
		Для Каждого Элемент Из СписокОрганизаций Цикл
			ОписаниеОтбораОрганизации = ОписаниеОтбораОрганизации+ ", " + Элемент.Представление;
		КонецЦикла;
		ОписаниеОтбораОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='с отбором по организациям: %1'"), СокрЛП(Сред(ОписаниеОтбораОрганизации, 2)));
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Будут отправлены все документы %1,
		         |%2'"),
		ОписаниеПериода,  ОписаниеОтбораОрганизации);
	
КонецФункции

// Расчет параметров выгрузки по умолчанию.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//
// Возвращаемое значение - Структура - содержит поля:
//     ПредставлениеОтбора - Строка - текстовое описание отбора по умолчанию.
//     Период              - СтандартныйПериод     - значение периода общего отбора по умолчанию.
//     Отбор               - ОтборКомпоновкиДанных - отбор.
//
Функция ПараметрыВыгрузкиПоУмолчанию(Получатель)
	
	Результат = Новый Структура;
	
	// Период по умолчанию
	Результат.Вставить("Период", Новый СтандартныйПериод);
	Результат.Период.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
	
	// Отбор по умолчанию и его представление.
	КомпоновщикОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	Результат.Вставить("Отбор", КомпоновщикОтбора.Настройки.Отбор);
	
	// Общее представление, период не включаем, так как в этом сценарии поле периода будет редактироваться отдельно.
	Результат.Вставить( "ПредставлениеОтбора", 
	                    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	                    НСтр("ru='Будут отправлены все документы за %1'"),
	                    НРег(Строка(Результат.Период.Вариант))));
	
	Возврат Результат;
КонецФункции

// Возвращает список организаций по таблице отбора (см "ПредставлениеОтбораИнтерактивнойВыгрузки").
// Также используется из демонстрационной формы "НастройкаВыгрузки" этого плана обмена.
//
// Параметры:
//     ТаблицаОтбора - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла. Содержит.
//                                         колонки:
//         ПолноеИмяМетаданных - Строка
//         ВыборПериода        - Булево
//         Период              - СтандартныйПериод
//         Отбор               - ОтборКомпоновкиДанных
//
// Возвращаемое значение:
//     СписокЗначений - значение - ссылка на организацию, представление - наименование.
//
Функция ОрганизацииОтбораИнтерактивнойВыгрузки(Знач ТаблицаОтбора) Экспорт
	
	Результат = Новый СписокЗначений;
	
	Если ТаблицаОтбора.Количество()=0 Или ТаблицаОтбора[0].Отбор.Элементы.Количество()=0 Тогда
		// Нет данных отбора
		Возврат Результат;
	КонецЕсли;
		
	// Мы знаем состав отбора, так как помещали туда сами - или из "НастроитьИнтерактивнуюВыгрузку"
	// или как результат редактирования в форме.
	
	СтрокаДанных = ТаблицаОтбора[0].Отбор.Элементы[0];
	Отобранные   = СтрокаДанных.ПравоеЗначение;
	ТипКоллекции = ТипЗнч(Отобранные);
	
	Если ТипКоллекции=Тип("СписокЗначений") Тогда
		Для Каждого Элемент Из Отобранные Цикл
			ДобавитьСписокОрганизаций(Результат, Элемент.Значение);
		КонецЦикла;
		
	ИначеЕсли ТипКоллекции=Тип("Массив") Тогда
		ДобавитьСписокОрганизаций(Результат, Отобранные);
		 
	ИначеЕсли ТипКоллекции=Тип("СправочникСсылка.Организации") Тогда
		Если Результат.НайтиПоЗначению(Отобранные)=Неопределено Тогда
			Результат.Добавить(Отобранные, Отобранные.Наименование);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Добавляет в список организаций коллекцию.
//
// Параметры:
//     Список      - СписокЗначений - дополняемый список.
//     Организации - коллекция организаций.
// 
Процедура ДобавитьСписокОрганизаций(Список, Знач Организации)
	
	Для Каждого Организация Из Организации Цикл
		
		Если ТипЗнч(Организация)=Тип("Массив") Тогда
			ДобавитьСписокОрганизаций(Список, Организация);
			Продолжить;
		КонецЕсли;
		
		Если Список.НайтиПоЗначению(Организация)=Неопределено Тогда
			Список.Добавить(Организация, Организация.Наименование);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПриПолученииНастроек

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//      Настройки - Структура - Содержит настройки по умолчанию.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
Процедура ПриПолученииНастроек(НастройкиПланаОбмена) Экспорт
	
	НастройкиПланаОбмена.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	НастройкиПланаОбмена.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	НастройкиПланаОбмена.ЭтоПланОбменаXDTO = Истина;
	НастройкиПланаОбмена.ФорматОбмена = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData";
	
	ВерсииФормата = Новый Соответствие;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	| СинхронизацияДанныхЧерезУниверсальныйФормат.ПутьКМенеджеруОбмена
	|ИЗ
	| ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат КАК СинхронизацияДанныхЧерезУниверсальныйФормат
	|ГДЕ
	| СинхронизацияДанныхЧерезУниверсальныйФормат.ПутьКМенеджеруОбмена <> """"");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВерсииФормата.Вставить("1.2", ВнешниеОбработки.Создать(Выборка.ПутьКМенеджеруОбмена));
		ВерсииФормата.Вставить("1.3", ВнешниеОбработки.Создать(Выборка.ПутьКМенеджеруОбмена));
		ВерсииФормата.Вставить("1.4", ВнешниеОбработки.Создать(Выборка.ПутьКМенеджеруОбмена));
		ВерсииФормата.Вставить("1.5", ВнешниеОбработки.Создать(Выборка.ПутьКМенеджеруОбмена));
		ВерсииФормата.Вставить("1.6", ВнешниеОбработки.Создать(Выборка.ПутьКМенеджеруОбмена));
	Иначе
		ВерсииФормата.Вставить("1.2", МенеджерОбменаЧерезУниверсальныйФормат);
		ВерсииФормата.Вставить("1.3", МенеджерОбменаЧерезУниверсальныйФормат);
		ВерсииФормата.Вставить("1.4", МенеджерОбменаЧерезУниверсальныйФормат);
		ВерсииФормата.Вставить("1.5", МенеджерОбменаЧерезУниверсальныйФормат);
		ВерсииФормата.Вставить("1.6", МенеджерОбменаЧерезУниверсальныйФормат);
	КонецЕсли;
	НастройкиПланаОбмена.ВерсииФорматаОбмена = ВерсииФормата;
	
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииВариантовНастроекОбмена   				= Истина;
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииОписанияВариантаНастройки 				= Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки = "ТолькоОтправка";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки = "ТолькоПолучение";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки = "Двухсторонний";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "ОбменКасса";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Ложь;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	Если ИдентификаторНастройки = "ТолькоОтправка" Тогда
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Отправка данных'");
		ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена 				= НСтр("ru = 'Отправка данных (настройка)'");
		ОписаниеВарианта.ЗаголовокУзлаПланаОбмена                       = НСтр("ru = 'Отправка данных'");
	ИначеЕсли ИдентификаторНастройки = "ТолькоПолучение" Тогда
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Получение данных'");
		ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена               = НСтр("ru = 'Получение данных (настройка)'");
		ОписаниеВарианта.ЗаголовокУзлаПланаОбмена                       = НСтр("ru = 'Получение данных'");
	ИначеЕсли ИдентификаторНастройки = "Двухсторонний" Тогда
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Полная синхронизация'");
		ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена               = НСтр("ru = 'Синхронизация данных (настройка)'");
		ОписаниеВарианта.ЗаголовокУзлаПланаОбмена                       = НСтр("ru = 'Синхронизация данных'");
	ИначеЕсли ИдентификаторНастройки = "ОбменКасса" Тогда

		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = '1С:Касса'");
		ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена =               НСтр("ru = 'Настройка синхронизации с программой ""1С:Касса""'");
		ОписаниеВарианта.ЗаголовокУзлаПланаОбмена =                       НСтр("ru = 'Синхронизация с программой ""1С:Касса""'");
		ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента =         НСтр("ru = '1С:Касса'");
	Иначе
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Другая программа'");
		ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена =               НСтр("ru = 'Настройка синхронизации данных через универсальный формат'");
		ОписаниеВарианта.ЗаголовокУзлаПланаОбмена =                       НСтр("ru = 'Синхронизация данных через универсальный формат'");
		ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента =         НСтр("ru = 'Другая программа'");
	КонецЕсли;

	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);

	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
	Если ИдентификаторНастройки = "ОбменКасса" Тогда
		КраткаяИнформацияПоОбмену = НСтр("ru = 'Данная настройка позволит синхронизировать данные между программами ""Розница, редакция 2.2""
		|и ""1С:Касса"". В синхронизации участвуют документы и нормативно-справочная информация.'");
	Иначе
		КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет синхронизировать данные между любыми программами, поддерживающими универсальный формат обмена ""Enterprise Data"".'");
	КонецЕсли;
	
	Если ИдентификаторНастройки = "ОбменКасса" Тогда
		ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = '1С:Касса'");
	Иначе
		ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Другая программа'");
	КонецЕсли;
	
	//ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "";
	ОписаниеВарианта.КраткаяИнформацияПоОбмену 		= КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника 	= НСтр("ru = 'Синхронизация данных через универсальный формат'");
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену 	= "ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
КонецПроцедуры

// Возвращает режим запуска, в случае интерактивного инициирования синхронизации.
// Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация.
// На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен.
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт

	Если УзелИнформационнойБазы.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация"
		Или (УзелИнформационнойБазы.ПравилаОтправкиДокументов = "НеСинхронизировать" 
		И УзелИнформационнойБазы.ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация") Тогда
		
		Возврат "АвтоматическаяСинхронизация";
		
	Иначе
		
		Возврат "ИнтерактивнаяСинхронизация";
		
	КонецЕсли;
	
КонецФункции

// Возвращает сценарий работы помощника интерактивного сопоставления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку.
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
	Если УзелИнформационнойБазы.ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		
		Возврат "ИнтерактивнаяСинхронизацияДокументов";
		
	ИначеЕсли УзелИнформационнойБазы.ПравилаОтправкиДокументов = "НеСинхронизировать"
		И УзелИнформационнойБазы.ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		Возврат "НеОтправлять";
		
	ИначеЕсли (УзелИнформационнойБазы.ПравилаОтправкиДокументов = "НеСинхронизировать"
		И УзелИнформационнойБазы.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости")
		ИЛИ УзелИнформационнойБазы.ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация" Тогда
		
		Возврат "ИнтерактивнаяСинхронизацияСправочников";
		
	КонецЕсли;
	
КонецФункции

// Возвращает имена реквизитов и табличных частей плана обмена, перечисленных через запятую,
// которые являются общими для пары обменивающихся конфигураций.
//
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для разного
//									состава общих данных узлов в зависимости от версии корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//						Возможно, например, использование различных форм для разных версий корреспондента.
//
// Возвращаемое значение:
//	Строка - Список имен реквизитов.
//
Функция ОбщиеДанныеУзлов()
	
	Возврат "ИспользоватьОтборПоОрганизациям, РежимВыгрузкиПриНеобходимости";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Функция ПолучитьПредставлениеКонфигурацииКорреспондента(КраткоеИмяКонфигурации) Экспорт
	КраткоеИмяКонфигурации = СокрЛП(КраткоеИмяКонфигурации);
	Если КраткоеИмяКонфигурации = "БухгалтерияПредприятия" Тогда
		Возврат НСтр("ru = 'Бухгалтерия предприятия, ред.3.0'");
	ИначеЕсли КраткоеИмяКонфигурации = "УправлениеПредприятием" Тогда
		Возврат НСтр("ru = '1С:ERP Управление предприятием, ред.2.0'");
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

// Процедура ИзменитьВерсиюФорматаОбмена
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ИзменитьВерсиюФорматаОбмена(Параметры) Экспорт
	
	ФлагОшибки = Ложь;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	СинхронизацияДанныхЧерезУниверсальныйФормат.Ссылка КАК УзелПланаОбмена
		|ИЗ
		|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат КАК СинхронизацияДанныхЧерезУниверсальныйФормат
		|ГДЕ
		|	СинхронизацияДанныхЧерезУниверсальныйФормат.ПометкаУдаления = ЛОЖЬ
		|	И СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтотУзел = ЛОЖЬ
		|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.УзелПланаОбмена);
			Блокировка.Заблокировать();
			
			УзелПланаОбменаОбъект = Выборка.УзелПланаОбмена.ПолучитьОбъект();
			Если Не ЗначениеЗаполнено(УзелПланаОбменаОбъект.ВерсияФорматаОбмена)
				Или УзелПланаОбменаОбъект.ВерсияФорматаОбмена = "1.0.beta"
				Или УзелПланаОбменаОбъект.ВерсияФорматаОбмена = "1.0" Тогда
				УзелПланаОбменаОбъект.ВерсияФорматаОбмена   = "1.2";	
			УзелПланаОбменаОбъект.ОбменДанными.Загрузка = Истина;
			УзелПланаОбменаОбъект.Записать();
			КонецЕсли; 
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать: %УзелПланаОбмена% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УзелПланаОбмена%", Выборка.УзелПланаОбмена);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат, Выборка.УзелПланаОбмена, ТекстСообщения);
				
			ФлагОшибки = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ФлагОшибки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли