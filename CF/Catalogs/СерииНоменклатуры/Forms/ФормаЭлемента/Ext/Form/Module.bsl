﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ВидНоменклатуры) Тогда
		Элементы.ВидНоменклатуры.ТолькоПросмотр = Ложь;
		Возврат;
	КонецЕсли;
		
	Элементы.ВидНоменклатуры.ТолькоПросмотр = Истина;
	УстановитьНастройкиПоШаблону();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("Номер", Объект.Номер);
	СтруктураОповещения.Вставить("ГоденДо", Объект.ГоденДо);
	
	Оповестить("Запись_СерииНоменклатуры", СтруктураОповещения, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	УстановитьНастройкиПоШаблону();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьНастройкиПоШаблону()
	ПараметрыШаблона = Новый ФиксированнаяСтруктура(
		ЗначениеНастроекПовтИсп.ПараметрыСерийНоменклатуры(Объект.ВидНоменклатуры));
	
	Элементы.ГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
	Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
		Элементы.ГоденДо.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		Элементы.ГоденДо.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
		
	Если ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии Тогда
		Элементы.ДатаПроизводства.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		Элементы.ДатаПроизводства.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
	
	Элементы.Номер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
	
	МожноМенятьНомер = НЕ ПараметрыШаблона.ИспользоватьRFIDМеткиСерии
						Или НЕ ((ЗначениеЗаполнено(Объект.RFIDTID)
							Или ЗначениеЗаполнено(Объект.RFIDEPC))
						И НЕ Объект.RFIDМеткаНеЧитаемая);

	Элементы.Номер.ТолькоПросмотр = Не МожноМенятьНомер;
	
	Элементы.НомерКИЗГИСМ.Видимость = ПараметрыШаблона.ИспользоватьНомерКИЗГИСМСерии;
	
	Элементы.RFIDTID.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDUser.Видимость = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDEPC.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.EPCGTIN.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDМеткаНеЧитаемая.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	
	Элементы.RFIDTID.ТолькоПросмотр  = Истина;
	Элементы.RFIDUser.ТолькоПросмотр = Истина;
	Элементы.RFIDEPC.ТолькоПросмотр  = Истина;
	Элементы.EPCGTIN.ТолькоПросмотр  = Истина;
	Элементы.RFIDМеткаНеЧитаемая.ТолькоПросмотр = Истина;
	
	Элементы.ДатаПроизводства.Видимость   = ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии;
	Элементы.ПроизводительЕГАИС.Видимость = ПараметрыШаблона.ИспользоватьПроизводителяЕГАИССерии;
	Элементы.Справка2ЕГАИС.Видимость      = ПараметрыШаблона.ИспользоватьСправку2ЕГАИССерии;
	
КонецПроцедуры

#КонецОбласти