﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру с параметрами учетной политики по сериям.
//
//	Параметры:
//		ВидНоменклатуры - вид номенклатуры для которого нужно получить параметры учетной политики по сериям.
//		Склад - склад, для которого нужно получить параметры учетной политики по сериям.
//	Возвращаемое значение:
//		Структура
//
Функция ПараметрыПолитикиУчетаСерийПоВидуНоменклатуры(ВидНоменклатуры, Магазин) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ВидНоменклатуры");
	Результат.Вставить("ИспользоватьСерии");
	Результат.Вставить("ИспользоватьНомерСерии");
	Результат.Вставить("ИспользоватьСрокГодностиСерии");
	Результат.Вставить("ИспользоватьКоличествоСерии");
	Результат.Вставить("ТочностьУказанияСрокаГодностиСерии");
	Результат.Вставить("ИспользоватьRFIDМеткиСерии");
	Результат.Вставить("ИспользоватьНомерКИЗГИСМСерии");
	
	Результат.Вставить("ФорматнаяСтрокаСрокаГодности");
	Результат.Вставить("ОбязательныеДопРеквизиты");
	
	Результат.Вставить("ПолитикаУчетаСерий");
	Результат.Вставить("УказыватьПриПоступлении");
	Результат.Вставить("УказыватьПриОтгрузке");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыНоменклатуры.Ссылка КАК ВидНоменклатуры,
	|	ВидыНоменклатуры.ИспользоватьСерии КАК ИспользоватьСерии,
	|	ВидыНоменклатуры.ИспользоватьНомерСерии КАК ИспользоватьНомерСерии,
	|	ВидыНоменклатуры.ИспользоватьСрокГодностиСерии КАК ИспользоватьСрокГодностиСерии,
	|	ВидыНоменклатуры.ИспользоватьКоличествоСерии КАК ИспользоватьКоличествоСерии,
	|	ВидыНоменклатуры.ТочностьУказанияСрокаГодностиСерии КАК ТочностьУказанияСрокаГодностиСерии,
	|	ВидыНоменклатуры.ИспользоватьRFIDМеткиСерии КАК ИспользоватьRFIDМеткиСерии,
	|	ВидыНоменклатуры.ИспользоватьНомерКИЗГИСМСерии КАК ИспользоватьНомерКИЗГИСМСерии,
	|	ЕСТЬNULL(ТЧПолитикиУчетаСерий.ПолитикаУчетаСерий, ЗНАЧЕНИЕ(Справочник.ПолитикиУчетаСерий.ПустаяСсылка)) КАК ПолитикаУчетаСерий,
	|	ЕСТЬNULL(ТЧПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке, ЛОЖЬ) КАК УказыватьПриПоступлении,
	|	ЕСТЬNULL(ТЧПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузке, ЛОЖЬ) КАК УказыватьПриОтгрузке
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ТЧПолитикиУчетаСерий
	|		ПО ВидыНоменклатуры.Ссылка = ТЧПолитикиУчетаСерий.Ссылка
	|			И (ТЧПолитикиУчетаСерий.Магазин = &Магазин)
	|ГДЕ
	|	ВидыНоменклатуры.Ссылка = &ВидНоменклатуры";
	
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыШапки = РезультатЗапроса[0].Выбрать();
	РеквизитыШапки.Следующий();
	
	ЗаполнитьЗначенияСвойств(Результат, РеквизитыШапки);
	Результат.ФорматнаяСтрокаСрокаГодности = ФорматнаяСтрокаСрокаГодности(Результат.ТочностьУказанияСрокаГодностиСерии);
		
	Возврат Результат;
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//	Возвращаемое значение:
//		Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ТипПолитики");
	
	Результат.Добавить("УказыватьПриОтгрузке");
	Результат.Добавить("УказыватьПриОтгрузкеВРозницу");
	Результат.Добавить("УказыватьПриОтгрузкеКлиенту");
	Результат.Добавить("УказыватьПриОтгрузкеКомплектовДляРазборки");
	Результат.Добавить("УказыватьПриОтгрузкеКомплектующихДляСборки");
	Результат.Добавить("УказыватьПриОтгрузкеПоВозвратуПоставщику");
	Результат.Добавить("УказыватьПриОтгрузкеПоПеремещению");
	
	Результат.Добавить("УказыватьПриПриемке");
	Результат.Добавить("УказыватьПриПриемкеКомплектующихПослеРазборки");
	Результат.Добавить("УказыватьПриПриемкеОтПоставщика");
	Результат.Добавить("УказыватьПриПриемкеПоВозвратуОтКлиента");
	Результат.Добавить("УказыватьПриПриемкеПоПеремещению");
	Результат.Добавить("УказыватьПриПриемкеСобранныхКомплектов");
	
	Результат.Добавить("УказыватьПриПересчетеТоваров");
	Результат.Добавить("УказыватьПриОтраженииИзлишковНедостачПорчи");
	
	Результат.Добавить("УказыватьПриМаркировкеПродукцииДляГИСМ");
	Возврат Результат;

КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Возвращает форматную строку представления срока годности.
//
// Параметры:
//	ТочностьУказанияСрокаГодности - Перечисления.ТочностиУказанияСрокаГодности
//
//	Возвращаемое значание:
//		Строка - форматная строка
//
Функция ФорматнаяСтрокаСрокаГодности(ТочностьУказанияСрокаГодности)Экспорт
	
	Если ТочностьУказанияСрокаГодности = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоЧасов Тогда
		ФорматнаяСтрока = "ДФ='dd.MM.yy HH:00'";
	Иначе
		ФорматнаяСтрока = "ДФ=dd.MM.yy";
	КонецЕсли;
	
	Возврат ФорматнаяСтрока;
	
КонецФункции

#КонецОбласти