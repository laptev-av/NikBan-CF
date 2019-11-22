﻿// Универсальные механизмы интеграции ИС (ЕГАИС, ГИСМ, ВЕТИС, ...)

#Область ПрограммныйИнтерфейс

#Область ИнтегрируемыеПодсистемы

Функция ПолноеИмяПодсистемы(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1", ИмяПодсистемы);
	
КонецФункции

Функция ПредставлениеПодсистемы(Представление)
	
	Если НЕ ЗначениеЗаполнено(Представление) Тогда
		Возврат НСтр("ru = '<Интеграция>'");
	Иначе
		Возврат Представление;
	КонецЕсли;
	
КонецФункции

Функция МодульКлиент(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1Клиент", ИмяПодсистемы);
	
КонецФункции

Функция МодульСервер(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1", ИмяПодсистемы);
	
КонецФункции

Функция МодульКлиентСервер(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1КлиентСервер", ИмяПодсистемы);
	
КонецФункции

#КонецОбласти

#Область ФормыДокументовОснований

// Устанавливается свойство ОтображениеПредупрежденияПриРедактировании элемента формы.
//
Процедура ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать) Экспорт
	
	Если Отображать Тогда
		Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
	Иначе
		Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область КомандыНавигационнойСсылки

// Имя команды представляет собой строку формата
// ИнтеграцияИС_КомандаНавигационнойСсылки#<ИмяПодсистемы>#<Действие>[#<Параметр1>#<Параметр2>...]
// где
//	ИнтеграцияИС_КомандаНавигационнойСсылки - постоянный префикс, указывающий принадлежность команды к данному механизму
//	<ИмяПодсистемы> - имя интегрируемой подсистемы, к которой относится команда
//	<Действие> - действие, которое должно быть выполнено по данной команде, см. ПрефиксКоманды...()
//  <Параметр...> - произвольная строка-параметр команды; количество параметров определяется контекстом конкретной команды

Функция ПреобразоватьИмяКомандыНавигационнойСсылкиВоВнутреннийФормат(ИмяКоманды) Экспорт
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		ИмяКоманды,
		РазделительКомандыНавигационнойСсылки(),
		Истина);
	
	Возврат ЧастиИмени;
	
КонецФункции


Функция ЭтоИмяКомандыНавигационнойСсылки(ИмяКоманды, ИмяПодсистемы) Экспорт
	
	Префикс = ОбщийПрефиксКомандыНавигационнойСсылки(ИмяПодсистемы);
	
	Возврат (Лев(ИмяКоманды, СтрДлина(Префикс)) = Префикс);
	
КонецФункции

Функция ЭтоКомандаНавигационнойСсылкиСоздатьОбъект(ОписаниеКоманды) Экспорт
	
	Возврат ОписаниеКоманды[2] = ПрефиксКомандыСоздатьОбъект();
	
КонецФункции

Функция ЭтоКомандаНавигационнойСсылкиОткрытьОбъект(ОписаниеКоманды) Экспорт
	
	Возврат ОписаниеКоманды[2] = ПрефиксКомандыОткрытьОбъект();
	
КонецФункции

Функция ЭтоКомандаНавигационнойСсылкиОткрытьПротоколОбмена(ОписаниеКоманды) Экспорт
	
	Возврат ОписаниеКоманды[2] = ПрефиксКомандыОткрытьПротоколОбмена();
	
КонецФункции


Функция ИмяОбъектаДляСозданияИзВнутреннегоФорматаКомандыНавигационнойСсылки(ОписаниеКоманды) Экспорт
	
	Возврат ОписаниеКоманды[3];
	
КонецФункции

Функция ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(ОписаниеКоманды) Экспорт
	
	Возврат ОписаниеКоманды[3];
	
КонецФункции


Функция ИмяКомандыСоздатьОбъект(ИмяПодсистемы, ИмяОбъекта) Экспорт
	
	Возврат
		ОбщийПрефиксКомандыНавигационнойСсылки(ИмяПодсистемы)
		+ ПрефиксКомандыСоздатьОбъект() + РазделительКомандыНавигационнойСсылки()
		+ ИмяОбъекта;
	
КонецФункции

Функция ИмяКомандыОткрытьОбъект(ИмяПодсистемы, ИмяОбъекта) Экспорт
	
	Возврат
		ОбщийПрефиксКомандыНавигационнойСсылки(ИмяПодсистемы)
		+ ПрефиксКомандыОткрытьОбъект() + РазделительКомандыНавигационнойСсылки()
		+ ИмяОбъекта;
	
КонецФункции

Функция ИмяКомандыОткрытьПротоколОбмена(ИмяПодсистемы) Экспорт
	
	Возврат
		ОбщийПрефиксКомандыНавигационнойСсылки(ИмяПодсистемы)
		+ ПрефиксКомандыОткрытьПротоколОбмена();
	
КонецФункции

#КонецОбласти

#Область СобытияОповещения

// Имя события представляет собой строку формата
// ИнтеграцияИС_СобытиеОповещения#<ИмяПодсистемы>#<Действие>[#<Параметр1>#<Параметр2>...]
// где
//	ИнтеграцияИС_СобытиеОповещения - постоянный префикс, указывающий принадлежность события к данному механизму
//	<ИмяПодсистемы> - имя интегрируемой подсистемы, к которой относится событие
//	<Действие> - действие, которое инициировало данное событие, см. ПрефиксСобытия...()
//  <Параметр...> - произвольная строка-параметр события; количество параметров определяется контекстом конкретного события

Функция ПреобразоватьИмяСобытияОповещенияВоВнутреннийФормат(ИмяСобытия) Экспорт
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		ИмяСобытия,
		РазделительСобытияОповещения(),
		Истина);
	
	Возврат ЧастиИмени;
	
КонецФункции


Функция ЭтоИмяСобытияОповещения(ИмяСобытия, ИмяПодсистемы) Экспорт
	
	Префикс = ОбщийПрефиксСобытияОповещения(ИмяПодсистемы);
	
	Возврат (Лев(ИмяСобытия, СтрДлина(Префикс)) = Префикс);
	
КонецФункции

Функция ЭтоСобытиеОповещенияИзмененОбъект(ОписаниеСобытия) Экспорт
	
	Возврат ОписаниеСобытия[2] = ПрефиксСобытияИзмененОбъект();
	
КонецФункции

Функция ЭтоСобытиеОповещенияИзмененоСостояние(ОписаниеСобытия) Экспорт
	
	Возврат ОписаниеСобытия[2] = ПрефиксСобытияИзмененоСостояние();
	
КонецФункции

Функция ЭтоСобытиеОповещенияВыполненОбмен(ОписаниеСобытия) Экспорт
	
	Возврат ОписаниеСобытия[2] = ПрефиксСобытияВыполненОбмен();
	
КонецФункции


Функция ИмяИзмененногоОбъектаИзВнутреннегоФорматаСобытияОповещения(ОписаниеСобытия) Экспорт
	
	Возврат ОписаниеСобытия[3];
	
КонецФункции

Функция ИмяСобытияИзмененОбъект(ИмяПодсистемы, ИсточникИмениОбъекта = Неопределено) Экспорт
	
	Если ИсточникИмениОбъекта = Неопределено Тогда
		ИмяОбъекта = "";
	ИначеЕсли ТипЗнч(ИсточникИмениОбъекта) = Тип("УправляемаяФорма") Тогда
		ИмяОбъекта = ИмяОбъектаИзИмениФормы(ИсточникИмениОбъекта);
	Иначе
		ИмяОбъекта = ИсточникИмениОбъекта;
	КонецЕсли;
	
	Возврат
		ОбщийПрефиксСобытияОповещения(ИмяПодсистемы)
		+ ПрефиксСобытияИзмененОбъект() + РазделительСобытияОповещения()
		+ ИмяОбъекта;
	
КонецФункции

Функция ИмяСобытияИзмененоСостояние(ИмяПодсистемы) Экспорт
	
	Возврат
		ОбщийПрефиксСобытияОповещения(ИмяПодсистемы)
		+ ПрефиксСобытияИзмененоСостояние();
	
КонецФункции

Функция ИмяСобытияВыполненОбмен(ИмяПодсистемы) Экспорт
	
	Возврат
		ОбщийПрефиксСобытияОповещения(ИмяПодсистемы)
		+ ПрефиксСобытияВыполненОбмен();
	
КонецФункции

Функция ИмяСвойстваОбновлятьСтатусВФормахДокументов(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("ОбновлятьСтатус%1ВФормахДокументов", ИмяПодсистемы);
	
КонецФункции

#КонецОбласти

#Область ТекстыСтандартныхСообщений

Функция ТекстКомандаНеМожетБытьВыполнена() Экспорт
	Возврат НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
КонецФункции

#КонецОбласти

#Область Прочие

Функция ИмяОбъектаИзИмениФормы(Форма, ПолноеИмя = Истина) Экспорт
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.ИмяФормы, ".");
	
	Если ПолноеИмя Тогда
		ИмяОбъекта = ЧастиИмени[0] + "." + ЧастиИмени[1];
	Иначе
		ИмяОбъекта = ЧастиИмени[1];
	КонецЕсли;
	
	Возврат ИмяОбъекта;
	
КонецФункции

// Проверяет наличие у произвольного объекта реквизита с указанным именем.
//
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ФормыДокументовОснований

Функция ИмяПоляИнтеграцииВФормеДокументаОснования(ИмяПодсистемы) Экспорт
	
	Возврат "Интеграция" + ИмяПодсистемы + "_ИнформацияОДокументах";
	
КонецФункции

Функция ИмяПоляОписанияИнтеграцийВФормеДокументаОснования() Экспорт
	
	Возврат "ИнтеграцияИС_ИнтегрируемыеПодсистемы";
	
КонецФункции

Функция ИнтегрируемыеПодсистемыВФормеДокументаОснования(Форма) Экспорт
	
	ИмяПоля = ИмяПоляОписанияИнтеграцийВФормеДокументаОснования();
	
	СтруктураРеквизитов = Новый Структура(ИмяПоля);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Форма);
	
	Если СтруктураРеквизитов[ИмяПоля] = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	Возврат СтруктураРеквизитов[ИмяПоля];
	
