﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект,
		КартинкаСостоянияДокумента,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		РазрешеноПроведение);
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Для каждого СотрудникиВедомости Из Объект.Зарплата Цикл
			СотрудникиВедомости.ОтметкаОВыплатеЗарплаты = Перечисления.ВариантыОтметокОВыплатеЗарплаты.НеВыплачено;
			СотрудникиВедомости.СуммаВыплаты = 0.00;
			СотрудникиВедомости.КомпенсацияЗаЗадержкуЗарплаты = 0.00;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьИтоговыеПоказатели();
		СтатусДокумента = Объект.Проведен;
		УстановитьДоступностьЭлементовПоПроведению();
	КонецЕсли;
	
	УправлениеДоступностьюРедактирования();
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ОбновитьИнформациюВыплаченнойЗарплатыДляСпискаРаботников();
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, Элементы.КартинкаСостоянияДокумента.Подсказка, КартинкаСостоянияДокумента, РазрешеноПроведение);
	ОбновитьИтоговыеПоказатели();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьИнформациюВыплаченнойЗарплатыДляСпискаРаботников();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненаВыплатаРКО" Тогда
		ОбновитьИнформациюВыплаченнойЗарплатыДляСпискаРаботников();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Ответственный.Пустая() Тогда
		ТекущийОбъект.Ответственный = Пользователи.ТекущийПользователь()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененаПлатежнаяВедомость");
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, Элементы.КартинкаСостоянияДокумента.Подсказка, КартинкаСостоянияДокумента, РазрешеноПроведение);
	
	// &ЗамерПроизводительности	
	ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// &ЗамерПроизводительности 
	Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
	                                            "Документ.ЗарплатаКВыплатеОрганизаций.ФормаДокумента.Запись",
                                                           Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	Объект.ПериодРегистрации = НачалоМесяца(Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗарплата

&НаКлиенте
Процедура ЗарплатаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ЗарплатаРКО" И ЗначениеЗаполнено(Элемент.ТекущиеДанные.РКО) Тогда
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.РКО);
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", ПараметрыФормы);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элементы.Зарплата.ТекущиеДанные.ФизЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
		Элементы.Зарплата.ТекущиеДанные.ОтметкаОВыплатеЗарплаты = ПредопределенноеЗначение("Перечисление.ВариантыОтметокОВыплатеЗарплаты.НеВыплачено");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ПоВедомостиЕстьВыплаты Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПередУдалением(Элемент, Отказ)
	
	Если Элементы.Зарплата.ТекущиеДанные.ФлагРКО = ИСТИНА ИЛИ ПоВедомостиЕстьВыплаты Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПриИзменении(Элемент)
	
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьВыплаченоНеДепонированнойЗарплате(Команда)
	
	УстановкаОтметкуОВыплатеЗарплатыВСпискеРаботников(ПредопределенноеЗначение("Перечисление.ВариантыОтметокОВыплатеЗарплаты.Выплачено"));
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметкуДепонировать(Команда)
	
	УстановкаОтметкуОВыплатеЗарплатыВСпискеРаботников(ПредопределенноеЗначение("Перечисление.ВариантыОтметокОВыплатеЗарплаты.Депонировано"));
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	СтатусДокумента = Не СтатусДокумента;
	УстановитьДоступностьЭлементовПоПроведению();
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

// Процедура получает информацию была ли выплачена зарплата работнику по ведомости.
// Если зарплата уже выплачена, то строка в документе с этим работником должна быть не доступна для редактирования.
//
&НаСервере
Процедура ОбновитьИнформациюВыплаченнойЗарплатыДляСпискаРаботников()
	
	МассивРезультатовЗапросов = Документы.ЗарплатаКВыплатеОрганизаций.ДанныеОВыплатеПоВедомости(Объект);
	Выборка = МассивРезультатовЗапросов[1].Выбрать();
	ВыборкаВедомостьОплачена = МассивРезультатовЗапросов[2].Выбрать();
	
	ПоВедомостиЕстьВыплаты = Ложь;
	Для итератор = 0 По Выборка.Количество() - 1 Цикл
		Выборка.Следующий();
		ПоВедомостиЕстьВыплаты = ?(ПоВедомостиЕстьВыплаты = Истина, ПоВедомостиЕстьВыплаты, Выборка.ФлагРКО);
		ЭлементФормыСтрока = Объект.Зарплата.Получить(итератор);
		ЭлементФормыСтрока.ФлагРКО = Выборка.ФлагРКО;
		ЭлементФормыСтрока.РКО = Выборка.РКО;
	КонецЦикла;
	Элементы.КоманднаяПанельЗарплатаВсеДействия.Доступность = НЕ ПоВедомостиЕстьВыплаты;
	Элементы.КоманднаяПанельЗарплата.Доступность = НЕ ПоВедомостиЕстьВыплаты;
	ЭтотОбъект.ТолькоПросмотр = Ложь;
	Если ВыборкаВедомостьОплачена.Следующий() Тогда
		Если ВыборкаВедомостьОплачена.ВедомостьОплаченаПолностью Тогда
			Элементы.ЗарплатаОтметкаОВыплатеЗарплатыДепонировано.Доступность = Ложь;
			Элементы.ЗарплатаДепонировать.Доступность = Ложь;
			ЭтотОбъект.ТолькоПросмотр = Объект.Проведен;
			Если НЕ Объект.Проведен Тогда
				СтатусДокумента = Истина;
				УстановитьДоступностьЭлементовПоПроведению();
			КонецЕсли;
			ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
		Иначе
			Элементы.ЗарплатаОтметкаОВыплатеЗарплатыДепонировано.Доступность = Истина;
			Элементы.ЗарплатаДепонировать.Доступность = Истина;
			Если ВыборкаВедомостьОплачена.ВедомостьОплаченаНеПолностью Тогда
				СтатусДокумента = Истина;
				УстановитьДоступностьЭлементовПоПроведению();
				ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
			Иначе
				СтатусДокумента = Объект.Проведен;
				УстановитьДоступностьЭлементовПоПроведению();
			КонецЕсли; 
		КонецЕсли;
	Иначе
		Элементы.ЗарплатаОтметкаОВыплатеЗарплатыДепонировано.Доступность = Истина;
		Элементы.ЗарплатаДепонировать.Доступность = Истина;
		СтатусДокумента = Объект.Проведен;
		УстановитьДоступностьЭлементовПоПроведению();
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает для строк ведомости отметку о выплате зарплаты.
// 
&НаКлиенте
Процедура УстановкаОтметкуОВыплатеЗарплатыВСпискеРаботников(ВыбранноеЗначение)
	
	Для каждого СтрокаТЧ Из Объект.Зарплата Цикл
		
		Если СтрокаТЧ.ОтметкаОВыплатеЗарплаты = ПредопределенноеЗначение("Перечисление.ВариантыОтметокОВыплатеЗарплаты.НеВыплачено")
			ИЛИ НЕ ЗначениеЗаполнено(СтрокаТЧ.ОтметкаОВыплатеЗарплаты) Тогда
			
			СтрокаТЧ.ОтметкаОВыплатеЗарплаты = ВыбранноеЗначение;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюРедактирования()

	Если Пользователи.РолиДоступны("ИзменениеЗарплатыКВыплатеОрганизаций") 
	И НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеЗарплатыКВыплатеОрганизаций")
	И НЕ Пользователи.РолиДоступны("ПолныеПрава") Тогда
		
		НаименованиеГруппыДляКнопкиЗапрета = Элементы.ГруппаНевидимая;
		
		ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Зарплата", "ИзменятьСоставСтрок", Ложь);
		ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Зарплата", "ИзменятьПорядокСтрок", Ложь);
		
		МассивЭлементов = Новый Массив;
		МассивЭлементов.Добавить("ФлагРКО");
		МассивЭлементов.Добавить("ЗарплатаФизлицо");
		МассивЭлементов.Добавить("ЗарплатаСумма");
		МассивЭлементов.Добавить("ЗарплатаКомпенсацияЗаЗадержкуЗарплаты");
		МассивЭлементов.Добавить("ЗарплатаРКО");
		МассивЭлементов.Добавить("ЗарплатаТабельныйНомер");
		МассивЭлементов.Добавить("Ответственный");
		МассивЭлементов.Добавить("Магазин");
		МассивЭлементов.Добавить("Организация");
		МассивЭлементов.Добавить("Дата");
		МассивЭлементов.Добавить("ПериодРегистрации");
		
		ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
		ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоговыеПоказатели()
	
	ТаблицаВыплат = Объект.Зарплата.Выгрузить(, "ОтметкаОВыплатеЗарплаты, Сумма");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаВыплат.ОтметкаОВыплатеЗарплаты КАК ОтметкаОВыплатеЗарплаты,
		|	ТаблицаВыплат.Сумма КАК Сумма
		|ПОМЕСТИТЬ ЗарплатаКВыплатеОрганизацийЗарплата
		|ИЗ
		|	&ТаблицаВыплат КАК ТаблицаВыплат
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ОтметкаОВыплатеЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОтметокОВыплатеЗарплаты.Выплачено)
		|				ТОГДА ЗарплатаКВыплатеОрганизацийЗарплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Выплачено,
		|	СУММА(ВЫБОР
		|			КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ОтметкаОВыплатеЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОтметокОВыплатеЗарплаты.НеВыплачено)
		|				ТОГДА ЗарплатаКВыплатеОрганизацийЗарплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК НеВыплачено,
		|	СУММА(ВЫБОР
		|			КОГДА ЗарплатаКВыплатеОрганизацийЗарплата.ОтметкаОВыплатеЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОтметокОВыплатеЗарплаты.Депонировано)
		|				ТОГДА ЗарплатаКВыплатеОрганизацийЗарплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Депонировано
		|ИЗ
		|	ЗарплатаКВыплатеОрганизацийЗарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата";
		
	Запрос.УстановитьПараметр("ТаблицаВыплат", ТаблицаВыплат);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Выплачено = 0;
		НеВыплачено = 0;
		Депонировано = 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Выплачено = Выборка.Выплачено;
		НеВыплачено = Выборка.НеВыплачено;
		Депонировано = Выборка.Депонировано;
		
	КонецЕсли;
	

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоПроведению()
	
	ТолькоПросмотрЭлементов = СтатусДокумента;
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("Магазин");
	МассивЭлементов.Добавить("Организация");
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("ПериодРегистрации");
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", ТолькоПросмотрЭлементов);
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", ТолькоПросмотрЭлементов);
КонецПроцедуры



#КонецОбласти