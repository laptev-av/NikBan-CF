﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученМагнитныйКод(МагнитныйКод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	Если СтрокаРезультата.Свойство("Карта") Тогда
		Если СтрокаРезультата.ЭтоРегистрационнаяКарта Тогда
			ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		Иначе
			ИдентификаторСтроки = ДобавитьНайденнуюКарту(СтрокаРезультата);
			Если ИдентификаторСтроки <> Неопределено Тогда
				СтруктураРезультат.Вставить("НайденаДисконтнаяКарта", СтрокаРезультата.Карта);
				СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ТекстПредупреждения = НСтр("ru = 'По коду ""%1"" найден номер подарочного сертификата. Обработка сертификатов в документе не предусмотрена'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, СтруктураРезультат.ДанныеПО);
		СтруктураРезультат.Вставить("ТекстПредупреждения", ТекстПредупреждения);
		
	Иначе // Номенклатура.
		
		ТекстПредупреждения = НСтр("ru = 'По коду ""%1"" найдена номенклатура. Обработка номенклатуры в документе не предусмотрена'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, СтруктураРезультат.ДанныеПО);
		СтруктураРезультат.Вставить("ТекстПредупреждения", ТекстПредупреждения);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьДанныеИзТСДСервер(СтруктураПараметров) Экспорт
	
	Результат = ПодключаемоеОборудованиеРТВызовСервера.ОбработатьДанныеПоДисконтнымКартамИзТСДСервер(ЭтотОбъект, СтруктураПараметров);
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденнуюКарту(СтрокаРезультата) Экспорт
	
	Если ЗначениеЗаполнено(ИмяТаблицыВыборки) Тогда
		ИдентификаторСтроки = Неопределено;
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ДисконтнаяКарта", СтрокаРезультата.Карта);
		НайденныеСтроки = Объект[ИмяТаблицыВыборки].НайтиСтроки(СтруктураПоиска);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
		Иначе
			Модифицированность = Истина;
			НоваяСтрока = Объект[ИмяТаблицыВыборки].Добавить();
			НоваяСтрока.ДисконтнаяКарта = СтрокаРезультата.Карта;
			ИдентификаторСтроки = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ЗаполнитьПоПравилуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьНаСервере();
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
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.ГруппаКомментарий, Объект.Комментарий);
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МассивКомандПО = Новый Массив;
	МассивКомандПО.Добавить("НачисленияЗагрузитьДанныеИзТСД");
	МассивКомандПО.Добавить("СписанияЗагрузитьДанныеИзТСД");
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект, МассивКомандПО);
	ПараметрыСобытийПО = Новый Структура;
	ПараметрыСобытийПО.Вставить("РегистрацияНовойКарты", Истина);
	// Конец ПодключаемоеОборудование
	
	ИмяТаблицыВыборки = ИмяТаблицыВыборки(Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя);
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(
		Объект,
		КартинкаСостоянияДокумента,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		РазрешеноПроведение);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.ГруппаКомментарий, Объект.Комментарий);
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользоватьПравилоНачисления = 1 И Не ЗначениеЗаполнено(Объект.ПравилоНачисления) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Нстр("ru = 'Поле ""Правило начисления"" не заполнено.'"),,"Объект.ПравилоНачисления",, Отказ);
		
	КонецЕсли;
	
	Если ИспользоватьПериодДействия = 2 И Не ЗначениеЗаполнено(Объект.ДатаОкончанияСрокаДействия) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Нстр("ru = 'Поле ""Дата окончания срока действия"" не заполнено.'"),,"Объект.ДатаОкончанияСрокаДействия",, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен()
		И ЗначениеЗаполнено(Объект.БонуснаяПрограммаЛояльности)
		И ЗначениеЗаполнено(ИмяТаблицыВыборки) Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
		
	// &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// &ЗамерПроизводительности  	
	Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
	                                            "Документ.НачислениеИСписаниеБонусныхБаллов.ФормаДокумента.Запись",
                                                            Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БонуснаяПрограммаЛояльностиПриИзменении(Элемент)
	ИзменитьДоступность(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПериодДействияПриИзменении(Элемент)
	
	ИзменитьДоступность(ЭтаФорма);
	
	Если ИспользоватьПериодДействия = 1 Тогда
		Объект.КоличествоПериодовДействия = 1;
	Иначе
		Объект.КоличествоПериодовДействия = 0;
	КонецЕсли;
	
	Если ИспользоватьПериодДействия <> 2 Тогда
		Объект.ДатаОкончанияСрокаДействия = Неопределено;
	КонецЕсли;
	
	ЗаполнитьСвойстваЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтсрочкуНачалаДействияПриИзменении(Элемент)
	
	ИзменитьДоступность(ЭтаФорма);
	
	Объект.КоличествоПериодовОтсрочкиНачалаДействия = ИспользоватьОтсрочкуНачалаДействия;
	
	ЗаполнитьСвойстваЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПравилоНачисленияПриИзменении(Элемент)
	
	Объект.ПравилоНачисления = ПредопределенноеЗначение("Справочник.ПравилаНачисленияБонусныхБаллов.ПустаяСсылка");
	
	ПравилоНачисленияПриИзмененииНаСервере();
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоНачисленияПриИзменении(Элемент)
	ПравилоНачисленияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ИмяТаблицыВыборки = ИмяТаблицыВыборки(ТекущаяСтраница.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура БонуснаяПрограммаЛояльностиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.БонусныеПрограммыЛояльности.Форма.ФормаСписка.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	Если ЗначениеЗаполнено(ИмяТаблицыВыборки) Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ЕстьКоличество", Ложь);
		ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	Если ЗначениеЗаполнено(ИмяТаблицыВыборки) Тогда
		ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	Если ЗначениеЗаполнено(ИмяТаблицыВыборки) Тогда
		ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗаполнитьПоПравилу(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	Если Объект.Начисление.Количество() > 0
		ИЛИ Объект.Списание.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Таблицы начисления и списания будут перезаполнены.
							|Продолжить?'");
		ОбработчикОповещения = Новый ОписаниеОповещения("ЗаполнитьПоПравилуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПоПравилуЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьНастройкиФормы(ЭтаФорма);
	ЗаполнитьСвойстваЭлементов(ЭтаФорма);
	
	ВидПравила = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПравилоНачисления, "ВидПравила");
	Элементы.ГруппаНачисления.Видимость = (ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление)
										ИЛИ НЕ ЗначениеЗаполнено(Объект.ПравилоНачисления);
	Элементы.ГруппаСписания.Видимость   = (ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание)
										ИЛИ НЕ ЗначениеЗаполнено(Объект.ПравилоНачисления);
	ИзменитьДоступность(ЭтаФорма);
	Элементы.ГруппаСрокиДействия.Доступность = НЕ ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание;

	
КонецПроцедуры

&НаСервере
Процедура ПравилоНачисленияПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПравилаНачисленияБонусныхБаллов.ПериодДействия                           КАК ПериодДействия,
	|	ПравилаНачисленияБонусныхБаллов.КоличествоПериодовДействия               КАК КоличествоПериодовДействия,
	|	ПравилаНачисленияБонусныхБаллов.КоличествоПериодовОтсрочкиНачалаДействия КАК КоличествоПериодовОтсрочки,
	|	ПравилаНачисленияБонусныхБаллов.ПериодОтсрочкиНачалаДействия             КАК ПериодОтсрочкиНачалаДействия,
	|	ПравилаНачисленияБонусныхБаллов.ВидПравила                               КАК ВидПравила
	|ИЗ
	|	Справочник.ПравилаНачисленияБонусныхБаллов КАК ПравилаНачисленияБонусныхБаллов
	|ГДЕ
	|	ПравилаНачисленияБонусныхБаллов.Ссылка = &ПравилоНачисления
	|");
	
	Запрос.УстановитьПараметр("ПравилоНачисления", Объект.ПравилоНачисления);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		ВидПравила = Выборка.ВидПравила;
		
		Элементы.ГруппаНачисления.Видимость = (ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление)
											ИЛИ НЕ ЗначениеЗаполнено(Объект.ПравилоНачисления);
		Элементы.ГруппаСписания.Видимость   = (ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание)
											ИЛИ НЕ ЗначениеЗаполнено(Объект.ПравилоНачисления);
		Если ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление Тогда
			Объект.Списание.Очистить();
		ИначеЕсли ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание Тогда
			Объект.Начисление.Очистить();
		КонецЕсли;
		
		Объект.КоличествоПериодовДействия               = Выборка.КоличествоПериодовДействия;
		Объект.КоличествоПериодовОтсрочкиНачалаДействия = Выборка.КоличествоПериодовОтсрочки;
		Объект.ПериодОтсрочкиНачалаДействия             = Выборка.ПериодОтсрочкиНачалаДействия;
		Объект.ПериодДействия                           = Выборка.ПериодДействия;
		Объект.ДатаОкончанияСрокаДействия               = Неопределено;
		
		ИспользоватьПравилоНачисления      = ?(ЗначениеЗаполнено(Объект.ПравилоНачисления), 1, 0);
		ИспользоватьОтсрочкуНачалаДействия = ?(Объект.КоличествоПериодовОтсрочкиНачалаДействия > 0, 1, 0);
		
		Если Объект.КоличествоПериодовДействия > 0 Тогда
			ИспользоватьПериодДействия = 1;
		ИначеЕсли ЗначениеЗаполнено(Объект.ДатаОкончанияСрокаДействия) Тогда
			ИспользоватьПериодДействия = 2;
		Иначе
			ИспользоватьПериодДействия = 0;
		КонецЕсли;
		
		ИзменитьДоступность(ЭтаФорма);
		Элементы.ГруппаСрокиДействия.Доступность = НЕ ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание;
		
	Иначе
		
		Элементы.ГруппаНачисления.Видимость = Истина;
		Элементы.ГруппаСписания.Видимость   = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Начисление.Очистить();
	Объект.Списание.Очистить();
	
	ДатаРасчета = Объект.Дата;
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	Если Объект.Ссылка.Пустая()
		И НачалоДня(ТекущаяДатаСеанса) = НачалоДня(Объект.Дата) Тогда
		ДатаРасчета = ТекущаяДатаСеанса;
	КонецЕсли;
		
	ТаблицаНачислениеИСписание = БонусныеБаллыСервер.ТаблицаНачислениеИСписание(Объект.ПравилоНачисления, ДатаРасчета);
	ВидПравила = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПравилоНачисления, "ВидПравила");
	ИмяТаблицы = ?(ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание, "Списание", "Начисление");
	Если ТаблицаНачислениеИСписание <> Неопределено Тогда
		ЗаполнятьДополнительнуюКолонку = Ложь;
		Если ИмяТаблицы = "Списание" Тогда
			ДополнительнаяКолонка = ТаблицаНачислениеИСписание.Колонки.Найти("БаллыКСписанию");
			Если ДополнительнаяКолонка <> Неопределено Тогда
				ЗаполнятьДополнительнуюКолонку = Истина;
			КонецЕсли;
		КонецЕсли;
		Для Каждого СтрокаТЧ Из ТаблицаНачислениеИСписание Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.ДисконтнаяКарта) Тогда
				НоваяСтрока = Объект[ИмяТаблицы].Добавить();
				НоваяСтрока.ДисконтнаяКарта = СтрокаТЧ.ДисконтнаяКарта;
				НоваяСтрока.Баллы = СтрокаТЧ.КоличествоБаллов;
				Если ЗаполнятьДополнительнуюКолонку Тогда
					НоваяСтрока.БаллыКСписанию = СтрокаТЧ.БаллыКСписанию;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьДоступность(Форма)
	
	Форма.Элементы.ГруппаСрокДействияПраво.Доступность    = (Форма.ИспользоватьПериодДействия >= 1);
	Форма.Элементы.ГруппаОграниченПериодом.Видимость    = (Форма.ИспользоватьПериодДействия = 1);
	Форма.Элементы.ДатаОкончанияСрокаДействия.Видимость = (Форма.ИспользоватьПериодДействия = 2);
	
	Форма.Элементы.ГруппаОтсрочкаПраво.Видимость          = (Форма.ИспользоватьОтсрочкуНачалаДействия = 1);

	Форма.Элементы.ГруппаПравилоНачисления.ТолькоПросмотр = НЕ (Форма.ИспользоватьПравилоНачисления = 1);
	Форма.Элементы.ПравилоНачисления.Видимость = (Форма.ИспользоватьПравилоНачисления = 1);
	Форма.Элементы.ПравилоНачисления.ОтметкаНезаполненного = (Форма.ИспользоватьПравилоНачисления = 1);
	Форма.Элементы.ПравилоНачисления.АвтоОтметкаНезаполненного = (Форма.ИспользоватьПравилоНачисления = 1);
	
	ДоступностьЗаполнения = ЗначениеЗаполнено(Форма.Объект.ПравилоНачисления);
	Форма.Элементы.НачисленияЗаполнить.Доступность = ДоступностьЗаполнения;
	Форма.Элементы.СписанияЗаполнить.Доступность = ДоступностьЗаполнения;
	
	ДоступностьВсехЭлементов = ЗначениеЗаполнено(Форма.Объект.БонуснаяПрограммаЛояльности);
	Форма.Элементы.ГруппаСписания.ТолькоПросмотр = НЕ ДоступностьВсехЭлементов;
	Форма.Элементы.ГруппаНачисления.ТолькоПросмотр = НЕ ДоступностьВсехЭлементов;
	Форма.Элементы.ГруппаСрокиДействия.ТолькоПросмотр = НЕ ДоступностьВсехЭлементов;
	Форма.Элементы.ГруппаПравилоНачисления.ТолькоПросмотр = НЕ ДоступностьВсехЭлементов;
	Форма.Элементы.МаркетинговоеМероприятие.ТолькоПросмотр = НЕ ДоступностьВсехЭлементов;
	
	
	Форма.Элементы.НачисленияПоискПоШтрихкоду.Доступность = ДоступностьВсехЭлементов;
	Форма.Элементы.НачисленияПоискПоМагнитномуКоду.Доступность = ДоступностьВсехЭлементов;
	Форма.Элементы.НачисленияЗагрузитьДанныеИзТСД.Доступность = ДоступностьВсехЭлементов;
	Форма.Элементы.СписанияПоискПоШтрихкоду.Доступность = ДоступностьВсехЭлементов;
	Форма.Элементы.СписанияПоискПоМагнитномуКоду.Доступность = ДоступностьВсехЭлементов;
	Форма.Элементы.СписанияЗагрузитьДанныеИзТСД.Доступность = ДоступностьВсехЭлементов;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНастройкиФормы(Форма)
	
	Форма.ИспользоватьПравилоНачисления      = ?(ЗначениеЗаполнено(Форма.Объект.ПравилоНачисления), 1, 0);
	Форма.ИспользоватьОтсрочкуНачалаДействия = ?(Форма.Объект.КоличествоПериодовОтсрочкиНачалаДействия > 0, 1, 0);
	
	Если Форма.Объект.КоличествоПериодовДействия > 0 Тогда
		Форма.ИспользоватьПериодДействия = 1;
	ИначеЕсли ЗначениеЗаполнено(Форма.Объект.ДатаОкончанияСрокаДействия) Тогда
		Форма.ИспользоватьПериодДействия = 2;
	Иначе
		Форма.ИспользоватьПериодДействия = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСвойстваЭлементов(Форма)
	
	Форма.Элементы.ПериодДействия.АвтоОтметкаНезаполненного = Форма.ИспользоватьПериодДействия = 1;
	Форма.Элементы.ПериодДействия.ОтметкаНезаполненного = Форма.ИспользоватьПериодДействия = 1;
		
	Форма.Элементы.ДатаОкончанияСрокаДействия.АвтоОтметкаНезаполненного = Форма.ИспользоватьПериодДействия = 2;
	Форма.Элементы.ДатаОкончанияСрокаДействия.ОтметкаНезаполненного = Форма.ИспользоватьПериодДействия = 2;
		
	Форма.Элементы.ПериодОтсрочкиНачалаДействия.АвтоОтметкаНезаполненного = Форма.ИспользоватьОтсрочкуНачалаДействия = 1;
	Форма.Элементы.ПериодОтсрочкиНачалаДействия.ОтметкаНезаполненного = Форма.ИспользоватьОтсрочкуНачалаДействия = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	Если ЗначениеЗаполнено(ИмяТаблицыВыборки) Тогда
		ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента, ИмяТаблицыВыборки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяТаблицыВыборки(ИмяСтраницы)
	
	ИмяТаблицы = "";
	Если ИмяСтраницы = "ГруппаНачисления" Тогда
		ИмяТаблицы = "Начисление";
	ИначеЕсли ИмяСтраницы = "ГруппаСписания" Тогда
		ИмяТаблицы = "Списание";
	КонецЕсли;

	Возврат ИмяТаблицы;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.ГруппаКомментарий, Объект.Комментарий);
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
