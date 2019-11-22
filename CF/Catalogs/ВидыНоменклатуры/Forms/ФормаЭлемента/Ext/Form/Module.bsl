﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаРазблокированияРеквизитовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
	
		ИндивидуальныеУпаковки = (Объект.НаборУпаковок = ПредопределенноеЗначение("Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры")
		Или Не ЗначениеЗаполнено(Объект.НаборУпаковок));
		Если НЕ Элементы.ЕдиницаИзмерения.ТолькоПросмотр Тогда
			Элементы.ЕдиницаИзмерения.ТолькоПросмотр = Не ИндивидуальныеУпаковки;
		КонецЕсли;
		УправлениеЭлементамиФормыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		// подсистема запрета редактирования ключевых реквизитов объектов
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
		
		УправлениеЭлементамиФормыНаСервере();
	КонецЕсли; 
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	ИменаРеквизитовДляОткрытияФормыНастройкаСоставаРеквизитовСерии =
		Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии("ОткрытиеФормыРедактирования");
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	РаботаСНоменклатурой.ПриСозданииНаСервереФормаВидаНоменклатуры(ЭтотОбъект, Элементы.ГруппаНаименование);
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	УстановитьПараметрыВыбораПравилаИменования();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	УправлениеЭлементамиФормыНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
		ТекущийОбъект.ШаблонЦенника = "";
		ТекущийОбъект.ШаблонЭтикетки = "";
		ТекущийОбъект.НаборСвойствХарактеристик = "";
	КонецЕсли;
	
	Если НЕ ТекущийОбъект.ИспользоватьХарактеристики Тогда
		ТекущийОбъект.ИспользованиеХарактеристик = Перечисления.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	УстановитьПараметрыВыбораПравилаИменования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	РаботаСНоменклатурой.ПриЗаписиНаСервереФормаВидаНоменклатуры(ЭтотОбъект, ТекущийОбъект, Отказ);
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура УправлениеЭлементамиФормыНаСервере()
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользованиеХарактеристик", "Доступность", Объект.ИспользоватьХарактеристики);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАлкогольнаяПродукция", "Видимость", Объект.АлкогольнаяПродукция);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаМеховыеИзделия", "Видимость", Объект.ПродукцияМаркируемаяДляГИСМ);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСерии", "Видимость", Объект.ИспользоватьСерии);
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкуИспользованияСерий()
	Если Объект.ПродукцияМаркируемаяДляГИСМ
		Или Объект.КиЗГИСМ Тогда
		
		Объект.ИспользоватьСерии = Истина;
		Объект.НастройкаИспользованияСерий   = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара;
		Объект.ИспользоватьНомерКИЗГИСМСерии = Истина;
		Объект.ИспользоватьНомерСерии        = НЕ Объект.КиЗГИСМ;
		Объект.ИспользоватьRFIDМеткиСерии    = Истина;
		
	ИначеЕсли Объект.ИспользоватьСерии Тогда
		Объект.НастройкаИспользованияСерий   = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара;
		Объект.ИспользоватьНомерКИЗГИСМСерии = Ложь;
		Объект.ИспользоватьНомерСерии        = Истина;
	Иначе
		Объект.НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Если Не Объект.АлкогольнаяПродукция Тогда
		Объект.АвтоматическиГенерироватьСерии      = Ложь;
		Объект.ИспользоватьДатуПроизводстваСерии   = Ложь;
		Объект.ИспользоватьПроизводителяЕГАИССерии = Ложь;
		Объект.ИспользоватьСправку2ЕГАИССерии      = Ложь;
	Иначе
		Объект.НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ПартияТоваров;
	КонецЕсли;
	
	Элементы.ИспользоватьСерии.Доступность = Не (Объект.ПродукцияМаркируемаяДляГИСМ
													Или Объект.КиЗГИСМ);
КонецПроцедуры


// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
			
	Если Не Объект.Ссылка.Пустая() Тогда
		ДополнительныеПараметры = Новый Структура;
		ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаРазблокированияРеквизитовЗавершение",
														ЭтотОбъект,
														ДополнительныеПараметры);
		ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект,
																							  ОбработчикОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьХарактеристикиПриИзменении(Элемент)
	
	Если Не Объект.ИспользоватьХарактеристики Тогда
		Объект.ИспользованиеХарактеристик = ПредопределенноеЗначение("Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать");
	Иначе
		Объект.ИспользованиеХарактеристик = ПредопределенноеЗначение("Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры");
	КонецЕсли;
	
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСерииПриИзменении(Элемент)
	
	ИспользоватьСерииПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИспользованияСерийПриИзменении(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	НастройкаИспользованияСерийПриИзмененииСервер(Результат, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаИспользованияСерийПриИзмененииСервер(Результат, ДополнительныеПараметры)
	
	ЗаполнитьЗначенияСвойств(Объект, Результат, Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии("СохранениеРезультатов")); 
	
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоИменованияСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("СозданиеПравилаИменованияЗавершение",ЭтаФорма);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбораВВидНоменклатуры",Истина);
	ПараметрыОткрытия.Вставить("ВидНоменклатуры",Объект.Ссылка);
	ПараметрыОткрытия.Вставить("Наименование",Объект.Наименование);
	ПараметрыОткрытия.Вставить("НаборыСвойств",Объект.НаборСвойств);
	
	ОткрытьФорму("Справочник.ПравилаИменованияНоменклатуры.Форма.ФормаЭлемента",ПараметрыОткрытия,ЭтаФорма,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ХранилищеШаблонов.Форма.ФормаВыбора.Открытие");

	ОбработчикОповещения = Новый ОписаниеОповещения("ШаблонЭтикеткиНачалоВыбораЗавершение", ЭтаФорма);
	
	ПараметрыОткрытия = Новый Структура();
	
	ТипыШаблонов = Новый Массив;
	ТипыШаблонов.Добавить(ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенник"));
	ТипыШаблонов.Добавить(ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток"));
	
	ПараметрыОткрытия.Вставить("Отбор", Новый Структура("ТипШаблона", ТипыШаблонов));
	
	ОткрытьФорму("Справочник.ХранилищеШаблонов.ФормаВыбора", ПараметрыОткрытия, ЭтаФорма,,,, ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЦенникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ХранилищеШаблонов.Форма.ФормаВыбора.Открытие");
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ШаблонЦенникаНачалоВыбораЗавершение", ЭтаФорма);
	
	ПараметрыОткрытия = Новый Структура();
	
	ТипыШаблонов = Новый Массив;
	ТипыШаблонов.Добавить(ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенник"));
	ТипыШаблонов.Добавить(ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток"));
	
	ПараметрыОткрытия.Вставить("Отбор", Новый Структура("ТипШаблона", ТипыШаблонов));
	
	ОткрытьФорму("Справочник.ХранилищеШаблонов.ФормаВыбора", ПараметрыОткрытия, ЭтаФорма,,,, ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборУпаковокПриИзменении(Элемент)
	НаборУпаковокПриИзмененииСервер();
	ИндивидуальныеУпаковки = (Объект.НаборУпаковок = ПредопределенноеЗначение("Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры")
	Или Не ЗначениеЗаполнено(Объект.НаборУпаковок));
	
	Элементы.ЕдиницаИзмерения.ТолькоПросмотр = Не ИндивидуальныеУпаковки;
КонецПроцедуры

&НаКлиенте
Процедура ТипНоменклатурыПриИзмененииКлиент(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ЗаполнитьЗначенияСвойств(Объект, Результат);
	ТипНоменклатурыПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьТипНоменклатурыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьТипНоменклатуры" Тогда
		ОписанияОповещения = Новый ОписаниеОповещения("ТипНоменклатурыПриИзмененииКлиент", ЭтотОбъект);
		
		ПараметрыФормы = Новый Структура("ТипНоменклатуры, ОсобенностьУчета, ПродаетсяВРозлив, ПризнакПредметаРасчета");
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, Объект);
		
		ОткрытьФорму("Перечисление.ТипыНоменклатуры.Форма.ВыборТипаНоменклатуры",
					ПараметрыФормы,
					ЭтотОбъект,
					,
					,
					,
					ОписанияОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИспользованияСерийОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "НастройкаИспользованияСерийОбработкаНавигационнойСсылки" Тогда
			
		ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаИспользованияСерийПриИзменении", ЭтотОбъект);
		
		ТекущиеРеквизиты = Новый Структура(ИменаРеквизитовДляОткрытияФормыНастройкаСоставаРеквизитовСерии);
		
		ЗаполнитьЗначенияСвойств(ТекущиеРеквизиты, Объект);
        
        // &ЗамерПроизводительности
	    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		         Истина, "Справочник.ВидыНоменклатуры.Форма.НастройкаСоставаРеквизитовСерии.Открытие");
 
		ОткрытьФорму("Справочник.ВидыНоменклатуры.Форма.НастройкаСоставаРеквизитовСерии",
					ТекущиеРеквизиты,
					ЭтотОбъект,
					,
					,
					,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПолитикиУчетаСерий

&НаКлиенте
Процедура ПолитикиУчетаСерийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ Элемент.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ПолитикиУчетаСерийСклад" Тогда
		ПоказатьЗначение(,ТекущиеДанные.Магазин);
	ИначеЕсли Поле.Имя = "ПолитикиУчетаСерийПолитикаУчетаСерий" Тогда
		ПоказатьЗначение(,ТекущиеДанные.ПолитикаУчетаСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолитикиУчетаСерийПолитикаУчетаСерийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ПолитикиУчетаСерий.Форма.ФормаВыбора.Открытие");

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

// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
&НаКлиенте
Процедура Подключаемый_НачалоВыбораРаботаСНоменклатурой(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ВыбратьОбъектСервиса(ЭтотОбъект, Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОчисткаРаботаСНоменклатурой(Элемент, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.НажатиеОчиститьКатегорию(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеРежимОбновления(Элемент)
	
	РаботаСНоменклатуройКлиент.НажатиеРежимОбновления(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРаботаСНоменклатурой(Элемент, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ОткрытКарточкуОбъектаСервиса(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой

&НаКлиенте
Процедура ВидАлкогольнойПродукцииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
	     	 Истина, "Справочник.ВидыАлкогольнойПродукции.Форма.ФормаВыбора.Открытие");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТипНоменклатурыПриИзмененииСервер()
	
	Если Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
		Объект.ИспользованиеХарактеристик = Перечисления.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать;
		Объект.ИспользоватьХарактеристики = Ложь;
	КонецЕсли;
	
	Если НЕ Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
		
		Если Объект.ИспользоватьСерии Тогда
			Объект.ИспользоватьСерии = Ложь;
		КонецЕсли;
		Если Объект.АлкогольнаяПродукция Тогда
			Объект.АлкогольнаяПродукция = Ложь;
		КонецЕсли;
		Если Объект.ПродаетсяВРозлив Тогда
			Объект.ПродаетсяВРозлив = Ложь;
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ВидАлкогольнойПродукцииЕГАИС) Тогда
			Объект.ВидАлкогольнойПродукцииЕГАИС = Справочники.ВидыАлкогольнойПродукции.ПустаяСсылка();
		КонецЕсли;
		Если Объект.ИмпортнаяАлкогольнаяПродукция Тогда
			Объект.ИмпортнаяАлкогольнаяПродукция = Ложь;
		КонецЕсли;
		Если Объект.ПродукцияМаркируемаяДляГИСМ Тогда
			Объект.ПродукцияМаркируемаяДляГИСМ = Ложь;
		КонецЕсли;
		
	Иначе
		
		Если Объект.АгентскиеУслуги Тогда
			Объект.АгентскиеУслуги = Ложь;
		КонецЕсли;
		
		Объект.АлкогольнаяПродукция         = Объект.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция;
		Объект.ПродукцияМаркируемаяДляГИСМ  = Объект.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ;
		Объект.КиЗГИСМ                      = Объект.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ;
		ОБъект.ПодконтрольнаяПродукцияВЕТИС = Объект.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС;
		
		УстановитьНастройкуИспользованияСерий();
		
		Если НЕ Объект.АлкогольнаяПродукция Тогда
			Объект.ИмпортнаяАлкогольнаяПродукция = Ложь;
			Объект.ВидАлкогольнойПродукцииЕГАИС = Справочники.ВидыАлкогольнойПродукции.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Объект.ИспользоватьСерии Тогда
		Объект.ПолитикиУчетаСерий.Очистить();
	КонецЕсли;
	
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ДоступностьЭлементов = Объект.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.ПодарочныйСертификат;
	Элементы.ИспользованиеХарактеристик.Доступность = ДоступностьЭлементов И Объект.ИспользоватьХарактеристики;
	
	// Тип номенклатуры
	МассивТекстов = Новый Массив;
	
	Если ЗначениеЗаполнено(Объект.ТипНоменклатуры) Тогда
		МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.ТипНоменклатуры),
																Новый Шрифт(,,Истина)));
	Иначе
		МассивТекстов.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = '<не указан>'"),
																Новый Шрифт(,,Истина),
																ЦветаСтиля.ЦветОсобогоТекста));
	КонецЕсли;
	
	Если Объект.ОсобенностьУчета <> Перечисления.ОсобенностиУчетаНоменклатуры.БезОсобенностейУчета Тогда
		МассивТекстов.Добавить(": ");
		МассивТекстов.Добавить(Строка(Объект.ОсобенностьУчета));
		Если Объект.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция И 
			Объект.ПродаетсяВРозлив Тогда
			МассивТекстов.Добавить(НСтр("ru = ' (Продается в розлив)'"));
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ТипНоменклатуры.ТолькоПросмотр Тогда
		ИзменитьТипНоменклатуры = "";
	ИначеЕсли ЗначениеЗаполнено(Объект.ТипНоменклатуры) Тогда
		ИзменитьТипНоменклатуры = Новый ФорматированнаяСтрока(НСтр("ru = 'Изменить'"),,,,"ИзменитьТипНоменклатуры");
	Иначе
		ИзменитьТипНоменклатуры = Новый ФорматированнаяСтрока(НСтр("ru = 'Указать'"),,,,"ИзменитьТипНоменклатуры");
	КонецЕсли;
	
	ТипНоменклатурыСтрокой = Новый ФорматированнаяСтрока(МассивТекстов);
	
	МассивТекстов = Новый Массив;
	МассивТекстов.Добавить(Перечисления.ТипыНоменклатуры.ПодсказкаПоТипуНоменклатуры(Объект.ТипНоменклатуры));
	МассивТекстов.Добавить(Перечисления.ОсобенностиУчетаНоменклатуры.ПодсказкаПоОсобенностиУчетаНоменклатуры(Объект.ОсобенностьУчета));
	
	Элементы.ИзменитьТипНоменклатуры.Подсказка = СтрСоединить(МассивТекстов, Символы.ПС);
	
	//Если Объект.ИспользоватьСерии Тогда
	//	МассивТекстов = Новый Массив;
	//	
	//	МассивТекстов.Добавить(НСтр("ru = 'Серия идентифицирует '"));
	//	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Экземпляр товара '"),
	//															Новый Шрифт(,,Истина)));
	//	
	//	МассивТекстов.Добавить(НСтр("ru = '(Номер, КиЗ, RFID-метка, срок годности с точностью до дней). '"));
	//	
	//	Если Не Элементы.ИспользоватьСерии.ТолькоПросмотр Тогда
	//		МассивТекстов.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Изменить'"),,,,"ИзменитьНастройкуИспользованияСерийСтрокой"));
	//	КонецЕсли;
	//	
	//	НастройкаИспользованияСерийСтрокой = Новый ФорматированнаяСтрока(МассивТекстов);
	//КонецЕсли;
	
	Если Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
		Элементы.СтраницыНаборыИШаблоны.ТекущаяСтраница = Элементы.СтраницаНаборыИШаблоны;
		Элементы.ГруппаПравилаУчетаПечать.Видимость = Истина;
		Элементы.АгентскиеУслуги.Видимость = Ложь;
		Элементы.ГруппаНастройкиХарактеристик.Видимость = Истина;
		Элементы.ИспользоватьСерии.Видимость = Истина;
		Элементы.НастройкаИспользованияСерий.Видимость = Объект.ИспользоватьСерии;
		Элементы.ТипСрокаДействия.Видимость = Ложь;
	ИначеЕсли Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда 
		Элементы.СтраницыНаборыИШаблоны.ТекущаяСтраница = Элементы.СтраницаТолькоНаборы;
		Элементы.ГруппаПравилаУчетаПечать.Видимость = Ложь;
		Элементы.АгентскиеУслуги.Видимость = Ложь;
		Элементы.ГруппаНастройкиХарактеристик.Видимость = Ложь;
		Элементы.НастройкаИспользованияСерий.Видимость = Ложь;
		Элементы.ИспользоватьСерии.Видимость = Ложь;
		Элементы.ТипСрокаДействия.Видимость = Истина;
	Иначе //Услуга
		Элементы.СтраницыНаборыИШаблоны.ТекущаяСтраница = Элементы.СтраницаНаборыИШаблоны;
		Элементы.ГруппаПравилаУчетаПечать.Видимость = Истина;
		Элементы.АгентскиеУслуги.Видимость = Истина;
		Элементы.ГруппаНастройкиХарактеристик.Видимость = Истина;
		Элементы.НастройкаИспользованияСерий.Видимость = Ложь;
		Элементы.ИспользоватьСерии.Видимость = Ложь;
		Элементы.ТипСрокаДействия.Видимость = Ложь;
	КонецЕсли;
	
	// Надпись использования серий
	#Область НадписьНастройкаИспользованияСерий
	
	Если Элементы.НастройкаИспользованияСерий.Видимость Тогда
		
		МассивТекстов = Новый Массив;
		
		МассивТекстов.Добавить(НСтр("ru = 'Серия идентифицирует'"));
		МассивТекстов.Добавить(" ");
		МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.НастройкаИспользованияСерий),
								Новый Шрифт(,,Истина)));
		
		МассивТекстов.Добавить(" (");
		
		МассивОписанияРеквизитов = Новый Массив;
		
		Если Объект.ИспользоватьНомерСерии Тогда
			МассивОписанияРеквизитов.Добавить(НСтр("ru = 'Номер'"));
		КонецЕсли;
		
		Если Объект.ИспользоватьСрокГодностиСерии Тогда
			
			Если Объект.ТочностьУказанияСрокаГодностиСерии = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоДней Тогда
				МассивОписанияРеквизитов.Добавить(НСтр("ru = 'Срок годности с точностью до дней'"));
			Иначе
				МассивОписанияРеквизитов.Добавить(НСтр("ru = 'Срок годности с точностью до часов'"));
			КонецЕсли;
		КонецЕсли;
		
		Если Объект.ИспользоватьRFIDМеткиСерии Тогда
			МассивОписанияРеквизитов.Добавить(НСтр("ru = 'RFID-метка'"));
		ИначеЕсли Объект.НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара Тогда
			МассивОписанияРеквизитов.Добавить(НСтр("ru = 'без RFID-метки'"));
		КонецЕсли;
		
		Если Объект.ИспользоватьНомерКИЗГИСМСерии Тогда
			МассивОписанияРеквизитов.Добавить(НСтр("ru = 'КиЗ'"));
		КонецЕсли;
			
		МассивТекстов.Добавить(СтрСоединить(МассивОписанияРеквизитов, ", "));
		МассивТекстов.Добавить(") ");
		
		Если Не Элементы.ИспользоватьСерии.ТолькоПросмотр Тогда
			МассивТекстов.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'изменить'"),
																,
																,
																,
																"НастройкаИспользованияСерийОбработкаНавигационнойСсылки"));
		КонецЕсли;													
		
		Элементы.НастройкаИспользованияСерий.Заголовок = Новый ФорматированнаяСтрока(МассивТекстов);
		
	КонецЕсли;

	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораПравилаИменования()
	
	РаботаСПравиламиИменования.УстановитьПараметрыВыбораПравилаИменования(Объект.НаборСвойств,Элементы.ПравилоИменования);
		
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат<>Неопределено Тогда
		Объект.ШаблонЭтикетки = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЦенникаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат<>Неопределено Тогда
		Объект.ШаблонЦенника = Результат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура отрабатывает изменение поля "Набор упаковок".
//
&НаСервере
Процедура НаборУпаковокПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Объект.НаборУпаковок)
		И Объект.НаборУпаковок <> Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры Тогда
		Объект.ЕдиницаИзмерения = Объект.НаборУпаковок.ЕдиницаИзмерения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьСерииПриИзмененииСервер()
	
	УстановитьНастройкуИспользованияСерий();
	
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеПравилаИменованияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.ПравилоИменования = Результат;
	КонецЕсли;
	УстановитьПараметрыВыбораПравилаИменования();
	
КонецПроцедуры

#КонецОбласти