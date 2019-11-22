﻿&НаКлиенте
Перем мТекущийНомерСтраницы;

&НаКлиенте
Перем мСтраницыМастера;

&НаКлиенте
Перем мКнопкиМастера;

&НаКлиенте
Перем мДекорацииМастера;

#Область ПрограммныйИнтерфейс

// Процедура обработчик ответа на вопрос о подтверждении закрытия формы.
// Вызывается в результате немодального вопроса ПередЗакрытием формы.
&НаКлиенте
Процедура ОбработкаПодтвержденияЗакрытияФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытиеПодтверждено = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Процедура осуществляет обработку полученного кода 
// информационной карты от считывателя магнитных карт.
// Параметры: ДанныеКарты - Строка - Дорожка карты.
//
&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(МагнитныйКод, СтруктураРезультат) Экспорт
	
	ДанныеКарты = СтруктураРезультат.ПараметрыБезОбработки[1][1];
	
	Если мТекущийНомерСтраницы = 0 Тогда
		
		ДанныеПервойДорожки  =  ДанныеКарты[0];
		ДанныеВторойДорожки  =  ДанныеКарты[1];
		ДанныеТретьейДорожки =  ДанныеКарты[2];
		КодКарты = "";
		КомандаДалее(Неопределено);
		
	ИначеЕсли мТекущийНомерСтраницы = 3 Тогда
			
		ДанныеСчитаннойДорожки = ДанныеКарты[НомерДорожки-1];
		
		Если НЕ ПроверитьВхождениеВЗаданныйФормат(ДанныеСчитаннойДорожки) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Считанные данные карты не входят
                                                              |в заданный формат записи'"));
		Иначе
			
			ВыделенныйКодКарты = КодКартыПоФормату(ДанныеСчитаннойДорожки);
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыМастера.ОтображениеСтраниц          = ОтображениеСтраницФормы.Нет;
	Элементы.СтраницыДекорацииМастера.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Элементы.КнопкиМастера.ОтображениеСтраниц            = ОтображениеСтраницФормы.Нет;
	
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мТекущийНомерСтраницы = 0;
	
	ИнициализацияМастераНаКлиенте();
	
	УстановитьВидимостьНаКлиенте();
		
	УстановитьДоступностьКнопокМастера(Ложь);
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если мТекущийНомерСтраницы = 4 Тогда
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("НомерДорожки", НомерДорожки);
		ПараметрыЗаписи.Вставить("Префикс", Префикс);
		ПараметрыЗаписи.Вставить("Суффикс", Суффикс);
		ПараметрыЗаписи.Вставить("КоличествоЗнаков", КоличествоСимволов);
		
		Оповестить("СозданиеФорматаЗаписиКодаМагнитныхКарт", ПараметрыЗаписи);
		
		Возврат;
		
	КонецЕсли;
	
	СтрокаВопроса = НСтр("ru = 'Отменить настройку и выйти из помощника?'");
	
	Если НЕ ЗакрытиеПодтверждено Тогда
		
		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаПодтвержденияЗакрытияФормы", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОбработчикОповещения, СтрокаВопроса, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытиеПодтверждено = Истина;
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	Отказ = Ложь;
	
	КодКарты = Элементы.ДанныеПервойДорожки.ВыделенныйТекст
		+ Элементы.ДанныеВторойДорожки.ВыделенныйТекст
		+ Элементы.ДанныеТретьейДорожки.ВыделенныйТекст;
	
	ВыполнитьПроверкиПриНажатииДалее(Отказ);
	
	Если НЕ Отказ Тогда
		
		ВыполнитьДействияПриНажатииДалее(Отказ);
		
		ИзменитьНомерСтраницы(+1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьНомерСтраницы(-1);
		
	ВыполнитьДействияПриНажатииНазад();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСправка(Команда)
	
	ОткрытьСправкуФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПрефикс(Команда)
	
	Префикс = Элементы.ДанныеНужнойДорожки.ВыделенныйТекст;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСуффикс(Команда)
	
	Суффикс = Элементы.ДанныеНужнойДорожки.ВыделенныйТекст;
	
КонецПроцедуры

// Процедура формирует заново формат кода карты.
// Параметры: Отказ - Булево.
&НаКлиенте
Процедура СформироватьЗановоФорматКодаКарты(Команда)
	
	Отказ = Неопределено;
	
	КодКарты = Элементы.ДанныеНужнойДорожки.ВыделенныйТекст;
	
	СформироватьФорматКодаКарты(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура отрабатывает навигацию вперед. 
// Параметры: Отказ - Булево.
&НаКлиенте
Процедура ВыполнитьДействияПриНажатииДалее(Отказ)
	
	Если мТекущийНомерСтраницы = 1 Тогда
		
		СформироватьФорматКодаКарты(Отказ);
		
	ИначеЕсли мТекущийНомерСтраницы = 3 Тогда 
		
		СохранитьДанныеНастройки(Отказ);
		
	КонецЕсли;

КонецПроцедуры

// Процедура отрабатывает навигацию назад по помощнику 
// с очисткой переменных старших этапов.
&НаКлиенте
Процедура ВыполнитьДействияПриНажатииНазад()
	
	Если мТекущийНомерСтраницы = 0 Тогда
		
		КодКарты             = "";
		ДанныеПервойДорожки  = "";
		ДанныеВторойДорожки  = "";
		ДанныеТретьейДорожки = "";
		КоличествоСимволов   = 0;
		Префикс              = "";
		Суффикс              = "";
		ВыделенныйКодКарты   = "";
		ДанныеНужнойДорожки  = "";
		НомерДорожки         = 0;
		
	ИначеЕсли мТекущийНомерСтраницы = 1 Тогда
		
		КодКарты             = "";
		КоличествоСимволов   = 0;
		Префикс              = "";
		Суффикс              = "";
		ВыделенныйКодКарты   = "";
		ДанныеНужнойДорожки  = "";
		НомерДорожки         = 0;
		
		Элементы.ДанныеПервойДорожки.УстановитьГраницыВыделения(1,1);
		Элементы.ДанныеВторойДорожки.УстановитьГраницыВыделения(1,1);
		Элементы.ДанныеТретьейДорожки.УстановитьГраницыВыделения(1,1);
		
	ИначеЕсли мТекущийНомерСтраницы = 2 Тогда
		
		ВыделенныйКодКарты   = "";
		
	КонецЕсли;
		
КонецПроцедуры

// Процедура осуществляет проверки перед сменой этапы, страницы.
// Параметры: Отказ - Булево.
&НаКлиенте
Процедура ВыполнитьПроверкиПриНажатииДалее(Отказ)
	
	Если мТекущийНомерСтраницы = 0 Тогда 
		
		Если ПустаяСтрока(ДанныеПервойДорожки)
			И ПустаяСтрока(ДанныеВторойДорожки)
			И ПустаяСтрока(ДанныеТретьейДорожки)Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Данные от считывателя магнитных карт не были распознаны,
			|считайте карту повторно'"),,,,Отказ);
			
		КонецЕсли;
			
	ИначеЕсли мТекущийНомерСтраницы = 1 Тогда
		
		Если ПустаяСтрока(КодКарты) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выделите при помощи мыши искомую часть кода'"),,"КодКарты",,Отказ);
			
		КонецЕсли;
		
	ИначеЕсли мТекущийНомерСтраницы = 2 Тогда
		
		Если ПустаяСтрока(Префикс) 
			И ПустаяСтрока(Суффикс) 
			И КодКарты <> ДанныеНужнойДорожки Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Заполните поля ""Префикс"" или ""Суффикс"",
			|длина кода карты меньше, чем длина дорожки'"),,"ДанныеНужнойДорожки",,Отказ);
			
		КонецЕсли;
		
		Если (СтрДлина(Префикс + Суффикс) + КоличествоСимволов) > СтрДлина(ДанныеНужнойДорожки) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Длина полей ""Префикс"" и ""Суффикс""
			|превышает допустимую'"),,"Префикс",,Отказ);
			
		КонецЕсли;
		
		Если НЕ ПроверитьВхождениеВЗаданныйФормат(ДанныеНужнойДорожки) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Заданный код карты не входит
			|в заданный формат записи'"),,"КодКарты",,Отказ);
			
		КонецЕсли;
		
	ИначеЕсли мТекущийНомерСтраницы = 3 Тогда
		
		
		Если ВыделенныйКодКарты <> КодКарты Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Считанный по заданному формату код карты
			|не совпадает с ранее введенным'"),,"ВыделенныйКодКарты",,Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура изменяет номер страницы, изменяет отображение формы.
//
&НаКлиенте
Процедура ИзменитьНомерСтраницы(Итератор)
	
	// Изменяем номер текущей страницы.
	мТекущийНомерСтраницы = мТекущийНомерСтраницы + Итератор;
	
	УстановитьДоступностьКнопокМастера(Ложь);
	// Отображаем новую страницу мастера.
	УстановитьВидимостьНаКлиенте();
	
	УстановитьДоступностьКнопокМастера(Истина);
	
КонецПроцедуры

// Процедура устанавливает взаимосвязи элементов формы согласно сценарию работы мастера.
//
&НаКлиенте
Процедура ИнициализацияМастераНаКлиенте()
	
	// Инициализация переключения страниц мастера.
	мСтраницыМастера  = Новый Соответствие;
	мКнопкиМастера    = Новый Соответствие;
	мДекорацииМастера = Новый Соответствие;
	
	// СТРАНИЦЫ МАСТЕРА
	мСтраницыМастера.Вставить(0, Элементы.СтраницаМастераНачало);
	мСтраницыМастера.Вставить(1, Элементы.СтраницаМастераВыделениеКодаКарты);
	мСтраницыМастера.Вставить(2, Элементы.СтраницаМастераКорректировкаФормата);
	мСтраницыМастера.Вставить(3, Элементы.СтраницаМастераСчитываниеКодаКарты);
	мСтраницыМастера.Вставить(4, Элементы.СтраницаМастераОкончание);
	
	// КНОПКИ МАСТЕРА
	мКнопкиМастера.Вставить(0, Элементы.КнопкиНачала);
	мКнопкиМастера.Вставить(1, Элементы.КнопкиПродолжения);
	мКнопкиМастера.Вставить(2, Элементы.КнопкиПродолжения);
	мКнопкиМастера.Вставить(3, Элементы.КнопкиПродолжения);
	мКнопкиМастера.Вставить(4, Элементы.КнопкиОкончания);
	
	// КАРТИНКИ ДЕКОРАЦИИ БОКОВОЙ ПАНЕЛИ МАСТЕРА
	мДекорацииМастера.Вставить(0, Элементы.СтраницаДекорацииНачало);
	мДекорацииМастера.Вставить(1, Элементы.СтраницаДекорацииВыделениеКодаКарты);
	мДекорацииМастера.Вставить(2, Элементы.СтраницаДекорацииКорректировкаФормата);
	мДекорацииМастера.Вставить(3, Элементы.СтраницаДекорацииСчитываниеКода);
	мДекорацииМастера.Вставить(4, Элементы.СтраницаДекорацииГотово);

КонецПроцедуры

// Функция возвращает код карты с учетом данных дорожки, заданных суффикса и префикса.
// Возвращаемое значение - Строка.
//
&НаКлиенте
Функция КодКартыПоФормату(ДанныеСчитаннойДорожки)
	
	ОшибкаЧтения = Ложь;
	
	Если СтрДлина(Префикс) > 0 Тогда
		
		ПозицияНачалаКода = Найти(ДанныеСчитаннойДорожки, Префикс) + СтрДлина(Префикс);
		
		Если ПозицияНачалаКода < 2 Тогда
			
			ОшибкаЧтения = Истина;
			
		КонецЕсли;
		
	Иначе 
		
		ПозицияНачалаКода = 1;
		
	КонецЕсли;
	
	Если НЕ ОшибкаЧтения Тогда
		
		НайденныйКодКарты = Сред(ДанныеСчитаннойДорожки, ПозицияНачалаКода, КоличествоСимволов);
		
		Если  СтрДлина(Суффикс) > 0 Тогда
			
			СтрокаССуффиксом = Прав(ДанныеСчитаннойДорожки, СтрДлина(ДанныеСчитаннойДорожки) - (ПозицияНачалаКода  + КоличествоСимволов - 1));
			
			Если Найти(СтрокаССуффиксом, Суффикс) = 0 Тогда
				
				ОшибкаЧтения = Истина;
				НайденныйКодКарты = "";
				
			КонецЕсли;
				
		КонецЕсли;
		
	Иначе
		
		НайденныйКодКарты = "";
		
	КонецЕсли;
	
	Возврат НайденныйКодКарты;
	
КонецФункции

// Проверка вхождения данных карты в формат записи.
// Параметры: ДанныеКарты - Строка.
// Возвращаемое значение - Вхождение в формат - Булево.
//
&НаСервере
Функция ПроверитьВхождениеВЗаданныйФормат(ДанныеКарты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ДанныеКарты.ДанныеДорожки
	|ИЗ
	|	(ВЫБРАТЬ
	|		&ДанныеКарты КАК ДанныеДорожки) КАК ДанныеКарты
	|ГДЕ
	|	ДанныеКарты.ДанныеДорожки ПОДОБНО &ФорматЗаписи");
	Запрос.УстановитьПараметр("ДанныеКарты", ДанныеКарты);
	
	ФорматЗаписи = "%" + Префикс;
	
	Для Инд = 1 По КоличествоСимволов Цикл
		
		ФорматЗаписи = ФорматЗаписи + "_"
		
	КонецЦикла;
	
	ФорматЗаписи = ФорматЗаписи + Суффикс + "%";
	Запрос.УстановитьПараметр("ФорматЗаписи", ФорматЗаписи);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВходитВФормат = Истина;
		
	Иначе
		
		ВходитВФормат = Ложь;
		
	КонецЕсли;
	
	Возврат ВходитВФормат;
	
КонецФункции

// Процедура сохраняет данные в регистр сведений.
// Параметры - Отказ - Булево.
&НаСервере
Процедура СохранитьДанныеНастройки(Отказ)
		
	НачатьТранзакцию();
	
	Попытка
		
		Запись = РегистрыСведений.ФорматыЗаписиКодовМагнитныхКарт.СоздатьМенеджерЗаписи();
		Запись.КоличествоЗнаков = КоличествоСимволов;
		Запись.НомерДорожки     = НомерДорожки;
		Запись.Суффикс          = Суффикс;
		Запись.Префикс          = Префикс;
		Запись.Записать(Истина);
		
		ЗаписанФорматЗаписи = Истина;
		ЗафиксироватьТранзакцию();
		
		
	Исключение
		
		ЗаписанФорматЗаписи = Ложь;
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Помощник настройки формата записи кода карты'", "ru"), УровеньЖурналаРегистрации.Ошибка,,, ИнформацияОбОшибке());
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	КонецПопытки;

КонецПроцедуры

// Процедура формирует формат кода карты.
// Параметры - Отказ - Булево.
//
&НаКлиенте
Процедура СформироватьФорматКодаКарты(Отказ)
	
	НомерДорожки = 0;
	
	Если Найти(ДанныеПервойДорожки, КодКарты) > 0 Тогда
		
		НомерДорожки = 1;
		
	ИначеЕсли Найти(ДанныеВторойДорожки, КодКарты) > 0 Тогда	
		
		НомерДорожки = 2;
		
	ИначеЕсли Найти(ДанныеТретьейДорожки, КодКарты) > 0 Тогда		
		
		НомерДорожки = 3;
		
	КонецЕсли;
	
	Если НомерДорожки = 0 Тогда
		
		ТекстОшибки = НСтр("ru = 'Не удалось определить номер дорожки,
		                   |возможно неправильно введен код карты'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"КодКарты",,Отказ);
		
		Возврат;
		
	КонецЕсли;
		
	Если НомерДорожки = 1 Тогда
		
		ДанныеНужнойДорожки = ДанныеПервойДорожки;
		
	ИначеЕсли НомерДорожки = 2 Тогда
		
		ДанныеНужнойДорожки = ДанныеВторойДорожки;
		
	ИначеЕсли НомерДорожки = 3 Тогда
		
		ДанныеНужнойДорожки = ДанныеТретьейДорожки;
		
	КонецЕсли;
	
	КоличествоСимволов   = СтрДлина(КодКарты);
	
	ПозицияНачалаКода = Найти(ДанныеНужнойДорожки, КодКарты);
	ПозицияКонцаКода  = ПозицияНачалаКода + КоличествоСимволов;
	
	Префикс = "";
	// Префикс кода карты - до первой цифры.
	Если ПозицияНачалаКода <> 0 Тогда
		
		Для Инд = 1 По ПозицияНачалаКода - 1 Цикл
			
			Символ = Сред(ДанныеНужнойДорожки, Инд, 1);
			
			Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ) Тогда
				
				Префикс = Префикс + Символ;
				
			Иначе
				
				Префикс = "";
				
				Если Инд = ПозицияНачалаКода - 1 Тогда
					
					Префикс = Символ;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Суффикс = "";
	// Суффикс кода карты - до первой цифры.
	ДлинаДанныхДорожки = СтрДлина(ДанныеНужнойДорожки);
	
	Если ПозицияКонцаКода <> ДлинаДанныхДорожки + 1 Тогда
		
		Для Инд = ПозицияКонцаКода По ДлинаДанныхДорожки Цикл
			
			Символ = Сред(ДанныеНужнойДорожки, Инд, 1);
			
			Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ) Тогда
				
				Суффикс = Суффикс + Символ;
				
			Иначе
				
				Если Суффикс = "" Тогда
					
					Суффикс = Символ;
					
				КонецЕсли;
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает отображение формы на каждом этапе работы мастера.
//
&НаКлиенте
Процедура УстановитьВидимостьНаКлиенте()
	
	// Устанавливаем текущую страницу мастера.
	Элементы.СтраницыМастера.ТекущаяСтраница = мСтраницыМастера[мТекущийНомерСтраницы];
	
	// Устанавливаем текущую страницу кнопок мастера.
	Элементы.КнопкиМастера.ТекущаяСтраница = мКнопкиМастера[мТекущийНомерСтраницы];
	
	// Устанавливаем текущую страницу декорации мастера.
	Элементы.СтраницыДекорацииМастера.ТекущаяСтраница = мДекорацииМастера[мТекущийНомерСтраницы];
	
КонецПроцедуры

// Процедура изменяет доступность групп кнопок навигации.
// Параметры - ДоступностьКнопок - Булево.
&НаКлиенте
Процедура УстановитьДоступностьКнопокМастера(ДоступностьКнопок)
	
	Элементы.КнопкиНачала.Доступность      = ДоступностьКнопок;
	Элементы.КнопкиПродолжения.Доступность = ДоступностьКнопок;
	Элементы.КнопкиОкончания.Доступность   = ДоступностьКнопок;
	
КонецПроцедуры

#КонецОбласти
