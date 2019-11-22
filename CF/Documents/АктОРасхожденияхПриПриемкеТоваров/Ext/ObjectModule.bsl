﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет данные по товарам из документа-основания
//
Процедура ЗаполнитьТоварыПоОснованию() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеремещениеТоваровТовары.НомерСтроки КАК НомерСтроки,
	|	ПеремещениеТоваровТовары.Номенклатура,
	|	ПеремещениеТоваровТовары.Характеристика,
	|	ПеремещениеТоваровТовары.Упаковка,
	|	ПеремещениеТоваровТовары.Количество,
	|	ПеремещениеТоваровТовары.КоличествоУпаковок,
	|	ПеремещениеТоваровТовары.Количество КАК КоличествоВДокументе,
	|	ПеремещениеТоваровТовары.КоличествоУпаковок КАК КоличествоУпаковокВДокументе,
	|	ПеремещениеТоваровТовары.СтатусУказанияСерий,
	|	ПеремещениеТоваровТовары.КлючСвязиСерийныхНомеров,
	|	ИСТИНА КАК ЗаполненоПоОснованию
	|ИЗ
	|	Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	|ГДЕ
	|	ПеремещениеТоваровТовары.Ссылка = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремещениеТоваровСерии.Серия,
	|	ПеремещениеТоваровСерии.Количество,
	|	ПеремещениеТоваровСерии.Номенклатура,
	|	ПеремещениеТоваровСерии.Характеристика
	|ИЗ
	|	Документ.ПеремещениеТоваров.Серии КАК ПеремещениеТоваровСерии
	|ГДЕ
	|	ПеремещениеТоваровСерии.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремещениеТоваровСерийныеНомера.СерийныйНомер,
	|	ПеремещениеТоваровСерийныеНомера.КлючСвязиСерийныхНомеров
	|ИЗ
	|	Документ.ПеремещениеТоваров.СерийныеНомера КАК ПеремещениеТоваровСерийныеНомера
	|ГДЕ
	|	ПеремещениеТоваровСерийныеНомера.Ссылка = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Если РезультатЗапроса[0].Пустой() Тогда
		Товары.Очистить();
		Серии.Очистить();
		СерийныеНомера.Очистить();
	Иначе
		Товары.Загрузить(РезультатЗапроса[0].Выгрузить());
		Серии.Загрузить(РезультатЗапроса[1].Выгрузить());
		СерийныеНомера.Загрузить(РезультатЗапроса[2].Выгрузить());
	КонецЕсли;