КонецФункции

#КонецОбласти

#Область КомандыНавигационнойСсылки

Функция РазделительКомандыНавигационнойСсылки()
	
	Возврат "#";
	
КонецФункции


Функция ОбщийПрефиксКомандыНавигационнойСсылки(ИмяПодсистемы)
	
	Возврат 
		"ИнтеграцияИС_КомандаНавигационнойСсылки" + РазделительКомандыНавигационнойСсылки()
		+ ИмяПодсистемы + РазделительКомандыНавигационнойСсылки();
	
КонецФункции

Функция ПрефиксКомандыСоздатьОбъект()
	
	Возврат "СоздатьОбъект";
	
КонецФункции

Функция ПрефиксКомандыОткрытьОбъект()
	
	Возврат "ОткрытьОбъект";
	
КонецФункции

Функция ПрефиксКомандыОткрытьПротоколОбмена()
	
	Возврат "ОткрытьПротоколОбмена";
	
КонецФункции

#КонецОбласти

#Область СобытияОповещения

Функция РазделительСобытияОповещения()
	
	Возврат "#";
	
КонецФункции

Функция ОбщийПрефиксСобытияОповещения(ИмяПодсистемы)
	
	Возврат 
		"ИнтеграцияИС_СобытиеОповещения" + РазделительСобытияОповещения()
		+ ИмяПодсистемы + РазделительСобытияОповещения();
	
