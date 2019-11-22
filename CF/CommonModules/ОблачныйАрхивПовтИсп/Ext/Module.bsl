﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ФункциональныеОпции

// Можно ли технически работать с облачным архивом и включена ли опция, разрешающая работать с этой подсистемой.
// В отличие от ВозможнаРаботаСОблачнымАрхивом() проверяется наличие технической возможности
//  и результат выбора пользователя в форме настроек.
// Это результат функциональной опции "РазрешенаРаботаСОблачнымАрхивом",
//   И доступны нужные роли,
//   И это файловая база,
//   И конфигурация запущена в Windows,
//   И информационная база работает в локальном режиме,
//   И это не веб-клиент и не внешнее соединение.
// 
// Возвращаемое значение:
//  Булево - Истина, если возможна и разрешена работа с облачным архивом.
//
Функция РазрешенаРаботаСОблачнымАрхивом() Экспорт
	
	#Если Сервер ИЛИ ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда

		// Сервер, ТонкийКлиент, ТолстыйКлиентОбычноеПриложение, ТолстыйКлиентУправляемоеПриложение.

		УстановитьПривилегированныйРежим(Истина);

		// Т.к. эта функция может вызываться из неразделенного регламентного задания,
		//  то начале проверяется возможность запуска,
		//  и только потом считывается значение разделенной константы (функциональной опции).

		Результат = 
			ВозможнаРаботаСОблачнымАрхивом()
			И ПолучитьФункциональнуюОпцию("РазрешенаРаботаСОблачнымАрхивом");

	#Иначе

		// ВебКлиент, ВнешнееСоединение.

		Результат = Ложь;

	#КонецЕсли

	Возврат Результат;

КонецФункции

// Можно ли технически работать с облачным архивом.
// В отличие от РазрешенаРаботаСОблачнымАрхивом() проверяется только наличие технической возможности работы с облачным архивом.
// Это результат, что
//   доступны нужные роли,
//   И это файловая база,
//   И конфигурация запущена в Windows,
//   И информационная база работает в локальном режиме,
//   И это не веб-клиент и не внешнее соединение.
// 
// Возвращаемое значение:
//  Булево - Истина, если возможна работа с облачным архивом.
//
Функция ВозможнаРаботаСОблачнымАрхивом() Экспорт

	#Если Сервер ИЛИ ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда

		// Сервер, ТонкийКлиент, ТолстыйКлиентОбычноеПриложение, ТолстыйКлиентУправляемоеПриложение.

		УстановитьПривилегированныйРежим(Истина); // Надо учесть, что привилегированный режим влияет на работу Пользователи.ЭтоПолноправныйПользователь.

		лкСистемнаяИнформация = Новый СистемнаяИнформация;

		Результат = 
			НЕ ОбщегоНазначения.РазделениеВключено() // Запрещено работать в модели сервиса.
			И ОбщегоНазначения.ИнформационнаяБазаФайловая() // Должна работать только в файловой базе.
			И Пользователи.ЭтоПолноправныйПользователь(,,Ложь) // Привилегированный режим уже установлен, но его не надо учитывать.
			И (
				(лкСистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86)
				ИЛИ (лкСистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64));

	#Иначе

		// ВебКлиент, ВнешнееСоединение.

		Результат = Ложь;

	#КонецЕсли

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Функция возвращает значение, надо ли вести подробный журнал регистрации.
//
// Возвращаемое значение:
//   Булево - Истина, если надо вести подробный журнал регистрации, Ложь в противном случае.
//
Функция ВестиПодробныйЖурналРегистрации() Экспорт

	ТипСтруктура = Тип("Структура");
	ТипБулево    = Тип("Булево");

	ЖурналРегистрации_ПодробнаяЗапись = Истина;

	НастройкиЖурналаРегистрации = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива(
		"НастройкиЖурналаРегистрации",
		"");

	Если ТипЗнч(НастройкиЖурналаРегистрации) = ТипСтруктура Тогда
		Если НастройкиЖурналаРегистрации.Свойство("ЖурналРегистрации_ПодробнаяЗапись") Тогда
			Если ТипЗнч(НастройкиЖурналаРегистрации.ЖурналРегистрации_ПодробнаяЗапись) = ТипБулево Тогда
				ЖурналРегистрации_ПодробнаяЗапись = НастройкиЖурналаРегистрации.ЖурналРегистрации_ПодробнаяЗапись;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат ЖурналРегистрации_ПодробнаяЗапись;

КонецФункции

#КонецОбласти

#КонецОбласти
