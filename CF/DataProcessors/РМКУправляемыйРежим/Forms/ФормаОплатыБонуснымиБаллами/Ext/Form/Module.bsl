﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоСимволовПослеЗапятой = 2;
	ПервыйВвод = Истина;
	
	ДисконтнаяКарта = Параметры.ДисконтнаяКарта;
	БонуснаяПрограммаЛояльности = Параметры.БонуснаяПрограммаЛояльности;
	УникальныйИдентификаторФормыВладельца = Новый УникальныйИдентификатор(Параметры.УникальныйИдентификатор);
	ОписаниеБонуснойПрограммы = Строка(ДисконтнаяКарта) + Символы.ПС + Строка(БонуснаяПрограммаЛояльности);
	КурсКонвертацииБонусовВВалюту = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БонуснаяПрограммаЛояльности, "КурсКонвертацииБонусовВВалюту");
	Если КурсКонвертацииБонусовВВалюту = 0 Тогда
		КурсКонвертацииБонусовВВалюту = 1;
	КонецЕсли;

	// Расчет максимальной суммы оплаты бонусами.
	ТабличнаяЧастьТовары = ПолучитьИзВременногоХранилища(Параметры.АдресТабличнойЧастиТовары);
	ТаблицаРезультат = БонусныеБаллыСервер.ТаблицаМаксимальныхСуммОплаты(
						ТабличнаяЧастьТовары,
						БонуснаяПрограммаЛояльности,
						Параметры.Магазин);
	
	МаксимальнаяСуммаОплаты = ТаблицаРезультат.Итог("МаксимальнаяСуммаОплаты");
	МаксимальнаяСуммаОплатыВБаллах = Цел(МаксимальнаяСуммаОплаты / КурсКонвертацииБонусовВВалюту);
	МаксимальнаяСуммаОплаты = Окр(МаксимальнаяСуммаОплатыВБаллах * КурсКонвертацииБонусовВВалюту, 2);
	
	ОстаткиБонусныхБаллов.Загрузить(БонусныеБаллыСервер.ОстаткиИДвиженияБонусныхБаллов(Параметры.ДисконтнаяКарта));
	
	НачальныйОстатокВБаллах = ОстаткиБонусныхБаллов[0].Сумма;
	НачальныйОстаток = Окр(НачальныйОстатокВБаллах * КурсКонвертацииБонусовВВалюту, 2);

	МаксимальнаяСуммаОплаты        = Мин(МаксимальнаяСуммаОплаты, НачальныйОстаток);
	МаксимальнаяСуммаОплатыВБаллах = Мин(МаксимальнаяСуммаОплатыВБаллах, НачальныйОстатокВБаллах);
	//
	Если НачальныйОстатокВБаллах <= 0 Тогда
		СтрокаМаксимальнойСуммы = НСтр("ru = 'Невозможно оплатить покупку баллами:'") + Символы.ПС + НСтр("ru = 'накоплено 0 бонусных баллов'");
		ОписаниеМаксимальнаяСуммаОплаты = СтрокаМаксимальнойСуммы;
		Элементы.КомандаEnter.Доступность = Ложь;
	ИначеЕсли МаксимальнаяСуммаОплаты <= 0 Тогда
		Если ТаблицаРезультат.Количество() > 0 Тогда
			СтрокаМаксимальнойСуммы = НСтр("ru = 'Невозможно оплатить покупку баллами:'") + Символы.ПС + НСтр("ru = 'достигнуты максимальные суммы скидок'");
		Иначе
			СтрокаМаксимальнойСуммы = НСтр("ru = 'Невозможно оплатить покупку баллами:'") + Символы.ПС + НСтр("ru = 'нет товаров для оплаты баллами'");
		КонецЕсли;
		ОписаниеМаксимальнаяСуммаОплаты = СтрокаМаксимальнойСуммы;
		Элементы.КомандаEnter.Доступность = Ложь;
	Иначе
		СтрокаМаксимальнойСуммы = НСтр("ru = 'Максимальная сумма оплаты:'") + Символы.ПС + НСтр("ru = '%1 руб. (%2 бонусных баллов)'");
		ОписаниеМаксимальнаяСуммаОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаМаксимальнойСуммы, МаксимальнаяСуммаОплаты, МаксимальнаяСуммаОплатыВБаллах);
		Элементы.КомандаEnter.Доступность = Истина;
	КонецЕсли;
	
	СуммаОплаты        = МаксимальнаяСуммаОплаты;
	СуммаОплатыВБаллах = МаксимальнаяСуммаОплатыВБаллах;
	
	Параметры.Свойство("УменьшатьСуммуЧекаДляСкидокНаСуммуБонусов", УменьшатьСуммуЧекаДляСкидокНаСуммуБонусов);
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ТаблицаРезультат, УникальныйИдентификаторФормыВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаОплатыПриИзменении(Элемент = Неопределено)
	
	СтрокаПредупреждения = "";
	Если СуммаОплаты > МаксимальнаяСуммаОплаты Тогда
		СтрокаПредупреждения = НСтр("ru = 'Максимальная сумма оплаты %1 руб'");
		СуммаОплаты = МаксимальнаяСуммаОплаты;
		ПервыйВвод = Истина;
	КонецЕсли;
	СуммаОплатыВБаллах = Цел(СуммаОплаты / КурсКонвертацииБонусовВВалюту);
	СуммаОплаты = Окр(СуммаОплатыВБаллах * КурсКонвертацииБонусовВВалюту, 2);
	Если НЕ ПустаяСтрока(СтрокаПредупреждения) Тогда
		СтрокаПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПредупреждения, СуммаОплаты);
		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(СтрокаПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаОплатыВБаллахПриИзменении(Элемент = Неопределено)
	
	Если СуммаОплатыВБаллах > МаксимальнаяСуммаОплатыВБаллах Тогда
		СтрокаПредупреждения = НСтр("ru = 'Максимальная сумма оплаты %1 руб'");
		СуммаОплатыВБаллах = МаксимальнаяСуммаОплатыВБаллах;
		ПервыйВвод = Истина;
	КонецЕсли;
	СуммаОплаты = Окр(СуммаОплатыВБаллах * КурсКонвертацииБонусовВВалюту, 2);
	Если НЕ ПустаяСтрока(СтрокаПредупреждения) Тогда
		СтрокаПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПредупреждения, СуммаОплаты);
		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(СтрокаПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Команда0(Команда)
	
	ДобавитьЦифру("0")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	
	ДобавитьЦифру("1")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2(Команда)
	
	ДобавитьЦифру("2")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда3(Команда)
	
	ДобавитьЦифру("3")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда4(Команда)
	
	ДобавитьЦифру("4")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда5(Команда)
	
	ДобавитьЦифру("5")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда6(Команда)
	
	ДобавитьЦифру("6")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда7(Команда)
	
	ДобавитьЦифру("7")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда8(Команда)
	
	ДобавитьЦифру("8")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда9(Команда)
	
	ДобавитьЦифру("9")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда0ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("0")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("1")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("2")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда3ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("3")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда4ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("4")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда5ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("5")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда6ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("6")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда7ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("7")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда8ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("8")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда9ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("9")
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаТочка(Команда)
	
	Если ПервыйВвод Тогда
		ВводимоеЧисло = "";
		ПервыйВвод = Ложь;
	КонецЕсли;
	
	Если ВводимоеЧисло = "" Тогда
		ВводимоеЧисло = "0";
	КонецЕсли;
	
	ЧислоВхождений = СтрЧислоВхождений(ВводимоеЧисло, ",");
	
	Если Не ЧислоВхождений > 0 Тогда
		ВводимоеЧисло = ВводимоеЧисло + ",";
	КонецЕсли;
	
	Если СуммаОплатыВБаллах > 0 Тогда
		ТекущийЭлемент = Элементы.КомандаEnter;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСтереть(Команда)
	
	ВводимоеЧисло = "";
	ПервыйВвод = Ложь;
	СуммаОплаты = 0;
	СуммаОплатыВБаллах = 0;
	Элементы.КомандаEnterПраваяКлавиатура.Доступность = Ложь;
	Элементы.КомандаEnter.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаМаксимальнаяСумма(Команда)
	
	СуммаОплаты        = МаксимальнаяСуммаОплаты;
	СуммаОплатыВБаллах = МаксимальнаяСуммаОплатыВБаллах;
	ВводимоеЧисло = Формат(СуммаОплатыВБаллах, "ЧРД=,; ЧН=0; ЧГ=0");
	ПервыйВвод = Истина;
	Элементы.КомандаEnterПраваяКлавиатура.Доступность = Истина;
	Элементы.КомандаEnter.Доступность = Истина;
	Если СуммаОплатыВБаллах > 0 Тогда
		ТекущийЭлемент = Элементы.КомандаEnter;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаEnter(Команда)
	
	Если СуммаОплатыВБаллах > 0 И СуммаОплаты > 0 Тогда
		ПараметрыДанных = Новый Структура;
		ПараметрыДанных.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище());
		ПараметрыДанных.Вставить("БонуснаяПрограмма", БонуснаяПрограммаЛояльности);
		ПараметрыДанных.Вставить("УменьшатьСуммуЧекаДляСкидокНаСуммуБонусов", УменьшатьСуммуЧекаДляСкидокНаСуммуБонусов);
		Закрыть(ПараметрыДанных);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресВоВременномХранилище()
	
	ТаблицаРаспределения = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	БонусныеБаллыСервер.РаспределитьСуммуОплатыПоТоварам(ТаблицаРаспределения, СуммаОплаты, СуммаОплатыВБаллах);
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаРаспределения, УникальныйИдентификаторФормыВладельца);
	
