﻿
// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru='Журнал учета полученных и выданных счетов-фактур'")
		+ УправлениеПечатьюРТКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода,
		Отчет.КонецПериода);
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + Отчет.Организация;
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	Элементы.КонтрагентДляОтбора.Доступность = Отчет.ОтбиратьПоКонтрагенту;
	Элементы.ГруппаДополнительныеНастройкиКонтрагенты.Доступность = Не Отчет.СформироватьОтчетПоСтандартнойФорме;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета(ЭтоПервоеФормированиеОтчета)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                         , Отчет.Организация);
	ПараметрыОтчета.Вставить("НалоговыйПериод"                     , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("ГруппироватьПоКонтрагентам"          , Отчет.ГруппироватьПоКонтрагентам);
	ПараметрыОтчета.Вставить("СформироватьОтчетПоСтандартнойФорме" , Отчет.СформироватьОтчетПоСтандартнойФорме);
	ПараметрыОтчета.Вставить("КонтрагентДляОтбора"                 , Отчет.КонтрагентДляОтбора);
	ПараметрыОтчета.Вставить("ОтбиратьПоКонтрагенту"               , Отчет.ОтбиратьПоКонтрагенту);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения"   , Отчет.ВключатьОбособленныеПодразделения);
	
	// Поддержка возможности формирования отчета за произвольный период
	Если КонецДня(Отчет.КонецПериода) <> КонецКвартала(Отчет.НачалоПериода) ИЛИ НачалоДня(Отчет.НачалоПериода) <> НачалоКвартала(Отчет.НачалоПериода) Тогда
		ПараметрыОтчета.Вставить("КонецПериодаОтчета", Отчет.КонецПериода);
		ПараметрыОтчета.СформироватьОтчетПоСтандартнойФорме = Ложь;
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("ЭтоЖурналУчетаСчетовФактур", Истина);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ДобавитьПараметрыДляПроверкиКонтрагентов(ЭтотОбъект, ПараметрыОтчета, 
		ЭтоПервоеФормированиеОтчета, ОсновнойРаздел);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами	
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередФормированиемОтчета(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(Истина);
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		УправлениеПечатьюРТ.ПодготовитьПараметрыЖурналаУчетаСчетовФактур(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"УправлениеПечатьюРТ.ПодготовитьПараметрыЖурналаУчетаСчетовФактур", 
			ПараметрыОтчета, 
			УправлениеПечатьюРТКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
			
			// СтандартныеПодсистемы.РаботаСКонтрагентами
			ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВОтчете(ЭтотОбъект);
			// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);

	Если РезультатВыполнения.Свойство("СформированныйЖурнал") Тогда
		
		РезультатВыполнения.Свойство("ОткрыватьПомощникИзМакета", ОткрыватьПомощникИзМакета);
		ОсновнойРаздел = РезультатВыполнения.СформированныйЖурнал;
		ПоказатьВыбранныйЛист();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ЗапомнитьРезультатФормированияОтчета(ЭтотОбъект, РезультатВыполнения);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьВыбранныйЛист()

	Результат.Очистить();
	Результат.АвтоМасштаб = Истина;
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Результат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЖурналУчетаСчетовФактур";
	Результат.ЧерноБелаяПечать = Истина;

	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ВывестиОтчет(ЭтотОбъект, Результат, ОсновнойРаздел);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	РассчитатьОбластьПечати();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");

КонецПроцедуры

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = УправлениеПечатьюРТВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	УправлениеПечатьюРТКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыИзПараметровФормы(Форма)
	
	ПараметрыЗаполненияФормы = Неопределено;
	
	Если Форма.Параметры.Свойство("ПараметрыЗаполненияФормы",ПараметрыЗаполненияФормы) Тогда
	
		ЗаполнитьЗначенияСвойств(Форма.Отчет,ПараметрыЗаполненияФормы);			
	
	КонецЕсли; 		

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
    Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отчет.НачалоПериода = РезультатВыбора.ДатаНачала;
	Отчет.КонецПериода  = РезультатВыбора.ДатаОкончания;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	Иначе
		// СтандартныеПодсистемы.РаботаСКонтрагентами
		ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВОтчете(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	СтандартныйПериод = Новый СтандартныйПериод;
	СтандартныйПериод.ДатаНачала    = Отчет.НачалоПериода;
	СтандартныйПериод.ДатаОкончания = Отчет.КонецПериода;

	ДиалогРедактированияПериода = Новый ДиалогРедактированияСтандартногоПериода;
	ДиалогРедактированияПериода.Период = СтандартныйПериод;
	
	Описание = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ДиалогРедактированияПериода.Показать(Описание);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппироватьПоКонтрагентамПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтбиратьПоКонтрагентуПриИзменении(Элемент)
	
	УправлениеФормой();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентДляОтбораПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоСтандартнойФормеПриИзменении(Элемент)
	
	Отчет.СформироватьОтчетПоСтандартнойФорме = ?(СформироватьОтчетПоПравилам = 1, Ложь, Истина);
	
	Если Отчет.СформироватьОтчетПоСтандартнойФорме Тогда
		Если Отчет.ОтбиратьПоКонтрагенту Тогда
			Отчет.ОтбиратьПоКонтрагенту = Ложь;
		КонецЕсли;
		Если Отчет.ГруппироватьПоКонтрагентам Тогда
			Отчет.ГруппироватьПоКонтрагентам = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеПечатьюРТВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	Отчет.СформироватьОтчетПоСтандартнойФорме = ?(СформироватьОтчетПоПравилам = 1, Ложь, Истина);
	
	ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереОтчет(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	УправлениеПечатьюРТВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	
	ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);

	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеПечатьюРТКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОтчетПриОткрытии(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	Отчет.СформироватьОтчетПоСтандартнойФорме = ?(СформироватьОтчетПоПравилам = 1, Ложь, Истина);
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	УправлениеПечатьюРТКлиент.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьОбластьПечати()

	ПерваяСтрока = 1;
	
	Если ОткрыватьПомощникИзМакета Тогда
		ПерваяСтрока = ПерваяСтрока + 1;
	КонецЕсли;
	
	Результат.ОбластьПечати = Результат.Область(ПерваяСтрока,1,Результат.ВысотаТаблицы, Результат.ШиринаТаблицы);

КонецПроцедуры

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаСервере
Функция ПроверитьКонтрагентов() Экспорт
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(Ложь);
	
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВОтчете(ЭтотОбъект, ПараметрыОтчета);
	
КонецФункции
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВОтчете(ЭтотОбъект, Результат, ОсновнойРаздел);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Процедура ПереключательРежимаОтображенияПриИзменении(Элемент)
	ПереключитьРежимОтображенияОтчета();
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаСервере
Процедура ПереключитьРежимОтображенияОтчета()
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПереключитьРежимОтображенияОтчета(ЭтотОбъект, Результат, ОсновнойРаздел);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

