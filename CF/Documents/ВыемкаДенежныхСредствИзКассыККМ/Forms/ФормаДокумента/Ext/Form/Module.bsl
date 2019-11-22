﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	НастроитьФормуПоДополнительнымПравам();
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект,
		КартинкаСостоянияДокумента,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		РазрешеноПроведение
	);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение
	);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение
	);
	
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
	                                            "Документ.ВыемкаДенежныхСредствИзКассыККМ.ФормаДокумента.Запись",
                                                          Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

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
Процедура НастроитьФормуПоДополнительнымПравам()

	УправлениеПользователями.УстановитьТолькоПросмотрДляРеквизитовТабличнойЧасти(Элементы.Дата.ТолькоПросмотр, 
																				 ПланыВидовХарактеристик.ПраваПользователей.ИзменятьДату);

КонецПроцедуры

#КонецОбласти