КонецФункции

Функция ПрефиксСобытияИзмененОбъект()
	
	Возврат "ИзмененОбъект";
	
КонецФункции

Функция ПрефиксСобытияИзмененоСостояние()
	
	Возврат "ИзмененоСостояние";
	
КонецФункции

Функция ПрефиксСобытияВыполненОбмен()
	
	Возврат "ВыполненОбмен";
	
КонецФункции

#КонецОбласти

#Область Ошибки

// Добавляет в свойство структуры сообщения текст ошибки
//
// Параметры:
//  Сообщение    - Структура - сообщение, в которое добавляется текст ошибки.
//  ТекстОшибки  - Строка - добавляемый текст ошибки.
//
Процедура ДобавитьТекстОшибки(Сообщение, ТекстОшибки) Экспорт
	
	Если Сообщение.Ошибки.Получить(ТекстОшибки) <> Неопределено Тогда
		Возврат;
	Иначе
		Сообщение.Ошибки.Вставить(ТекстОшибки, Истина);
	КонецЕсли;
	
	Если Сообщение.ТекстОшибки = "" Тогда
		Сообщение.ТекстОшибки = ТекстОшибки;
	Иначе
		Сообщение.ТекстОшибки = Сообщение.ТекстОшибки + Символы.ПС + ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст для представления внутренней ошибки библиотек ГосИС.
//
// Параметры:
//  ПредставлениеПодсистемы  - Строка - представление интегрированной подсистемы
//  УточнениеОшибки - Строка - описание возникшей ошибки
//
// Возвращаемое значение:
//	Строка - дополненное описание ошибки
//
Функция ТекстОшибки(Знач ПредставлениеПодсистемы = "", Знач УточнениеОшибки) Экспорт
	
	ПредставлениеПодсистемы = ПредставлениеПодсистемы(ПредставлениеПодсистемы);
	
	ТекстОшибки = 
		СтрШаблон(НСтр("ru='Внутренняя ошибки библиотеки %1.'"),ПредставлениеПодсистемы)
		+ Символы.ПС
		+ УточнениеОшибки;
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ЗаменитьНечитаемыеСимволы(Знач ИсходнаяСтрока, ЗаменятьПробел = Истина, ЗаменятьНа = "") Экспорт
	
	НечитаемыеСимволы = Новый Массив();
	НечитаемыеСимволы.Добавить(Символы.ВК);
	НечитаемыеСимволы.Добавить(Символы.ВТаб);
	НечитаемыеСимволы.Добавить(Символы.НПП);
	НечитаемыеСимволы.Добавить(Символы.ПС);
	НечитаемыеСимволы.Добавить(Символы.ПФ);
	НечитаемыеСимволы.Добавить(Символы.Таб);
	НечитаемыеСимволы.Добавить(Символ(182)); // символ параграфа
	НечитаемыеСимволы.Добавить(Символ(176)); // символ градуса
	
	Если ЗаменятьПробел Тогда
		НечитаемыеСимволы.Добавить(" ");
	КонецЕсли;
	
	Для Каждого НечитаемыйСимвол Из НечитаемыеСимволы Цикл
		ИсходнаяСтрока = СтрЗаменить(ИсходнаяСтрока, НечитаемыйСимвол, ЗаменятьНа);
	КонецЦикла;
	
	Возврат ИсходнаяСтрока;
	
КонецФункции


#КонецОбласти

#КонецОбласти
