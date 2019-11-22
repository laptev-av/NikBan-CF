﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//	Настройки - Структура - Содержит настройки по умолчанию.
//
Процедура ПриПолученииНастроек(НастройкиПланаОбмена) Экспорт
	
	НастройкиПланаОбмена.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	НастройкиПланаОбмена.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;

	НастройкиПланаОбмена.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
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
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;

	ОписаниеВарианта.КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, 
	|состоящую из отдельных информационных баз системы «1С:Предприятие» - узлов распределенной информационной базы, 
	|между которыми организована синхронизация конфигурации и данных. Главной особенностью распределенных информационных баз 
	|является передача изменений конфигурации в подчиненные узлы. Имеется возможность настраивать ограничения миграции данных.'");
	
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "http://its.1c.ru/db/metod81#content:4352:1";
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);

	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Настройки обмена для магазина'");

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена для магазина'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
	ОписаниеВарианта.ОбщиеДанныеУзлов  = ОбщиеДанныеУзлов();
	
КонецПроцедуры

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
	
	Возврат "ДатаНачалаВыгрузкиДокументов, Магазины";
	
КонецФункции

// Возвращает префикс кода настройки выполнения обмена данными;
// Длина префикса не должна превышать один символ;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 1 - префикс кода настройки выполнения обмена данными.
// 
Функция ПрефиксНастройкиОбменаДанными() Экспорт
	
	Возврат "М";
	
КонецФункции

// Определяет несколько вариантов настройки расписания выполнения обмена данными;
// Рекомендуется указывать не более 3 вариантов;
// Эти варианты должны быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  ВариантыНастройки - СписокЗначений - список расписаний обмена данными.
//
Функция ВариантыНастройкиРасписания() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	// Расписание №1
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание1 = Новый РасписаниеРегламентногоЗадания;
	Расписание1.ДниНедели                = ДниНедели;
	Расписание1.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание1.ПериодПовтораДней        = 1; // каждый день
	Расписание1.Месяцы                   = Месяцы;
	
	// Расписание №2
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание2 = Новый РасписаниеРегламентногоЗадания;
	Расписание2.ВремяНачала              = Дата('00010101080000');
	Расписание2.ВремяКонца               = Дата('00010101200000');
	Расписание2.ПериодПовтораВТечениеДня = 3600; // каждый час
	Расписание2.ПериодПовтораДней        = 1; // каждый день
	Расписание2.ДниНедели                = ДниНедели;
	Расписание2.Месяцы                   = Месяцы;
	
	// Расписание №3
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	
	Расписание3 = Новый РасписаниеРегламентногоЗадания;
	Расписание3.ДниНедели         = ДниНедели;
	Расписание3.ВремяНачала       = Дата('00010101020000');
	Расписание3.ПериодПовтораДней = 1; // каждый день
	Расписание3.Месяцы            = Месяцы;
	
	// Возвращаемое значение функции.
	ВариантыНастройки = Новый СписокЗначений;
	
	ВариантыНастройки.Добавить(Расписание1, НСтр("ru='Один раз в 15 минут, кроме субботы и воскресенья'"));
	ВариантыНастройки.Добавить(Расписание2, НСтр("ru='Каждый час с 8:00 до 20:00, ежедневно'"));
	ВариантыНастройки.Добавить(Расписание3, НСтр("ru='Каждую ночь в 2:00, кроме субботы и воскресенья'"));
	
	Возврат ВариантыНастройки;
КонецФункции

// Определяет версию платформы базы-приемника для создания СОМ-подключения;
// Возможные варианты возвращаемого значения: "V81"; "V82".
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 3 - версия платформы базы-приемника (V81; V82).
//
Функция ВерсияПлатформыИнформационнойБазы() Экспорт
	
	Возврат "V82";
	
КонецФункции

