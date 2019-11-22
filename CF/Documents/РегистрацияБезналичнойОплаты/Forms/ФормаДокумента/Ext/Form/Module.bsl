﻿
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеВопросПроведениеПередПечатьюЧека(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Попытка
			Если ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение)) Тогда
				НапечататьЧекКлиент();
			КонецЕсли;
		Исключение
			ПоказатьПредупреждение(,НСтр("ru = 'Не удалось выполнить проведение документа'"));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПробитьЧекЗавершение(РезультатВыполнения, ПараметрыОперации) Экспорт
	
	ЭтаФорма.Доступность = Истина;
	
	Если РезультатВыполнения.Результат Тогда
		
		// Установить полученное значение номера чека реквизиту документа.
		Если ЗначениеЗаполнено(РезультатВыполнения.ВыходныеПараметры[1]) Тогда
			Объект.НомерЧекаККМ = РезультатВыполнения.ВыходныеПараметры[1];
		Иначе
			Объект.НомерЧекаККМ = НомерДокументаКассыККМ[Объект.КассаККМ];
		КонецЕсли; 
		Объект.ПробитЧек    = Истина;
		Модифицированность  = Ложь;
		
		РезультатЗаписи = Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		Если РезультатЗаписи = Истина Тогда
			НомерДокументаКассыККМ[Объект.КассаККМ] = Объект.НомерЧекаККМ +	1;
			ПорядковыйНомерПродажи = ПорядковыйНомерПродажи + 1;
		КонецЕсли;
		
	Иначе
		ТекстСообщения = НСтр("ru = 'При печати чека произошла ошибка.
									|Чек не напечатан на фискальном устройстве.
									|Дополнительное описание: %ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
    
    // &ЗамерПроизводительности 
    ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыОперации.Замер);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект, КартинкаСостоянияДокумента, Элементы.КартинкаСостоянияДокумента.Подсказка, РазрешеноПроведение);
	
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(Объект.ХозяйственнаяОперация);
	
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
	ОграничитьТипОплаченныхДокументов();
	
	УправлениеЭлементамиФормы();
	
	ЗаполнениеПризнаковСпособовРасчета();
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ЗначениеЗаполнено(Объект.КассаККМ) И НомерДокументаКассыККМ[Объект.КассаККМ] = Неопределено Тогда
		ОбщегоНазначенияРТКлиент.ЗаполнитьНомерДокументаКассыККМ(Объект.КассаККМ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, Элементы.КартинкаСостоянияДокумента.Подсказка, КартинкаСостоянияДокумента, РазрешеноПроведение);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	 УправлениеЭлементамиФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, Элементы.КартинкаСостоянияДокумента.Подсказка, КартинкаСостоянияДокумента, РазрешеноПроведение);
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНеоплаченныхДокументов.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНеоплаченныхДокументов(ВыбранноеЗначение);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		
		Окно.Активизировать();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// &ЗамерПроизводительности
	Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
	                                            "Документ.РегистрацияБезналичнойОплаты.ФормаДокумента.Запись",
                                                          Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КассаККМПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КассаККМ) И НомерДокументаКассыККМ[Объект.КассаККМ] = Неопределено Тогда
		ОбщегоНазначенияРТКлиент.ЗаполнитьНомерДокументаКассыККМ(Объект.КассаККМ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнениеПризнаковСпособовРасчета();
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТабличнойЧастиРасшифровкаПлатежа

&НаКлиенте
Процедура РасшифровкаПлатежаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		Элемент.ТекущиеДанные.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ЗаполнениеПризнаковСпособовРасчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ИтогоПриИзменении(Элемент)
	
	ЗаполнениеПризнаковСпособовРасчета();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьНеОплаченные(Команда)
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(Объект.Магазин)
		ИЛИ НЕ ЗначениеЗаполнено(Объект.Контрагент)
		ИЛИ НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ОчиститьСообщения();
		СообщитьОбОшибкахОткрытияПодбора(Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.РасшифровкаПлатежа.Количество() > 0 Тогда
		АдресХранилищаРасшифровкаПлатежа = ПоместитьВХранилищеРасшифровкуПлатежа();
	Иначе
		АдресХранилищаРасшифровкаПлатежа = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Магазин", 		Объект.Магазин);
	ПараметрыФормы.Вставить("Контрагент", 	Объект.Контрагент);
	ПараметрыФормы.Вставить("Организация", 	Объект.Организация);
	ПараметрыФормы.Вставить("ФормаОплаты", 	ПредопределенноеЗначение("Перечисление.ФормыОплаты.Безналичная"));
	ПараметрыФормы.Вставить("Операция", 	Объект.ХозяйственнаяОперация);
	ПараметрыФормы.Вставить("АдресХранилищаРасшифровкаПлатежа", АдресХранилищаРасшифровкаПлатежа);
	ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
	
	ОткрытьФорму("Обработка.ПодборНеоплаченныхДокументов.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);

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

&НаКлиенте
Процедура НапечататьЧек(Команда)
	
	Если Объект.ПробитЧек Тогда
		ТекстСообщения = НСтр("ru = 'Чек уже пробит на фискальном регистраторе!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросПроведениеПередПечатьюЧека", ЭтотОбъект);
	
	Если ФинансыКлиент.ПроверитьВозможностьПечатиЧека(ОбработчикОповещения, ЭтотОбъект) Тогда
		НапечататьЧекКлиент();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ОграничитьТипОплаченныхДокументов()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
		Элементы.РасшифровкаПлатежаДокументРасчета.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
		Элементы.РасшифровкаПлатежаДокументРасчета.ВыбиратьТип = Ложь;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику Тогда 
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеТоваров"));
		Элементы.РасшифровкаПлатежаДокументРасчета.ВыбиратьТип = Истина;
		
		Элементы.РасшифровкаПлатежаДокументРасчета.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
	ИНачеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда 
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваров"));
		Элементы.РасшифровкаПлатежаДокументРасчета.ВыбиратьТип = Истина;
		
		Элементы.РасшифровкаПлатежаДокументРасчета.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
		ЭтоРасчетСКлиентом = Истина;
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда 
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтПокупателя"));
		Элементы.РасшифровкаПлатежаДокументРасчета.ВыбиратьТип = Истина;
		
		Элементы.РасшифровкаПлатежаДокументРасчета.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
		ЭтоРасчетСКлиентом = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура сообщает о необходимости заполнения реквизитов документа при вызове подбора.
// Параметры:
//	Отказ - Булево
&НаКлиенте
Процедура СообщитьОбОшибкахОткрытияПодбора(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Объект.Магазин) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Магазин"" не заполнено'"), Объект, "Объект.Магазин",,Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Контрагент"" не заполнено'"), Объект, "Объект.Контрагент",,Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Организация"" не заполнено'"), Объект, "Объект.Организация",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНеоплаченныхДокументов(ВыбранноеЗначение)
	
	ТаблицаДокументов = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресКорзиныВХранилище);
	Объект.РасшифровкаПлатежа.Очистить();
	
	Для каждого Строка Из ТаблицаДокументов Цикл
		
		НоваяСтрока = Объект.РасшифровкаПлатежа.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		Если НЕ ЗначениеЗаполнено(НоваяСтрока.СтатьяДвиженияДенежныхСредств) Тогда
			НоваяСтрока.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ТолькоПросмотр = ТолькоПросмотр ИЛИ Объект.ПробитЧек;
	
	Элементы.ДокументОснование.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	Элементы.РасшифровкаПлатежаПризнакСпособаРасчета.ТолькоПросмотр = НЕ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту;
	
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеРасходы 
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы Тогда
		Элементы.РасшифровкаПлатежаДокументРасчета.Видимость = Ложь;
		Элементы.РасшифровкаПлатежаПодобратьНеОплаченные.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		И Не Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда 
		Элементы.ФормаНапечататьЧек.Видимость 						= Ложь;
		Элементы.РасшифровкаПлатежаПризнакСпособаРасчета.Видимость 	= Ложь;
		Элементы.СтраницаЧекККМ.Видимость 							= Ложь;
		Элементы.ВидНалога.Видимость 								= Ложь;
	КонецЕсли;
	
	Элементы.ФормаНапечататьЧек.Доступность = Не Объект.ПробитЧек;

КонецПроцедуры

&НаСервере
Функция ПоместитьВХранилищеРасшифровкуПлатежа()

	РасшифровкаПлатежа = Объект.РасшифровкаПлатежа.Выгрузить();
	
	Адрес = ПоместитьВоВременноеХранилище(РасшифровкаПлатежа, УникальныйИдентификатор);
	
	Возврат Адрес;

КонецФункции

&НаКлиенте
Процедура НапечататьЧекКлиент()
	
	Перем Отказ, ПараметрыКассыККМ; 
		
	ПодготовитьИПроверитьПечатьЧека(Отказ, ПараметрыКассыККМ);
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ ИспользоватьПодключаемоеОборудование ИЛИ ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования Тогда
		
		Если НомерДокументаКассыККМ[Объект.КассаККМ] <> Неопределено Тогда
			Объект.НомерЧекаККМ  = НомерДокументаКассыККМ[Объект.КассаККМ];
		Иначе
			Объект.НомерЧекаККМ  = ПорядковыйНомерПродажи;
		КонецЕсли; 
		Объект.ПробитЧек     = Истина;
		Модифицированность = Ложь;
		
		РезультатЗаписи = Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
		
		Если РезультатЗаписи = Истина Тогда
			НомерДокументаКассыККМ[Объект.КассаККМ] = Объект.НомерЧекаККМ + 1;
			ПорядковыйНомерПродажи = ПорядковыйНомерПродажи + 1;
		КонецЕсли;
		
	Иначе
		НомерЧека = НомерДокументаКассыККМ[Объект.КассаККМ] + 1;
		ПробитьЧек(ПараметрыКассыККМ, НомерЧека);
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьИПроверитьПечатьЧека(Отказ, ПараметрыКассыККМ)
	
	Отказ = Ложь;
	
	Если ЗначениеЗаполнено(Объект.КассаККМ)  Тогда
		ПараметрыКассыККМ = ЗначениеНастроекВызовСервера.ПолучитьПараметрыКассыККМ(Объект.КассаККМ);
		ПараметрыКассыККМ.Вставить("УстройствоПодключено", Ложь);
		ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования
																	ИЛИ НЕ ИспользоватьПодключаемоеОборудование;
		
		СтруктураСостояниеКассовойСмены = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(Объект.КассаККМ);
		
		КассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
		
		ТекстОшибки = НСтр("ru='Кассовая смена не открыта!'");
		Если НЕ РозничныеПродажиСервер.СменаОткрыта(КассоваяСмена, Объект.Дата, ТекстОшибки) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Объект.КассаККМ", , Отказ);
			
		КонецЕсли;
	Иначе
		ТекстОшибки = НСтр("ru='Не выбрана касса ККМ!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Объект.КассаККМ", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПробитьЧек(ПараметрыКассыККМ, НомерЧека)
    
    // &ЗамерПроизводительности 
    Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
                                                    "Документ.РегистрацияБезналичнойОплаты.Форма.ФормаДокумента.Команда.ПробитьЧек",
                                                               Ложь);

	ЭтаФорма.Доступность = Ложь;
	
	// Готовим данные
	ОбщиеПараметры  = ВходящиеДанныеДляФРСервер(ПараметрыКассыККМ.РаспределениеВыручкиПоСекциям, НомерЧека);
    
    ДополнительныеПараметры = Новый Структура;
    ДополнительныеПараметры.Вставить("Замер", Замер);
    
    Оповещение = Новый ОписаниеОповещения("ПробитьЧекЗавершение", ЭтотОбъект, ДополнительныеПараметры);
    
	МенеджерОборудованияКлиент.НачатьФискализациюЧекаНаФискальномУстройстве(Оповещение, 
									УникальныйИдентификатор, 
									ОбщиеПараметры, 
									ПараметрыКассыККМ.ИдентификаторУстройства);
	
КонецПроцедуры
								
&НаСервере
Функция ВходящиеДанныеДляФРСервер(РаспределениеВыручкиПоСекциям, НомерЧека)
	
	Возврат Документы.РегистрацияБезналичнойОплаты.ПодготовитьДанныеДляПробитияЧека(Объект.Ссылка, РаспределениеВыручкиПоСекциям, НомерЧека);
	
КонецФункции

&НаСервере
Процедура ЗаполнениеПризнаковСпособовРасчета()
	
	Документы.РегистрацияБезналичнойОплаты.ЗаполнениеПризнаковСпособовРасчета(Объект);
	
КонецПроцедуры

#КонецОбласти
