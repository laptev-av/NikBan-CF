﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.ВыводитьСуммуВыделенныхЯчеек = Ложь;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
// См. также:
//   "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//   ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере().
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт

	СПАРКРиски.ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД);

КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета.
//   СвойстваНастройки - Структура - Описание настройки отчета, которая будет выведена в форме отчета.
//       * ОписаниеТипов - ОписаниеТипов -
//           Тип настройки.
//       * ЗначенияДляВыбора - СписокЗначений -
//           Объекты, которые будут предложены пользователю в списке выбора.
//           Дополняет список объектов, уже выбранных пользователем ранее.
//       * ЗапросЗначенийВыбора - Запрос -
//           Возвращает объекты, которыми необходимо дополнить ЗначенияДляВыбора.
//           Первой колонкой (с 0м индексом) должен выбираться объект,
//           который следует добавить в ЗначенияДляВыбора.Значение.
//           Для отключения автозаполнения
//           в свойство ЗапросЗначенийВыбора.Текст следует записать пустую строку.
//       * ОграничиватьВыборУказаннымиЗначениями - Булево -
//           Когда Истина, то выбор пользователя будет ограничен значениями,
//           указанными в ЗначенияДляВыбора (его конечным состоянием).
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт

	СПАРКРиски.ПриОпределенииПараметровВыбора(СвойстваНастройки);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	ТипСписокЗначений = Тип("СписокЗначений");
	ТипТаблицаЗначений = Тип("ТаблицаЗначений");

	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();

	// Проверка включения использования сервиса.
	Если Не СПАРКРиски.ИспользованиеСПАРКРискиВключено() Тогда

		Макет = ПолучитьМакет("ОписаниеОшибок");
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			ИмяОбласти = "ИспользованиеСервисаОтключено";
		Иначе
			ИмяОбласти = "ИспользованиеСервисаОтключеноОбычныйПользователь";
		КонецЕсли;

		Область = Макет.ПолучитьОбласть(ИмяОбласти);
		ДокументРезультат.Вывести(Область);

		Возврат;

	КонецЕсли;

	// Отчет всегда строится по данным кэша (регистра сведений "ИндексыСПАРКРиски").
	// Если есть данные, которые необходимо обновить - обновить их в кэше и сформировать отчет.

	// В модели сервиса вначале необходимо проверить, подключена ли услуга, или нет.
	// В коробке такая проверка не реализована.
	// Если услуга не подключена, то выдать ошибку и не выполнять никаких запросов.
	УслугаПодключена = ИнтернетПоддержкаПользователей.УслугаПодключена(
		СПАРКРискиКлиентСервер.ИдентификаторУслугиИндикаторыРиска());

	РезультатВызоваВебСервиса = СервисСПАРКРиски.НовыйРезультатВызоваСервиса();

	Если УслугаПодключена = Истина Тогда

		// 1. Вспомогательные настройки:
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

		ПараметрКонтрагенты = Новый ПараметрКомпоновкиДанных("Контрагенты");
		ЭлементПараметрКонтрагенты = Неопределено;

		ПараметрПоВсемКонтрагентам = Новый ПараметрКомпоновкиДанных("ПоВсемКонтрагентам");
		ЭлементПараметрПоВсемКонтрагентам = Неопределено;

		ПараметрСводныйИндикатор        = Новый ПараметрКомпоновкиДанных("СводныйИндикатор");
		ЭлементПараметрСводныйИндикатор = Неопределено;

		ПараметрИндексДолжнойОсмотрительности        = Новый ПараметрКомпоновкиДанных("ИндексДолжнойОсмотрительности");
		ЭлементПараметрИндексДолжнойОсмотрительности = Неопределено;

		ПараметрИндексФинансовогоРиска        = Новый ПараметрКомпоновкиДанных("ИндексФинансовогоРиска");
		ЭлементПараметрИндексФинансовогоРиска = Неопределено;

		ПараметрИндексПлатежнойДисциплины        = Новый ПараметрКомпоновкиДанных("ИндексПлатежнойДисциплины");
		ЭлементПараметрИндексПлатежнойДисциплины = Неопределено;

		ПараметрСтатус        = Новый ПараметрКомпоновкиДанных("СтатусНазвание");
		ЭлементПараметрСтатус = Неопределено;

		Для Каждого ТекущийПараметрДанных Из НастройкиОтчета.ПараметрыДанных.Элементы Цикл
			Если ТекущийПараметрДанных.Параметр = ПараметрКонтрагенты Тогда
				ЭлементПараметрКонтрагенты = ТекущийПараметрДанных;
			ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрПоВсемКонтрагентам Тогда
				ЭлементПараметрПоВсемКонтрагентам = ТекущийПараметрДанных;
			ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрСводныйИндикатор Тогда
				ЭлементПараметрСводныйИндикатор = ТекущийПараметрДанных;
			ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрИндексДолжнойОсмотрительности Тогда
				ЭлементПараметрИндексДолжнойОсмотрительности = ТекущийПараметрДанных;
			ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрИндексПлатежнойДисциплины Тогда
				ЭлементПараметрИндексПлатежнойДисциплины = ТекущийПараметрДанных;
			ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрИндексФинансовогоРиска Тогда
				ЭлементПараметрИндексФинансовогоРиска = ТекущийПараметрДанных;
			ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрСтатус Тогда
				ЭлементПараметрСтатус = ТекущийПараметрДанных;
			КонецЕсли;
		КонецЦикла;

		//  - Если в параметрах не выбрано ни одного контрагента, то установить значение параметра "ПоВсемКонтрагентам" в ИСТИНА.
		ПоВсемКонтрагентам = Истина;
		Если (ЭлементПараметрКонтрагенты <> Неопределено)
				И (ЭлементПараметрПоВсемКонтрагентам <> Неопределено) Тогда
			Если ЭлементПараметрКонтрагенты.Использование Тогда
				Если (ТипЗнч(ЭлементПараметрКонтрагенты.Значение) = ТипСписокЗначений) // Несколько значений передается списком значений.
						И (ЭлементПараметрКонтрагенты.Значение.Количество() > 0) Тогда
					ЭлементПараметрПоВсемКонтрагентам.Значение = Ложь;
					ПоВсемКонтрагентам = Ложь;
				ИначеЕсли ЭлементПараметрКонтрагенты.Значение = Неопределено Тогда
					ЭлементПараметрПоВсемКонтрагентам.Значение = Истина;
				Иначе // Если стоит отбор по одному значению, то передается не список значений, а ссылка.
					ЭлементПараметрПоВсемКонтрагентам.Значение = Ложь;
					ПоВсемКонтрагентам = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ПоВсемКонтрагентам = Истина Тогда
			СхемаКомпоновкиДанных.НаборыДанных.ИндексыСПАРКРиски.Запрос = СтрЗаменить(
				СхемаКомпоновкиДанных.НаборыДанных.ИндексыСПАРКРиски.Запрос,
				"И ((&ПоВсемКонтрагентам = ИСТИНА) ИЛИ (Рег.Контрагент В (&Контрагенты)) ИЛИ (Рег.Контрагент В ИЕРАРХИИ (&Контрагенты))) // НЕ ИЗМЕНЯТЬ ТЕКСТ ЭТОЙ СТРОКИ",
				"");
		Иначе
			СхемаКомпоновкиДанных.НаборыДанных.ИндексыСПАРКРиски.Запрос = СтрЗаменить(
				СхемаКомпоновкиДанных.НаборыДанных.ИндексыСПАРКРиски.Запрос,
				"И ((&ПоВсемКонтрагентам = ИСТИНА) ИЛИ (Рег.Контрагент В (&Контрагенты)) ИЛИ (Рег.Контрагент В ИЕРАРХИИ (&Контрагенты))) // НЕ ИЗМЕНЯТЬ ТЕКСТ ЭТОЙ СТРОКИ",
				"И ((Рег.Контрагент В (&Контрагенты)) ИЛИ (Рег.Контрагент В ИЕРАРХИИ (&Контрагенты))) // НЕ ИЗМЕНЯТЬ ТЕКСТ ЭТОЙ СТРОКИ");
		КонецЕсли;

		// 2. Сформируем список всех контрагентов. В запросе он хранится в "разобранном" виде, т.к. мы не знаем состав справочников.
		ВсеЗапросы = Новый Массив;
		ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ИндексыСПАРКРиски.Запрос;
		ТекстНачалаШаблона = "//# Начало запроса с выборкой разрешенных контрагентов.";
		ТекстКонцаШаблона  = "//# Конец запроса с выборкой разрешенных контрагентов.";
		ГдеНачалоШаблона = СтрНайти(ТекстЗапроса, ТекстНачалаШаблона);
		ГдеКонецШаблона  = СтрНайти(ТекстЗапроса, ТекстКонцаШаблона);
		ШаблонЗапроса = Сред(ТекстЗапроса, ГдеНачалоШаблона + СтрДлина(ТекстНачалаШаблона), ГдеКонецШаблона - ГдеНачалоШаблона - СтрДлина(ТекстНачалаШаблона));

		СвойстваСправочниковКонтрагентов = СПАРКРиски.СвойстваСправочниковКонтрагентов();

		ЭтоПервыйЗапрос = Истина;
		Для каждого ОписаниеСправочника Из СвойстваСправочниковКонтрагентов Цикл
			ТекстЭтогоЗапроса = ШаблонЗапроса;
			Если ЭтоПервыйЗапрос <> Истина Тогда
				ТекстЭтогоЗапроса = СтрЗаменить(
					ТекстЭтогоЗапроса,
					"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ", // Ключевое слово "РАЗРЕШЕННЫЕ" разрешено только для первого запроса.
					"ВЫБРАТЬ РАЗЛИЧНЫЕ");
				ТекстЭтогоЗапроса = СтрЗаменить(
					ТекстЭтогоЗапроса,
					"ПОМЕСТИТЬ ВТ_Контрагенты // ПОМЕЩЕНИЕ ВО ВРЕМЕННУЮ ТАБЛИЦУ",
					"");
				ВсеЗапросы.Добавить("ОБЪЕДИНИТЬ ВСЕ");
			КонецЕсли;
			ТекстЭтогоЗапроса =
				СтрЗаменить(
					ТекстЭтогоЗапроса,
					"//# ВНУТРЕННЕЕ СОЕДИНЕНИЕ С КОНТРАГЕНТАМИ // НЕ ИЗМЕНЯТЬ ТЕКСТ ЭТОЙ СТРОКИ",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						"ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.%1 КАК Спр
							|ПО Рег.Контрагент = Спр.Ссылка",
						ОписаниеСправочника.Имя));
			ВсеЗапросы.Добавить(ТекстЭтогоЗапроса);
			ЭтоПервыйЗапрос = Ложь;
		КонецЦикла;
		ВсеЗапросы.Добавить(
			"ИНДЕКСИРОВАТЬ ПО
				|	Контрагент");

		СхемаКомпоновкиДанных.НаборыДанных.ИндексыСПАРКРиски.Запрос =
			СтрСоединить(ВсеЗапросы, Символы.ПС)
			+ Прав(ТекстЗапроса, СтрДлина(ТекстЗапроса) - ГдеКонецШаблона - СтрДлина(ТекстКонцаШаблона));

		// 3. Сформируем запрос и определим, индексы каких контрагентов необходимо обновить.
		ЕстьОшибки = Ложь;
		КонтрагентыДляОбновления = Новый ТаблицаЗначений;
		ВариантНастроекПроверкиКонтрагентов = Неопределено;
		Для Каждого ТекущийВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
			Если ТекущийВариантНастроек.Имя = "СписокКонтрагентовДляОбновления" Тогда
				ВариантНастроекПроверкиКонтрагентов = ТекущийВариантНастроек;
				Прервать;
			КонецЕсли;
		КонецЦикла;

		Если ВариантНастроекПроверкиКонтрагентов <> Неопределено Тогда

			НастройкиПроверкиКонтрагентов = ВариантНастроекПроверкиКонтрагентов.Настройки;
			// Вставить необходимые настройки:
			//  Параметры:
			//  - Срок годности      - текущая дата минус 12 часов;
			//  - Контрагенты        - из основного запроса;
			//  - ПоВсемКонтрагентам - из основного запроса.
			СрокГодности = ТекущаяДатаСеанса() - 12*60*60;
			ПараметрСрокГодности = Новый ПараметрКомпоновкиДанных("СрокГодности");
			Для Каждого ТекущийПараметрДанных Из НастройкиПроверкиКонтрагентов.ПараметрыДанных.Элементы Цикл
				Если ТекущийПараметрДанных.Параметр = ПараметрСрокГодности Тогда
					ТекущийПараметрДанных.Значение = СрокГодности;
				ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрКонтрагенты Тогда
					ЗаполнитьЗначенияСвойств(ТекущийПараметрДанных, ЭлементПараметрКонтрагенты, "Значение, Использование");
				ИначеЕсли ТекущийПараметрДанных.Параметр = ПараметрПоВсемКонтрагентам Тогда
					ЗаполнитьЗначенияСвойств(ТекущийПараметрДанных, ЭлементПараметрПоВсемКонтрагентам, "Значение, Использование");
				КонецЕсли;
			КонецЦикла;

			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(
				СхемаКомпоновкиДанных,
				НастройкиПроверкиКонтрагентов,
				,
				,
				Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(КонтрагентыДляОбновления);
			Попытка
				КонтрагентыДляОбновления = ПроцессорВывода.Вывести(ПроцессорКомпоновки, Ложь);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				СПАРКРиски.ЗаписатьОшибкуВЖурналРегистрации(
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			КонецПопытки;
			Если (ТипЗнч(КонтрагентыДляОбновления) = ТипТаблицаЗначений)
					И (КонтрагентыДляОбновления.Количество() > 0) Тогда
				// Обновить данные напрямую.
				МассивОписанийКонтрагентов = Новый Массив;
				Если ОбщегоНазначения.РазделениеВключено() Тогда
					КонтрагентОбластьДанных = ИнтернетПоддержкаПользователей.ЗначениеРазделителяСеанса();
				Иначе
					КонтрагентОбластьДанных = -1;
				КонецЕсли;
				Для Каждого ТекущийКонтрагент Из КонтрагентыДляОбновления Цикл
					ОписаниеКонтрагента = СПАРКРискиКлиентСервер.НовыйОписаниеКонтрагента();
					ОписаниеКонтрагента.ОбластьДанных = КонтрагентОбластьДанных;
					ОписаниеКонтрагента.Контрагент    = ТекущийКонтрагент.Контрагент;
					ОписаниеКонтрагента.ИНН           = СокрЛП(ТекущийКонтрагент.ИНН);
					МассивОписанийКонтрагентов.Добавить(ОписаниеКонтрагента);
					// Получение данных "пачками" по 1000 штук (в веб-сервис будет отправляться по 100 штук).
					Если МассивОписанийКонтрагентов.Количество() >= 1000 Тогда
						РезультатВызоваВебСервиса = СервисСПАРКРиски.ЗагрузитьИндексыКонтрагентов(
							КонтрагентОбластьДанных,
							МассивОписанийКонтрагентов); // Это не фоновое задание.
						МассивОписанийКонтрагентов = Новый Массив;
						Если РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ПустаяСсылка() Тогда
							// Нет ошибок, можно продолжать.
						Иначе
							ЕстьОшибки = Истина;
							Прервать;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				// Если в процессе получения "пачек" была ошибка, то не вызывать "СервисСПАРКРиски.ЗагрузитьИндексыКонтрагентов",
				//  чтобы в РезультатВызоваВебСервиса остался заполнен ВидОшибки.
				Если ЕстьОшибки = Ложь Тогда
					Если МассивОписанийКонтрагентов.Количество() > 0 Тогда
						РезультатВызоваВебСервиса = СервисСПАРКРиски.ЗагрузитьИндексыКонтрагентов(
							КонтрагентОбластьДанных,
							МассивОписанийКонтрагентов); // Это не фоновое задание.
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ПустаяСсылка() Тогда
				// Нет ошибок, можно продолжать.
			Иначе
				ЕстьОшибки = Истина;
			КонецЕсли;

		КонецЕсли;

	Иначе
		РезультатВызоваВебСервиса.Вставить("ВидОшибки", Перечисления.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит);
		РезультатВызоваВебСервиса.Вставить("СообщениеОбОшибке", НСтр("ru = 'Услуга не подключена.'"));
		РезультатВызоваВебСервиса.Вставить("ИнформацияОбОшибке", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось сформировать отчет по индексам 1СПАРК Риски.
				|Услуга с идентификатором %1 не подключена.'"),
			СПАРКРискиКлиентСервер.ИдентификаторУслугиИндикаторыРиска()));
		ЕстьОшибки = Истина;
	КонецЕсли;

	Если ЕстьОшибки = Истина Тогда

		Макет = ПолучитьМакет("ОписаниеОшибок");
		ИмяОбласти = "НеизвестнаяОшибка";

		Если РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ВнутренняяОшибкаСервиса Тогда
			ИмяОбласти = "СервисНедоступен";
		ИначеЕсли РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ИнтернетПоддержкаНеПодключена Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ИППНеПодключена";
			Иначе
				ИмяОбласти = "ИППНеПодключенаОбычныйПользователь";
			КонецЕсли;
		ИначеЕсли РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ОшибкаПодключения Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ОшибкаПодключения";
			Иначе
				ИмяОбласти = "ОшибкаПодключенияОбычныйПользователь";
			КонецЕсли;
		ИначеЕсли РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ОшибкаАутентификации Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ОшибкаАутентификации";
			Иначе
				ИмяОбласти = "ОшибкаАутентификацииОбычныйПользователь";
			КонецЕсли;
		ИначеЕсли РезультатВызоваВебСервиса.ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит Тогда
			
			// Обработка подключения тестового периода.
			Если РезультатВызоваВебСервиса.ОшибкаПриПроверкеТестовогоПериода Тогда
				Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
					ИмяОбласти = "ОшибкаПроверкиТестовыхПериодов";
				Иначе
					ИмяОбласти = "ОшибкаПроверкиТестовыхПериодовОбычныйПользователь";
				КонецЕсли;
			ИначеЕсли РезультатВызоваВебСервиса.ДоступностьПодключенияТестовогоПериода = "Подключение" Тогда
				ИмяОбласти = "ОбработкаЗапросаНаПодключение";
			ИначеЕсли РезультатВызоваВебСервиса.ДоступностьПодключенияТестовогоПериода = "Доступно" Тогда
				ИмяОбласти = "ПодключитьТестовыйПериод";
			Иначе
				ИмяОбласти = "СервисНеПодключен";
			КонецЕсли;
		Иначе
			
			// Возможные значения:
			// - Перечисления.ВидыОшибокСПАРКРиски.ПревышеноКоличествоПопытокАутентификации;
			// - Перечисления.ВидыОшибокСПАРКРиски.ИспользованиеЗапрещено;
			// - Перечисления.ВидыОшибокСПАРКРиски.НеизвестнаяОшибка;
			// - Перечисления.ВидыОшибокСПАРКРиски.НеизвестныйИНН;
			// - Перечисления.ВидыОшибокСПАРКРиски.НекорректныйЗапрос;
			// - Перечисления.ВидыОшибокСПАРКРиски.НеПодлежитПроверке.
			ИмяОбласти = "НеизвестнаяОшибка";
			
		КонецЕсли;
		
		Область = Макет.ПолучитьОбласть(ИмяОбласти);
		Если ИмяОбласти = "СервисНеПодключен" Тогда
			Область.Параметры.АдресОписаниеСервисаСПАРК = СПАРКРискиКлиентСервер.АдресСтраницыОписанияСервисаСПАРКРиски();
		ИначеЕсли ИмяОбласти = "ПодключитьТестовыйПериод" Тогда
			Область.Параметры.ПодключитьТестовыйПериодСПАРК = "ПодключитьТестовыйПериодСПАРК";
		КонецЕсли;
		
		ДокументРезультат.Вывести(Область);

		// Нет данных для отправки.
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", Истина);

	Иначе

		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

		// Если заполнены параметры отбора по индексам, то включить соответствующие отборы.
		Для Каждого ТекущийЭлементОтбора Из НастройкиОтчета.Отбор.Элементы Цикл
			Если ТекущийЭлементОтбора.Представление = "СводныйИндикатор" Тогда
				Если (ЭлементПараметрСводныйИндикатор <> Неопределено)
						И (ЭлементПараметрСводныйИндикатор.Использование = Истина) Тогда
					ТекущийЭлементОтбора.Использование = Истина;
				КонецЕсли;
			ИначеЕсли ТекущийЭлементОтбора.Представление = "ИндексДолжнойОсмотрительности" Тогда
				Если (ЭлементПараметрИндексДолжнойОсмотрительности <> Неопределено)
						И (ЭлементПараметрИндексДолжнойОсмотрительности.Использование = Истина) Тогда
					ТекущийЭлементОтбора.Использование = Истина;
				КонецЕсли;
			ИначеЕсли ТекущийЭлементОтбора.Представление = "ИндексПлатежнойДисциплины" Тогда
				Если (ЭлементПараметрИндексПлатежнойДисциплины <> Неопределено)
						И (ЭлементПараметрИндексПлатежнойДисциплины.Использование = Истина) Тогда
					ТекущийЭлементОтбора.Использование = Истина;
				КонецЕсли;
			ИначеЕсли ТекущийЭлементОтбора.Представление = "ИндексФинансовогоРиска" Тогда
				Если (ЭлементПараметрИндексФинансовогоРиска <> Неопределено)
						И (ЭлементПараметрИндексФинансовогоРиска.Использование = Истина) Тогда
					ТекущийЭлементОтбора.Использование = Истина;
				КонецЕсли;
			ИначеЕсли ТекущийЭлементОтбора.Представление = "Статус" Тогда
				Если (ЭлементПараметрСтатус <> Неопределено)
						И (ЭлементПараметрСтатус.Использование = Истина) Тогда
					ТекущийЭлементОтбора.Использование = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		ДокументРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);

		// Есть данные для отправки.
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", Ложь);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли