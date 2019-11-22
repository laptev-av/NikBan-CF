﻿&НаКлиенте
Перем СтарыйМагазин;

#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеВопросЗаполнениеТабличнойЧасти(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ОтчетыОРозничныхПродажах.Очистить();
		ЗавершитьЗаполнениеТабличнойЧасти();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВопросОчисткаТабличнойЧасти(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ОтчетыОРозничныхПродажах.Очистить();
	Иначе
		Объект.Магазин = СтарыйМагазин;
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
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект, КартинкаСостоянияДокумента, Элементы.КартинкаСостоянияДокумента.Подсказка, РазрешеноПроведение);
	
	НастроитьФормуПоДополнительнымПравам();
	
	ЗаполнитьСуммыСервер();
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, Элементы.КартинкаСостоянияДокумента.Подсказка, КартинкаСостоянияДокумента, РазрешеноПроведение);
	
	НастроитьФормуПоДополнительнымПравам();
	
	ЗаполнитьСуммыСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(Объект, Элементы.КартинкаСостоянияДокумента.Подсказка, КартинкаСостоянияДокумента, РазрешеноПроведение);
	
	// &ЗамерПроизводительности 
	ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	НастроитьФормуПоДополнительнымПравам();
	
	ЗаполнитьСуммыСервер();
	
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
	                                            "Документ.СводныйОтчетПоКассовойСмене.ФормаДокумента.Запись",
                                                           Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	
	Если Объект.ОтчетыОРозничныхПродажах.Количество() > 0  Тогда
	
		ТекстВопроса = НСтр("ru = 'Очистить табличную часть?'");
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросОчисткаТабличнойЧасти", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МагазинНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтарыйМагазин = Объект.Магазин;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтчетыОРозничныхПродажах

&НаКлиенте
Процедура ОтчетыОРозничныхПродажахОтчетОРозничныхПродажахПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтчетыОРозничныхПродажах.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		СтруктураСумм = СтруктураСуммВСтроке(СтрокаТаблицы.ОтчетОРозничныхПродажах);
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураСумм);
		ЗаполнитьПодвалКлиент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетыОРозничныхПродажахПослеУдаления(Элемент)
	
	ЗаполнитьПодвалКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧасть(Команда)
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Текст = НСтр("ru = 'Не выбрана организация!'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			Объект,
			"Объект.Организация",
			,
			Отказ
		);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Магазин) Тогда
		
		Текст = НСтр("ru = 'Не выбран магазин!'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			Объект,
			"Объект.Магазин",
			,
			Отказ
		);
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ОтчетыОРозничныхПродажах.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?'");
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросЗаполнениеТабличнойЧасти", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ЗавершитьЗаполнениеТабличнойЧасти();
	КонецЕсли;
	
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

&НаСервере
Процедура ЗаполнитьСуммыСервер()
	
	Для каждого СтрокаТаблицы Из Объект.ОтчетыОРозничныхПродажах Цикл
		
		СтруктураСумм = СтруктураСуммВСтроке(СтрокаТаблицы.ОтчетОРозничныхПродажах);
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураСумм);
		
	КонецЦикла;
	
	ЗаполнитьПодвалСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьНаСервере()

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДокументСсылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата"          , Объект.Дата);
	СтруктураПараметров.Вставить("Организация"   , Объект.Организация);
	СтруктураПараметров.Вставить("Магазин"       , Объект.Магазин);
	
	ДеревоОтчетов = РозничныеПродажиСервер.ПолучитьОтчетыОРозничныхПродажахДляСводногоОтчета(СтруктураПараметров);
	
	Если ДеревоОтчетов.Строки.Количество() > 0 Тогда
		
		Для каждого СтрокаОрганизации Из ДеревоОтчетов.Строки[0].Строки Цикл
			
			СтрокаТаблицы = Объект.ОтчетыОРозничныхПродажах.Добавить();
			
			СтрокаТаблицы.ОтчетОРозничныхПродажах = СтрокаОрганизации.ОтчетОРозничныхПродажах;
			СтруктураСумм = СтруктураСуммВСтроке(СтрокаТаблицы.ОтчетОРозничныхПродажах);
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураСумм);
			
		КонецЦикла;
		ЗаполнитьПодвалСервер();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоДополнительнымПравам()

	УправлениеПользователями.УстановитьТолькоПросмотрДляРеквизитовТабличнойЧасти(Элементы.Дата.ТолькоПросмотр, 
																				 ПланыВидовХарактеристик.ПраваПользователей.ИзменятьДату);

КонецПроцедуры

&НаСервере
Функция СтруктураСуммВСтроке(ОтчетОРозничныхПродажах)
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("СуммаДокумента", ОтчетОРозничныхПродажах.СуммаДокумента);
	СтруктураРезультат.Вставить("СуммаВозвратов", ОтчетОРозничныхПродажах.СуммаВозвратов);
	СтруктураРезультат.Вставить("СуммаПродажи",   СтруктураРезультат.СуммаДокумента + СтруктураРезультат.СуммаВозвратов);
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПодвалКлиент()
	
	СуммаПоДокументам = Объект.ОтчетыОРозничныхПродажах.Итог("СуммаДокумента");
	СуммаПродаж       = Объект.ОтчетыОРозничныхПродажах.Итог("СуммаПродажи");
	СуммаВозвратов    = Объект.ОтчетыОРозничныхПродажах.Итог("СуммаВозвратов");
	
	Элементы.ОтчетыОРозничныхПродажахСуммаДокумента.ТекстПодвала = Формат(Объект.ОтчетыОРозничныхПродажах.Итог("СуммаДокумента"), "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");
	Элементы.ОтчетыОРозничныхПродажахСуммаВозвратов.ТекстПодвала = Формат(Объект.ОтчетыОРозничныхПродажах.Итог("СуммаВозвратов"), "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");
	Элементы.ОтчетыОРозничныхПродажахСуммаПродажи.ТекстПодвала   = Формат(Объект.ОтчетыОРозничныхПродажах.Итог("СуммаПродажи"), "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодвалСервер()
	
	СуммаПоДокументам = Объект.ОтчетыОРозничныхПродажах.Итог("СуммаДокумента");
	СуммаПродаж       = Объект.ОтчетыОРозничныхПродажах.Итог("СуммаПродажи");
	СуммаВозвратов    = Объект.ОтчетыОРозничныхПродажах.Итог("СуммаВозвратов");
	
	Элементы.ОтчетыОРозничныхПродажахСуммаДокумента.ТекстПодвала = Формат(СуммаПоДокументам, "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");
	Элементы.ОтчетыОРозничныхПродажахСуммаВозвратов.ТекстПодвала = Формат(СуммаВозвратов   , "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");
	Элементы.ОтчетыОРозничныхПродажахСуммаПродажи.ТекстПодвала   = Формат(СуммаПродаж      , "ЧЦ=15; ЧДЦ=2; ЧГ=3,0");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗаполнениеТабличнойЧасти()
	
	ЗаполнитьТабличнуюЧастьНаСервере();
	
	Если Объект.ОтчетыОРозничныхПродажах.Количество() = 0 Тогда
		Текст = НСтр("ru = 'Все отчеты о розничных продажах включены в сводные отчеты.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			Объект,
			"Объект.ОтчетыОРозничныхПродажах",
		);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
КонецПроцедуры


#КонецОбласти