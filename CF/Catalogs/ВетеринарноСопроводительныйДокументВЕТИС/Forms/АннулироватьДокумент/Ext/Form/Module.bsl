﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВетеринарноСопроводительныйДокумент", ВетеринарноСопроводительныйДокумент);
	Параметры.Свойство("ХозяйствующийСубъект", ХозяйствующийСубъект);
	Параметры.Свойство("Идентификатор", Идентификатор);
	
	Если ВетеринарноСопроводительныйДокумент.Пустая() 
		ИЛИ ХозяйствующийСубъект.Пустая()
		ИЛИ ПустаяСтрока(Идентификатор) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗаполнитьИменаСтраниц();
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГИСМ;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаЕГАИС;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	Если ТекущаяСтраница = Элемент.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		ВыполнениеЗаявкиВЕТИСНачало();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы] = "СтраницаИсходныеДанные" И ПустаяСтрока(ПричинаАннулирования) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо указать причину аннулирования ветеринарного сертификата.'"),,
			"ПричинаАннулирования");
		Возврат;
	КонецЕсли;
	
	Если ИменаСтраниц[ИндексСтраницы + 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(НадписьОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы - 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(НадписьОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВНачало(Команда)
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОшибкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящееСообщение") Тогда
		ПоказатьЗначение(, ИсходящееСообщение);
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящееСообщение") Тогда
		ПоказатьЗначение(, ВходящееСообщение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСНачало()
	
	ОчиститьСообщения();
	
	КоличествоЭлементов = 1000;
	
	РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросНаАннулированиеВетеринарногоСопроводительногоДокументаПоUUID(
		ХозяйствующийСубъект,
		Идентификатор,
		ПричинаАннулирования,
		УникальныйИдентификатор);
		
	ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСОкончание()
	
	ОповеститьОбИзменениях();
	ПоказатьУспешныйРезультатОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзменениях()
	
	Оповестить(
		ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы()),
		Новый Структура("Ссылка, ОбъектИзменен", ВетеринарноСопроводительныйДокумент, Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		ИсходящееСообщение = РезультатОбмена.Изменения[0].ИсходящееСообщение;
		СформироватьТекстОжидание();
	КонецЕсли;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатОбменаСВЕТИСЗавершение", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИСЗавершение(Изменения, ДополнительныеПараметры) Экспорт
	
	ДанныеДляОбработки = Неопределено;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ЗапросНаАннулированиеВСД") Тогда
			ДанныеДляОбработки = ЭлементДанных;
		ИначеЕсли ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросНаАннулированиеВСД") Тогда
			ДанныеДляОбработки = ЭлементДанных;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ДанныеДляОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВходящееСообщение = ДанныеДляОбработки.ВходящееСообщение;
	
	Если ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОтклонена")
		ИЛИ НЕ ПустаяСтрока(ДанныеДляОбработки.ТекстОшибки) Тогда
		ПоказатьОшибкуОбмена(ДанныеДляОбработки.ТекстОшибки);
	ИначеЕсли ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена") Тогда
		ВыполнениеЗаявкиВЕТИСОкончание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуОбмена(ТекстОшибки)
	
	Строки = Новый Массив();
	Если ЗначениеЗаполнено(ИсходящееСообщение) Тогда
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Иначе
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'")));
	КонецЕсли;
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'на аннулирование сертификата'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'завершился с'")));
	Строки.Добавить(" ");
	Если ЗначениеЗаполнено(ВходящееСообщение) Тогда
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибкой'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Иначе
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибкой'")));
	КонецЕсли;
	Строки.Добавить(":");
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
	
	НадписьОшибка = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьУспешныйРезультатОбмена()
	
	Строки = Новый Массив();
	
	Строки.Добавить(НСтр("ru = 'На'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'на аннулирование сертификата'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'получен'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ответ'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Строки.Добавить(".");
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'сертификат аннулирован.'")));
	
	ТекстРезультат = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаСтраниц()
	
	СтраницыФормы = Новый Массив();
	
	СтраницыФормы.Добавить("СтраницаИсходныеДанные");
	СтраницыФормы.Добавить("СтраницаЗапросОжидание");
	СтраницыФормы.Добавить("СтраницаЗапросОшибка");
	СтраницыФормы.Добавить("СтраницаЗапросРезультат");
	
	ИменаСтраниц = Новый ФиксированныйМассив(СтраницыФормы);
	
КонецПроцедуры // ЗаполнитьИменаСтраниц()

&НаКлиенте
Процедура СформироватьТекстОжидание()
	
	Строки = Новый Массив();
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'на аннулирование сертификата'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='передан в ВетИС.'")));
	Строки.Добавить(Символы.ПС);
	
	Строки.Добавить(Новый ФорматированнаяСтрока(
	       НСтр("ru = 'Получение ответа от сервера может занять продолжительное время.
	                  |Дождитесь ответа или закройте окно для продолжения
	                  |выполнения операции в фоновом режиме.'")));
	
	НадписьОжидание = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницуНавигации(Форма)
	
	СтраницыФормы     = Форма.Элементы.ГруппаСтраницы;
	СтраницыНавигации = Форма.Элементы.Навигация;
	
	ИндексСтраницы    = Форма.ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	КоличествоСтраниц = Форма.ИменаСтраниц.Количество();
	
	Если ИндексСтраницы = 0 Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияНачало;
		Форма.Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ИндексСтраницы = (КоличествоСтраниц - 1) Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОкончание;
		Форма.Элементы.ОкончаниеЗакрыть.КнопкаПоУмолчанию = Истина;
	ИначеЕсли СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОшибка;
		Форма.Элементы.ОшибкаНазад.КнопкаПоУмолчанию = Истина;
	Иначе
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияПродолжение;
		Если НЕ Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию Тогда
			Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
		Если СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
			Форма.Элементы.ПродолжениеДалее.Доступность = Ложь;
		Иначе
			Форма.Элементы.ПродолжениеДалее.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