// Функция возвращает структуру
//
// Возвращаемое значение:
//  Структура с ключами:
//  ИспользоватьОстаткиПоМагазинам - Булево.
//  ИспользоватьОстаткиПоСкладам   - Булево.
//  ОграничениеРИБПоМагазинам      - Массив.
//  ОграничениеРИБПоСкладам        - Массив.
//
Функция ПолучитьУсловияПоОстаткамВРИБ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СтруктураПараметров = Новый Структура;
	Если ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоМагазину") <> Неопределено
		И ПланыОбмена.ПоМагазину.ЭтотУзел().Магазины.Количество() <> 0 Тогда
		
		МассивМагазинов = ПланыОбмена.ПоМагазину.ЭтотУзел().Магазины.ВыгрузитьКолонку("Магазин");
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоМагазинам", Истина);
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоСкладам"  , Ложь);
		СтруктураПараметров.Вставить("ОграничениеРИБПоМагазинам"     , МассивМагазинов);
		СтруктураПараметров.Вставить("ОграничениеРИБПоСкладам"       , Новый Массив);
				
	ИначеЕсли ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоМагазинам", Ложь);
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоСкладам"  , Ложь);
		СтруктураПараметров.Вставить("ОграничениеРИБПоМагазинам"     , Новый Массив);
		СтруктураПараметров.Вставить("ОграничениеРИБПоСкладам"       , Новый Массив);
				
	ИначеЕсли ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоРабочемуМесту") <> Неопределено 
		И ПланыОбмена.ПоРабочемуМесту.ЭтоРабочееМесто() Тогда
		
		МассивМагазинов = Новый Массив;
		МассивМагазинов.Добавить(ПланыОбмена.ПоРабочемуМесту.ЭтотУзел().Магазин);
				
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоМагазинам", Истина);
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоСкладам"  , Истина);
		СтруктураПараметров.Вставить("ОграничениеРИБПоМагазинам"     , Новый Массив);
		СтруктураПараметров.Вставить("ОграничениеРИБПоСкладам"       , МассивМагазинов);
				
	Иначе
		
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоМагазинам", Ложь);
		СтруктураПараметров.Вставить("ИспользоватьОстаткиПоСкладам"  , Ложь);
		СтруктураПараметров.Вставить("ОграничениеРИБПоМагазинам"     , Новый Массив);
		СтруктураПараметров.Вставить("ОграничениеРИБПоСкладам"       , Новый Массив);
				
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	Возврат СтруктураПараметров;
	
КонецФункции

// Возвращает признак учета остатков по магазину в текущем узле РИБ.
//
// Параметры:
//  Магазин  - СправочникСсылка.Магазины - ссылка на элемент справочника Магазины.
//              для которого нужно вернуть признак учета
//
// Возвращаемое значение:
//   Булево   - Истина - для магазина ведется учет остатков в базе.
//              Ложь - для магазина не ведется учет остатков в базе.
//
Функция ВедетсяУчетОстатковМагазина(Магазин) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПараметрыСеанса.ИспользуемыеПланыОбмена.Найти("ПоМагазину") <> Неопределено
		И ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПоМагазинуМагазины.Магазин
		|ИЗ
		|	ПланОбмена.ПоМагазину.Магазины КАК ПоМагазинуМагазины
		|ГДЕ
		|	ПоМагазинуМагазины.Ссылка <> &ГлавныйУзел
		|	И НЕ ПоМагазинуМагазины.Ссылка.ПометкаУдаления
		|	И ПоМагазинуМагазины.Магазин = &Магазин";
		
		Запрос.УстановитьПараметр("ГлавныйУзел", ПланыОбмена.ГлавныйУзел());
		Запрос.УстановитьПараметр("Магазин", Магазин);
		
		Возврат НЕ Запрос.Выполнить().Пустой();
	Иначе
		Возврат Истина;
	
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецФункции // ВедетсяУчетОстатковМагазина()

#КонецОбласти

#КонецЕсли