КонецФункции

&НаКлиенте
Процедура ДобавитьЦифру(ВведеннаяЦифраСтрокой)
	
	Если ПервыйВвод Тогда
		ВводимоеЧисло = "";
		ПервыйВвод = Ложь;
	КонецЕсли;
	
	Запятая = Сред(ВводимоеЧисло, СтрДлина(ВводимоеЧисло) - КоличествоСимволовПослеЗапятой, 1);
	
	Если НЕ Запятая = "," Тогда
		ВводимоеЧисло = ВводимоеЧисло + ВведеннаяЦифраСтрокой;
	КонецЕсли;
	
	СуммаОплатыВБаллах = ПривестиСтрокуКЧислу(ВводимоеЧисло, Истина);
	СуммаОплатыВБаллахПриИзменении();
	
	Элементы.КомандаEnterПраваяКлавиатура.Доступность = СуммаОплатыВБаллах > 0;
	Элементы.КомандаEnter.Доступность = СуммаОплатыВБаллах > 0;
	
	Если СуммаОплатыВБаллах > 0 Тогда
		ТекущийЭлемент = Элементы.КомандаEnter;
	КонецЕсли;
	
КонецПроцедуры

// Функция выполняет приведение строки к числу.
// Параметры:
//  ЧислоСтрокой           - Строка - Строка приводимая к числу.
//  ВозвращатьНеопределено - Булево - Если Истина и строка содержит некорректное значение, то возвращать Неопределено.
//
// Возвращаемое значение:
//  Число
//
&НаКлиенте
Функция ПривестиСтрокуКЧислу(ЧислоСтрокой, ВозвращатьНеопределено = Ложь)
	
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеЧисла = ОписаниеТипаЧисла.ПривестиЗначение(ЧислоСтрокой);
	
	Если ВозвращатьНеопределено И (ЗначениеЧисла = 0) Тогда
		
		Стр = Строка(ЧислоСтрокой);
		Если Стр = "" Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Стр = СтрЗаменить(СокрЛП(Стр), "0", "");
		Если (Стр <> "") И (Стр <> ".") И (Стр <> ",") Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеЧисла;
	
КонецФункции

#КонецОбласти