КонецПроцедуры // ЗаполнитьТоварыПоОснованию()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
	
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.МагазинПолучатель.ИспользоватьОрдернуюСхемуПриПеремещении Тогда
		
			ТекстОшибки = НСтр("ru='В магазине ""%1"" используется ордерная схема при перемещении. Фактическое количество указывается документом ""Приходный ордер"".'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДанныеЗаполнения.МагазинПолучатель);
			
			ВызватьИсключение ТекстОшибки;
		
		ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.ТТНВходящаяЕГАИС) ИЛИ ЗначениеЗаполнено(ДанныеЗаполнения.ТТНИсходящаяЕГАИС) Тогда
		
			ТекстОшибки = НСтр("ru='Документ был получен/отправлен через ЕГАИС. Ввод акта расхождений для него не поддерживается.'");
			
			ВызватьИсключение ТекстОшибки;
		
		КонецЕсли; 
		
		Реквизиты = Новый Структура("ДокументОснование, Организация, ОрганизацияПолучатель, МагазинОтправитель, МагазинПолучатель, СкладОтправитель, СкладПолучатель", "Ссылка");
		
		ЗначенияРеквизитов = ОбщегоНазначенияРТ.ПолучитьЗначенияРеквизитовОбъекта(ДанныеЗаполнения, Реквизиты);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
		
		ЗаполнитьТоварыПоОснованию();
	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		
		ТекстСообщения = НСтр("ru='Акт о расхождениях можно вводить только на основании документа поставки.'");
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.АктОРасхожденияхПриПриемкеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	Если ДополнительныеСвойства.ИспользуетсяКомиссионнаяТорговля Тогда
		ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитенту(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияНоменклатураПоставщиков(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСебестоимостьНоменклатуры(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСебестоимостьПоставкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьРасхожденияПриПриемке(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);

	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если МагазинОтправитель = МагазинПолучатель Тогда
		
		ТекстСообщения = НСтр("ru = '""Акт о расхождениях при приемке товаров"" не предназначен для отражения расхождений между складами одного магазина'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"МагазинПолучатель",
			,
			Отказ);
			
	ИначеЕсли СкладОтправитель = СкладПолучатель Тогда
		
		ТекстСообщения = НСтр("ru = 'Склад отправитель и склад получатель не могут быть одним и тем же складом'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"СкладПолучатель",
			,
			Отказ);
			
	ИначеЕсли МагазинОтправитель.СкладУправляющейСистемы
		И МагазинПолучатель.СкладУправляющейСистемы Тогда
		
		ТекстСообщения = НСтр("ru = 'Расхождение между складами управляющей системы оформляется в управляющей системе'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"МагазинПолучатель",
			,
			Отказ);
				
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковокВДокументе");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоВДокументе");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	Если МагазинОтправитель.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СкладОтправитель");
	КонецЕсли;
	Если МагазинПолучатель.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СкладПолучатель");
	КонецЕсли;
	
	Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
		
		ТекущаяСтрока = Товары[ТекИндекс];
		
		Если ТекущаяСтрока.ЗаполненоПоОснованию И НЕ ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковокВДокументе) Тогда
			
			ТекстСообщения = НСтр("ru='Не заполнено поле ""Количество по документу"" в строке %НомерСтроки% списка ""Товары""'");
			ТекстСообщения =  СтрЗаменить(ТекстСообщения, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "КоличествоУпаковокВДокументе"),
				,
				Отказ);
			
		КонецЕсли;
			
		Если НЕ ТекущаяСтрока.ЗаполненоПоОснованию И НЕ ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковок) Тогда
		
			ТекстСообщения = НСтр("ru='Не заполнено поле ""Количество факт"" в строке %НомерСтроки% списка ""Товары""'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "КоличествоУпаковок"),
				,
				Отказ);
		
		КонецЕсли;
		
	КонецЦикла;
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.АктОРасхожденияхПриПриемкеТоваров.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
	МаркетинговыеАкцииСервер.ПроверитьДвиженияСерийныхНомеров(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.СерийныеНомера.ОчиститьВДокументеНеиспользуемыеСерийныеНомера(Товары, СерийныеНомера);
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ОбщегоНазначенияРТ.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект, Документы.АктОРасхожденияхПриПриемкеТоваров.ПараметрыУказанияСерий(ЭтотОбъект));
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("СкладОтправитель")
			И НЕ ЗначениеЗаполнено(СкладОтправитель) Тогда
			Если ЗначениеЗаполнено(МагазинОтправитель) Тогда
				Если НЕ Справочники.Склады.ПроверитьПринадлежностьСкладаМагазину(МагазинОтправитель, ДанныеЗаполнения.СкладОтправитель) Тогда
					ДанныеЗаполнения.СкладОтправитель = Справочники.Склады.ПустаяСсылка();
				КонецЕсли;
			Иначе
				МагазинОтправитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.СкладОтправитель, "Магазин");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	МагазинОтправитель = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(МагазинОтправитель);
	ОрганизацияПолучатель = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(ОрганизацияПолучатель, Ответственный);
	СкладОтправитель   = ЗначениеНастроекПовтИсп.ПолучитьСкладПродажиПоУмолчанию(МагазинОтправитель,,СкладОтправитель, Ответственный);
	СкладПолучатель    = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(МагазинПолучатель,,СкладПолучатель, Ответственный);
	
КонецПроцедуры

// Процедура формирует массив имен регистров для контроля проведения.
//
Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	// При проведении выполняется контроль превышения остатков на складах.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Массив.Добавить(Движения.ТоварыНаСкладах);
		Массив.Добавить(Движения.ДвиженияСерийныхНомеров);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#КонецЕсли